#!/bin/sh
set -ex
yes | sudo pacman -S zsh tmux
sudo sed -i "/esauter/ s/bash/zsh/" /etc/passwd
./init.sh
