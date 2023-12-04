#!/bin/sh

UPDATES="$(($(pacman -Qu | wc -l) + $(paru -Qu | wc -l)))"
echo "$UPDATES"
if [[ ${UPDATES} != "0" ]]; then
    notify-send -a "Arch Linux Updates" "Total number of packages to update" "$UPDATES"
else
    notify-send -a "Arch Linux Updates" "Up to date" "No packages need to be upgraded"
fi

