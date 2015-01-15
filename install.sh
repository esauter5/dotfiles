#!/bin/sh
set -ex
yes | sudo pacman -S zsh ack
curl -L http://install.ohmyz.sh | sh
zsh ./init.sh
