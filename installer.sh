#!/bin/bash
set -eu


#add the resource variable and modify the path
whereami=`readlink -f "$0"`
regex="^\/(.+)\/installer.sh$"
if [[ $whereami =~ $regex ]]; then
	whereami="${BASH_REMATCH[1]}"
fi


modsString="
##mods for resources install start
export RESOURCEDIR=\"/$whereami\"
source \"\$RESOURCEDIR/TerminalMods/sourcedFiles/bashrcMods\"
export PATH=\"\$RESOURCEDIR/TerminalMods/programs:\$PATH\"
##mods for resources install end
	"
echo -e "$modsString" >> ~/.bashrc

