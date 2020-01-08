#!/bin/bash
set -ue

BASHRC_LOC="${HOME}/.bashrc"
DOWNLOAD_LOC="${HOME}/Downloads"
BIN_LOC="${HOME}/bin"

whereami="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
email=""
get_email() {
    echo "please provide an email address for Run On Complete Script"
    read -r email
}

install_amix_vim() {
    if [ ! -f ~/.vim_runtime/install_awesome_vimrc.sh ]; then
        git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
        sh ~/.vim_runtime/install_awesome_vimrc.sh
        echo "set number" >> ~/.vimrc
    fi
}

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
    grep -n "$1" "$BASHRC_LOC" | cut -f1 -d:
}

rm_modstring_if_exist(){

    startLine="##mods for resources install start"

    if ! grep "$startLine" "$BASHRC_LOC" ;then
        return 0
    fi

    endLine="##mods for resources install end"


    startLine=$(get_line_num_from_grep "$startLine")
    endLine=$(get_line_num_from_grep "$endLine")

    echo "$startLine"
    echo "$endLine"

    sed -i.bak "$startLine,${endLine}d" "$BASHRC_LOC"
}

copy_input_rc() {
    #if I make any changes to inputrc, they'll get copied over because the file will be overwritten
    cp "$whereami/inputrc" "$HOME/.inputrc"
}

add_folders() {
    #Make trash folder if no exist
    mkdir -p ~/.local/share/Trash/{files,info} "$HOME/bin" "$HOME/Downloads"
}


# url filename
#puts file in dowlowads locatoin
download_file(){
    if [ $# -ne 2 ]; then
        (>&2 echo "invalid number of arguments")
    fi

    wget "$1" -O "$DOWNLOAD_LOC/$2"
}

#filename in dowloads, path in tarball, dirs to skip(this is to pull a file out of sub directory without foler path)
extract_file_to_bin(){
    tar -xvf "$DOWNLOAD_LOC/$1" --strip-components="$3"  -C "$BIN_LOC" "$2"
}

# url, filename.gz, filename in tarball, skip
download_install_to_bin(){
    skip="${4:-0}"
    download_file "$1" "$2"
    extract_file_to_bin "$2" "$3" "$skip"
}

add_global_gitignore(){
    git config --global core.excludesfile ~/.gitignore_global
    cp "$whereami/gitignore_global" "$HOME/.gitignore_global"
}
increase_inotify(){
    notify_string="fs.inotify.max_user_watches=524288"
    file="/etc/sysctl.conf"
    echo -n "Want to increase iNotify limit(Seafile, Webstorm)? [y/N]: "
    read -r response
    if [ "$response" = "y" ]; then
        if ! grep $notify_string $file &> /dev/null; then
            #copied from https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
            echo $notify_string  | sudo tee -a $file && sudo sysctl -p
        fi
    fi
}

#copied from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
   curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's:v::'
}

main() {

    if echo "$@" | grep '\-e'; then
        get_email
    fi
    rm_modstring_if_exist
    add_mod_string
    add_folders
    copy_input_rc
    add_global_gitignore
    install_amix_vim
    increase_inotify
}
main "$@"
