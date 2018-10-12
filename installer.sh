#!/bin/bash
set -u


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
    echo "$1" | cut -f1 -d:
}

rm_modstring_if_exist(){

    startLine=$(grep -n "##mods for resources install start" ~/.bashrc)

    if grep -n "##mods for resources install start" ~/.bashrc ;then
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

add_folders() {
    #Make trash folder if no exist
    mkdir -p ~/.local/share/Trash/{files,info} "$HOME/bin" "$HOME/Downloads"
}
copy_input_rc() {
    #if I make any changes to inputrc, they'll get copied over because the file will be overwritten
    cp "$whereami/inputrc" "$HOME/.inputrc"
}
install_caddy() {
    caddy_url='https://caddyserver.com/download/linux/amd64?license=personal&telemetry=on'
    wget "$caddy_url" -O "$HOME/Downloads/caddy.tar.gz"
    tar -xvf "$HOME/Downloads/caddy.tar.gz" -C "$HOME/bin" caddy
}

add_global_gitignore(){
    git config --global core.excludesfile ~/.gitignore
    cp "$whereami/gitignore_global" "$HOME/.gitignore_global"
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
    install_caddy
}
main "$@"
