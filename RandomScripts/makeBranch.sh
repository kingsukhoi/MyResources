#!/bin/bash
set -ueo pipefail
cwd="$PWD"
newBranchName="$1"

while read in; do
  if [[ "$in" =~ git@github\.com:.+\/(.+)\.git  ]]; then
    folderName=${BASH_REMATCH[1]}
    if [[ -d $folderName  ]]; then
      echo -e "********
* $folderName
********"
      git -C "$folderName" checkout -b "$newBranchName"
    fi
  fi
  cd "$cwd"
  echo ""
done < services.txt

