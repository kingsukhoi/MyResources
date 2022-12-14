#!/bin/bash
set -ueo pipefail

while read -r in; do
  if [[ "$in" =~ git@github\.com:.+\/(.+)\.git  ]]; then
    folderName=${BASH_REMATCH[1]}
    if [[ -d $folderName  ]]; then
      echo -e "********
* $folderName
********"
      git -C "$folderName" fetch --all
      git -C "$folderName" checkout develop
      git -C "$folderName" pull -r --all
    else
      git clone "$in"
      git -C "$folderName" checkout develop
    fi
  fi
  echo ""
done < services.txt

