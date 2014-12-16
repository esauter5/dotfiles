#!/bin/zsh

typeset -A files
files=(.vim vim
       .vimrc vim/vimrc
       .gvimrc vim/gvimrc
       .tmux.conf tmux.conf
       .zshrc zshrc
       .zshenv zshenv
       .gitconfig gitconfig
       .psqlrc psqlrc
       .git_template git_template
       .lein lein)

for dotfile sourcefile in ${(kv)files}
do
  if [ -e ~/${dotfile} ]
  then
    rm -f ~/${dotfile}
  fi
  ln -s ~/.dotfiles/${sourcefile} ~/${dotfile}
done

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim ~/.vimrc +PluginInstall +qa
