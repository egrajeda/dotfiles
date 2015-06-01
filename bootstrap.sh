#!/bin/sh

DOTFILES=$(cd $(dirname $0); pwd -P)

ln -s $DOTFILES/tmux.conf ~/.tmux.conf
ln -s $DOTFILES/gitconfig ~/.gitconfig
