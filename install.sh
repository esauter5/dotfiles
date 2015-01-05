#!/bin/sh
set -ex
yes | sudo pacman -S zsh
curl -L http://install.ohmyz.sh | sh
zsh ./init.sh
