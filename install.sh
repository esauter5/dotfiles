#!/bin/sh
set -ex
curl -L http://install.ohmyz.sh
#yes | sudo pacman -S tmux
sudo sed -i "/esauter/ s/bash/zsh/" /etc/passwd
./init.sh
