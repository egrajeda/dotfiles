#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
DARK_GRAY='\033[1;30m'
RESET='\e[0m\033[0m'

UNDERLINE='\e[4m'

DOTFILES=$(cd $(dirname $0); pwd -P)

success() {
    echo -e " $GREEN✓$RESET $1"
}

failure() {
    echo -e " $RED✗$RESET $1"
}

symlink() {
    relative_path=$(echo $2 | sed -e "s|$HOME|~|g")
    if [ ! -f "$2" ] && [ ! -d "$2" ]; then
        mkdir -p "$(dirname $2)"
        ln -sT $1 $2
        success "$relative_path"
    elif [ "$1" -ef "$2" ]; then
        success "$relative_path"
    else
        failure "$relative_path - The file already exists and is either a normal file, or it points to a different path."
    fi
}

echo -e ":: Downloading the submodules..."

git submodule update --init --recursive \
    && success "Done" || failure "Error"

echo -e "\n:: Creating symlinks..."

[ -d "$HOME/.config/systemd" ] || mkdir -p ~/.config/systemd

symlink $DOTFILES/tmux.conf ~/.tmux.conf
symlink $DOTFILES/gitconfig ~/.gitconfig
symlink $DOTFILES/vimrc ~/.vimrc
symlink $DOTFILES/vim ~/.vim
symlink $DOTFILES/dircolors/dircolors.ansi-light ~/.dircolors
symlink $DOTFILES/systemd ~/.config/systemd/user
symlink $DOTFILES/ideavimrc ~/.ideavimrc

echo -e "\n:: Setting up vim..."

vim +PluginInstall +qall
(cd $DOTFILES/vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make) | pr -T --indent=1

echo -e "\n:: Setting up the system..."

# localectl --no-convert set-x11-keymap latam pc104 deadtilde ctrl:nocaps \
#     && success "Keyboard" || failure "Keyboard"
localectl --no-convert set-x11-keymap us pc104 altgr-intl ctrl:nocaps \
    && success "Keyboard" || failure "Keyboard"

systemctl --user enable unison \
    && success "Unison" || failure "Unison"
