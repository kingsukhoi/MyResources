#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage regex.sh <pattern> <string> [<string> . . .]" 1>&2
    exit 1
fi

REGEX=$1
shift

echo 'pattern => ' "$REGEX"

while [ $# -ne 0 ]; do
    if [[ $1 =~ $REGEX ]]; then
	echo "$1 Matches"
	i=0
	n=${#BASH_REMATCH[*]}
	while [[ $i -lt $n ]]; do
	    echo "    capture[$i]: ${BASH_REMATCH[$i]}"
	    i=$(($i+1))
	done
    else
	echo "$1 Does Not Match"
    fi
    shift
done
