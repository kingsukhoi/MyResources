#!/bin/bash
set -ueo pipefail


doMediainfo(){
  input="$1"
  mediainfo --Output=JSON "$input" | jq .
}

doFfprobe(){
  input="$1"
  ffprobe -v quiet -print_format json -show_format -show_streams "$input" | jq .
}


main(){
  inputFile="$1"

  if [[ ! -f $1 ]]; then
    echo "file not found"
    exit 1
  fi
  mkdir -p mediaInfo
  files=$(cat $inputFile)

  for file in $files; do
    fileName=$(basename "$file")
    doMediainfo "$file" > "mediaInfo/$fileName.json"
  done
}

main "$@"
