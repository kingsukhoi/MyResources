#!/bin/bash

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
addmissingfiles(){#$1 is the resource folder $2 is the path folder

	missingfiles=$(diff "$1" "$2" | egrep "$1" | cut -d " " -f 4)
	for prog in $missingfiles; do 
		ln -s "$termprogloc$prog" "$progpath$prog"
	done
}



configfile='./config/config.cfg'
configfile_secured='./config/resourceconfig.cfg'
checkSource $configfile
source "$configfile"
addmissingfiles $terminalProgramsLocation $installLocation
