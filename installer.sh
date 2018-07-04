#!/bin/bash
set -u


#add the resource variable and modify the path
#whereami=`readlink -f "$0"`
#regex="^\/(.+)\/installer.sh$"
#if [[ $whereami =~ $regex ]]; then
#	whereami="${BASH_REMATCH[1]}"
#fi

echo "please provide an email address for Run On Complete Script"
read email
whereami="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

add_mod_string(){
    modsString="
##mods for resources install start
export EMAIL=\"$email\"
export RESOURCEDIR=\"$whereami\"
source \"\$RESOURCEDIR/TerminalMods/sourcedFiles/bashrcMods\"
export PATH=\"\$RESOURCEDIR/TerminalMods/programs:\$PATH\"
##mods for resources install end
    	"
    echo -e "$modsString" >> ~/.bashrc
}

get_line_num_from_grep(){
    echo "$1" | cut -f1 -d:
}

rm_modstring_if_exist(){

    startLine=$(grep -n "##mods for resources install start" ~/.bashrc)

    if [ $? -ne 0 ];then
        return 0
    fi

    endLine=$(grep -n "##mods for resources install end" ~/.bashrc)

    #echo $startLine
    #echo $endLine

    startLine=$(get_line_num_from_grep "$startLine")
    endLine=$(get_line_num_from_grep "$endLine")

    #echo $startLine
    #echo $endLine

    sed -i.bak "$startLine,$endLine d" ~/.bashrc
}

rm_modstring_if_exist
add_mod_string

#Make trash folder if no exist
mkdir -p ~/.local/share/Trash/{files,info}
#if I make any changes to inputrc, they'll get copied over because the file will be overwritten
cp $whereami/inputrc ~/.inputrc
