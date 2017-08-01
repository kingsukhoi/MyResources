#!/bin/bash
set -ue

#test this sob

if [ $# -ne 2 ]; then
	echo "usage:
	file object that implements interface"
fi


cat $1 | grep -e "^func ([a-zA-Z]* \*$2) [A-Z].*{$" | grep -oe "[A-Z].*" | sed -e 's:{$::g'

