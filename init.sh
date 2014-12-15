#!/bin/zsh
typeset -A files
files=(.vim vim .vimrc vim/vimrc .gvimrc vim/gvimrc .tmux.conf tmux.conf .zshrc zshrc .zshenv zshenv .gitconfig gitconfig .psqlrc psqlrc .git_template git_template)

for dotfile sourcefile in ${(kv)files}
do
  if [ ! -e ~/${dotfile} ]
  then
    ln -s ~/.dotfiles/${sourcefile} ~/${dotfile}
  fi
done

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim ~/.vimrc +PluginInstall +qa
