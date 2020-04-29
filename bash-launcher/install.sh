#! /bin/bash
#
# install.sh
# bash-launcher installer
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

PASS=1
SETTINGS=1

# Parse CLI arguments
for i in "$@"; do
    case $i in
        -np|--no-pass)
            CONFIGPATH="${i#*=}" ;;
        -ns|--no-settings)
            CONFIGPATH="${i#*=}" ;;
        --help|-h)
            help ;;
        *)
            echo "Unknown argument $i" ; help ; exit ;;
    esac
done

function help {
    printf "$(tput bold)bash-launcher installer$(tput sgr 0)\n"
    printf "Author: Álvaro Galisteo (https://alvaro.ga)\n"
    printf "Installer for bash-launcher a command line utility to create menus and/or command launchers with arrow key selection\n"
    printf "Please, read README.md after installation\n\n"
    printf "Arguments:\n"
    printf "  --no-pass/-np        Don't install password-store helper\n"
    printf "  --no-settings/-ns    Don't install system settings helper\n"
    printf "  --help/-h            Show this help.\n"
}

if ! [ $(id -u) = 0 ]; then
   echo "Please run this script as root"
   help
   exit 1
fi

BINPATH="/usr/local/bin"

# Create .config/launcher directory and copy config.json to it
mkdir -p "$HOME/.config/launcher/"
cp config/config.json $HOME/.config/launcher/config.json

# Copy launcher to $BINPATH
cp launcher.sh "$BINPATH/bash-launcher"
chmod a+x "$BINPATH/bash-launcher"

# Copy pass-helper and system-helper
if [[ $PASS -eq 1 ]]; then
	cp config/pass.json $HOME/.config/launcher/pass.json
	cp helpers/pass.sh "$BINPATH/pass-helper"
	chmod a+x "$BINPATH/pass-helper"
fi
if [[ $SETTINGS -eq 1 ]]; then
	cp config/settings.json $HOME/.config/launcher/settings.json
	cp helpers/system.sh "$BINPATH/system-helper"
	chmod a+x "$BINPATH/system-helper"
fi

printf "Done! Check README.md for configuration\n"