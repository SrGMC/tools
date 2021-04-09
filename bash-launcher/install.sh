#! /bin/bash
#
# install.sh
# bash-launcher installer
#
# Author: Álvaro Galisteo (https://alvaro.galisteo.me)
# Copyright 2020 - GPLv3

PASS=1
SETTINGS=1
GIT=1
CARGO=1

# Parse CLI arguments
for i in "$@"; do
    case $i in
        -np|--no-pass)
            PASS=0 ;;
        -ns|--no-settings)
            SETTINGS=0 ;;
        -ng|--no-git)
            GIT=0 ;;
        -ni|--no-info)
            INFO=0 ;;
        -nc|--no-cargo)
            CARGO=0 ;;
        --help|-h)
            help; exit ;;
        *)
            echo "Unknown argument $i" ; help ; exit 1;;
    esac
done

function help {
    printf "%sbash-launcher installer%s\n" "$(tput bold)" "$(tput sgr 0)"
    printf "Author: Álvaro Galisteo (https://alvaro.galisteo.me)\n"
    printf "Installer for bash-launcher a command line utility to create menus and/or command launchers with arrow key selection\n"
    printf "Please, read README.md after installation\n\n"
    printf "Arguments:\n"
    printf "  --no-pass/-np        Don't install password-store helper\n"
    printf "  --no-settings/-ns    Don't install system settings helper\n"
    printf "  --no-git/-ng         Don't install git helper\n"
    printf "  --no-info/-ni        Don't install system info helper\n"
    printf "  --no-cargo/-nc        Don't install cargo and Rust helper\n"
    printf "  --help/-h            Show this help.\n"
}

if ! [ "$(id -u)" = 0 ]; then
   echo "Please run this script as root"
   help
   exit 1
fi

BINPATH="/usr/local/bin"

# Create .config/launcher directory and copy config.json to it
mkdir -p "$HOME/.config/launcher/"
cp config/config.json "$HOME"/.config/launcher/config.json

# Copy launcher to $BINPATH
cp launcher.sh "$BINPATH/bash-launcher"
chmod a+x "$BINPATH/bash-launcher"

# Copy pass-helper, system-helper and 
if [[ $PASS -eq 1 ]]; then
	cp config/pass.json "$HOME"/.config/launcher/pass.json
	cp helpers/pass.sh "$BINPATH/pass-helper"
	chmod a+x "$BINPATH/pass-helper"
fi
if [[ $SETTINGS -eq 1 ]]; then
	cp config/settings.json "$HOME"/.config/launcher/settings.json
	cp helpers/system.sh "$BINPATH/system-helper"
	chmod a+x "$BINPATH/system-helper"
fi
if [[ $GIT -eq 1 ]]; then
    cp config/git.json "$HOME"/.config/launcher/git.json
    cp config/git-commit.json "$HOME"/.config/launcher/git-commit.json
    cp helpers/git.sh "$BINPATH/git-helper"
    chmod a+x "$BINPATH/git-helper"
fi
if [[ $INFO -eq 1 ]]; then
    cp helpers/system-info.sh "$BINPATH/system-info-helper"
    cp config/system.json "$HOME"/.config/launcher/system.json
    chmod a+x "$BINPATH/system-info-helper"
fi
if [[ $CARGO -eq 1 ]]; then
	cp config/cargo.json "$HOME"/.config/launcher/cargo.json
	cp helpers/cargo.sh "$BINPATH/cargo-helper"
	chmod a+x "$BINPATH/cargo-helper"
fi

printf "Done! Check README.md for configuration\n"