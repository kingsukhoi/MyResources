#!/bin/bash
set -ueo pipefail


#ffmpeg -ss 01:23:45 -i input -frames:v 1 -q:v 2 output.jpg
#
#


getScreenShot(){
  input="$1"
  output="$2"
  time="$3"

  if echo $output | grep 'jpg' ; then
    ffmpeg -ss "$time" -i "$input" -frames:v 1 -q:v 1 "$output"
  else
    echo "invalid format"
    exit 1
  fi
}


main(){
  files=$1

  for file in $files; do
    fileName=$(basename "$file")
    fileName=$(echo $fileName | sed 's:mkv:jpg:')
    getScreenShot "$file" "screenShots/$fileName" '00:04:00'
  done
}

main "$@"
