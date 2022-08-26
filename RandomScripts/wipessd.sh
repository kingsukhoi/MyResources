#!/bin/bash
set -ueo pipefail

password="PasSWorD"

checkForDisk(){
  if hdparm -I "$disk" | grep frozen | grep not; then
    return 0
  else
    echo "sumting wrong" >&2
    exit 1
  fi
}


setPass(){
  hdparm --user-master u --security-set-pass "$password" "$1"
  hdparm -I $1
}

getName(){
  smartctl -ij $1 | jq .model_name -
}

wipeDevice(){
  modelName=$(getName $1)
  read -p "Are you sure you want to wipe $modelName at $1? (only yes will be accepted) " key
  if [[ $key != "yes" ]]; then
    exit 0
  fi
  echo

  hdparm --user-master u --security-erase-enhanced "$password" $1
}

main(){
  disk="$1"
  checkForDisk "$disk"
  setPass "$disk"
  wipeDevice "$disk"
}

main $@
