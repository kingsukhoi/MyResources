#!/bin/bash
set -ueo pipefail

password="PasSWorD"

checkForDisk(){
  if hdparm -I /dev/sda | grep frozen | grep not; then
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
  echo -n "Are you sure you want to wipe $modelName at $1? [yN]"
  read -u 1 -n 1 key
  [[ $key = "yes" ]] &&  rm "$line"
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
