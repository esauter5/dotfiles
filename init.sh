#!/bin/zsh
typeset -A files
files=(.vim vim .vimrc vim/vimrc .gvimrc vim/gvimrc .tmux.conf tmux.conf .zshrc zshrc .zshenv zshenv .gitconfig gitconfig .psqlrc psqlrc)

for dotfile sourcefile in ${(kv)files}
do
  if [ ! -e ~/${dotfile} ]
  then
    ln -s ~/.dotfiles/${sourcefile} ~/${dotfile}
  fi
done

