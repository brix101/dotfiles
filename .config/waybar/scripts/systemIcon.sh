#!/bin/zsh

# Get distribution information from /etc/os-release
distro=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')

case "$distro" in
"Manjaro Linux")
    echo ""
    ;;
"Arch Linux")
    echo ""
    ;;
"Debian GNU/Linux")
    echo ""
    ;;
"Alpine Linux")
    echo ""
    ;;
"CentOS Linux")
    echo ""
    ;;
"elementary OS")
    echo ""
    ;;
"Fedora")
    echo ""
    ;;
"Gentoo")
    echo ""
    ;;
"Linux Mint")
    echo ""
    ;;
"Raspbian")
    echo ""
    ;;
"Red Hat Enterprise Linux")
    echo ""
    ;;
"Ubuntu")
    echo ""
    ;;
*)
    echo ""
    ;;
esac

