#!/bin/bash
set -eu
checkSource (){
	#http://wiki.bash-hackers.org/howto/conffile#secure_it
	# check if the file contains something we don't want
	if egrep -q -v '^#|^[^ ]*=[^;]*' "$1"; then
		echo "Config file is unclean, cleaning it..." >&2
		# filter the original to a new file
		egrep '^#|^[^ ]*=[^;&]*'  "$configfile" > "$configfile_secured"
		configfile="$configfile_secured"
	fi
}

#$1 is the resource folder $2 is the path folder
addmissingfiles(){
	missingfiles=$(diff "$1" "$2" | egrep "$1" | cut -d " " -f 4)
	for prog in $missingfiles; do 
		ln -s "$termprogloc$prog" "$progpath$prog"
	done
}


#check and import config fileconfig file 
configfile='./config/config.cfg'
configfile_secured='./config/resourceconfig.cfg'
checkSource $configfile
source "$configfile"
#adds missing files
addmissingfiles $terminalProgramsLocation $installLocation
#add the resource variable and install if nessary
whereami=`readlink -f "$0"`
regex="^\/(.+)\/installer.sh$"
if [[ $whereami =~ $regex ]]; then
	whereami="${BASH_REMATCH[1]}"
fi


modsString="
##mods for resources install start
export RESOURCEDIR=\"/$whereami/\"
source \"\$RESOURCEDIR/TerminalMods/sourcedFiles/bashrcMods\"
##mods for resources install end
	"
echo -e "$modsString" >> ~/.bashrc

