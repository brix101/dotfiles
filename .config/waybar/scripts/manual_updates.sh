#!/usr/bin/env sh

foot --config=$HOME/.config/foot/foot.ini --title "Update Pacman" sh -c "sudo pacman -Syu; paru -Syu; killall -SIGUSR2 waybar"

