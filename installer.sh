#!/bin/bash
set -eu


#add the resource variable and modify the path
#whereami=`readlink -f "$0"`
#regex="^\/(.+)\/installer.sh$"
#if [[ $whereami =~ $regex ]]; then
#	whereami="${BASH_REMATCH[1]}"
#fi

whereami="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

modsString="
##mods for resources install start
export RESOURCEDIR=\"/$whereami\"
source \"\$RESOURCEDIR/TerminalMods/sourcedFiles/bashrcMods\"
export PATH=\"\$RESOURCEDIR/TerminalMods/programs:\$PATH\"
##mods for resources install end
	"
echo -e "$modsString" >> ~/.bashrc


#Make trash folder if no exist
mkdir -p ~/.local/share/Trash/{files,info}
cp $whereami/inputrc ~/.inputrc 
