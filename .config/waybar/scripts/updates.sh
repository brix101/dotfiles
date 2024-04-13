#!/bin/sh

# Function to check internet connection
check_internet_connection() {
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    return $?
}
# Check for internet connection
if check_internet_connection; then
    UPDATES="$(($(pacman -Qu | wc -l) + $(paru -Qu | wc -l)))"
    echo "$UPDATES"
    if [[ ${UPDATES} != "0" ]]; then
        notify-send -a "Arch Linux Updates" "Total number of packages to update" "$UPDATES"
    else
        notify-send -a "Arch Linux Updates" "Up to date" "No packages need to be upgraded"
    fi
else
    # If there's no internet connection, echo "0"
    echo "0"
fi
