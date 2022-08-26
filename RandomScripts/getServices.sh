#!/bin/bash
set -ueo pipefail

cwd="$PWD"

while read in; do
  if [[ "$in" =~ git@github\.com:.+\/(.+)\.git  ]]; then
    folderName=${BASH_REMATCH[1]}
    if [[ -d $folderName  ]]; then
      echo -e "********
* $folderName
********"
      cd "$folderName"
      git fetch --all
      git checkout develop
      git pull
    else
      git clone "$in"
      cd "$folderName"
      git checkout develop
    fi
  fi
  cd "$cwd"
  echo ""
done < services.txt

