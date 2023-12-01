#!/usr/bin/env sh

foot --config=$HOME/.config/foot/foot2.ini sh -c "tmux new -s updates 'sudo pacman -Syu; paru -Syu; killall -SIGUSR2 waybar'"
