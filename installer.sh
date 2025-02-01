#!/bin/bash
set -ue

BASHRC_LOC="${HOME}/.bashrc"
DOWNLOAD_LOC="${HOME}/downloads"
BIN_LOC="${HOME}/bin"

whereami="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
email=""
get_email() {
  echo "please provide an email address for Run On Complete Script"
  read -r email
}

add_mod_string() {
  modsString="
##mods for resources install start
export EMAIL=\"$email\"
export RESOURCEDIR=\"$whereami\"
source \"\$RESOURCEDIR/TerminalMods/sourcedFiles/bashrcMods\"
export PATH=\"\$RESOURCEDIR/TerminalMods/programs:\$PATH\"
##mods for resources install end
    	"
  if [ -f "$1" ]; then
    echo -e "$modsString" >>"$1"
  fi
}

get_line_num_from_grep() {
  grep -n "$1" "$2" | cut -f1 -d:
}

rm_modstring_if_exist() {
  file="$1"

  startLine="##mods for resources install start"

  if ! grep "$startLine" "$file"; then
    return 0
  fi

  endLine="##mods for resources install end"

  startLine=$(get_line_num_from_grep "$startLine" "$file")
  endLine=$(get_line_num_from_grep "$endLine" "$file")

  echo "$startLine"
  echo "$endLine"

  sed -i.bak "$startLine,${endLine}d" "$file"
}

copy_input_rc() {
  #if I make any changes to inputrc, they'll get copied over because the file will be overwritten
  cp "$whereami/config/inputrc" "$HOME/.inputrc"
}

add_folders() {
  #Make trash folder if no exist
  mkdir -p ~/.local/share/Trash/{files,info} "$HOME/bin" "$HOME/Downloads"
}

# url filename
#puts file in dowlowads locatoin
download_file() {
  if [ $# -ne 2 ]; then
    (echo >&2 "invalid number of arguments")
  fi

  wget "$1" -O "$DOWNLOAD_LOC/$2"
}

#filename in dowloads, path in tarball, dirs to skip(this is to pull a file out of sub directory without foler path)
extract_file_to_bin() {
  tar -xvf "$DOWNLOAD_LOC/$1" --strip-components="$3" -C "$BIN_LOC" "$2"
}

# url, filename.gz, filename in tarball, skip
download_install_to_bin() {
  skip="${4:-0}"
  download_file "$1" "$2"
  extract_file_to_bin "$2" "$3" "$skip"
}

configure_git() {
  git config --global core.excludesfile ~/.gitignore_global
  git config --global --add push.autoSetupRemote true
  git config --global init.defaultBranch main
  cp "$whereami/config/gitignore_global" "$HOME/.gitignore_global"
}
increase_inotify() {
  notify_string="fs.inotify.max_user_watches=524288"
  file="/etc/sysctl.d/10-inotify.conf"
  read -p "Want to increase iNotify limit(Seafile, Webstorm)? [y/N]: " -r response
  if [ "$response" = "y" ]; then
    #copied from https://github.com/guard/listen/wiki/Increasing-the-amount-of-inotify-watchers
    echo $notify_string | sudo tee $file && sudo sysctl -p
  fi
}

#copied from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's:v::'
}

# programs that have their config files in the .config folder
add_config_folder_files() {
  mkdir -p "$HOME/.config":
  cp -r "$whereami/config/starship.toml" "$HOME/.config"
}

installLazyVim() {
  # if [ ! -f "$HOME/.config/nvim/lazyvim.json" ]; then
  #   mv "$HOME/.config/nvim/" "$HOME/.config/nvim.bak" || true
  #   git clone https://github.com/LazyVim/starter ~/.config/nvim
  #   rm -rf ~/.config/nvim/.git
  # fi
  # cp "$whereami/config/nvim/lazyvim/"* ~/.config/nvim/lua/plugins/
  if [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
  fi
  if [ ! -L "$HOME/MyResources/config/nvim" ]; then
    ln -s "$HOME/MyResources/config/nvim" "$HOME/.config/nvim"
  fi

}

main() {

  if echo "$@" | grep '\-e'; then
    get_email
  fi
  if [[ $OSTYPE == "linux-gnu"* ]]; then
    increase_inotify
  fi

  if [ -f "$HOME/.bashrc" ]; then
    rm_modstring_if_exist "$HOME/.bashrc"
    add_mod_string "$HOME/.bashrc"
  fi

  if [ -f "$HOME/.zshrc" ]; then
    rm_modstring_if_exist "$HOME/.zshrc"
    add_mod_string "$HOME/.zshrc"
  fi

  add_folders
  copy_input_rc
  configure_git
  add_config_folder_files
  installLazyVim
}
main "$@"
