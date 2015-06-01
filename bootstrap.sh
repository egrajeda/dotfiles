#!/bin/sh

DOTFILES=$(cd $(dirname $0); pwd -P)

ln -s $DOTFILES/tmux.conf ~/.tmux.conf
ln -s $DOTFILES/gitconfig ~/.gitconfig

git submodule update --init --recursive
ln -s $DOTFILES/vimrc ~/.vimrc
ln -sT $DOTFILES/vim ~/.vim
vim +PluginInstall +qall
(cd $DOTFILES/vim/bundle/command-t/ruby/command-t && ruby extconf.rb && make)
