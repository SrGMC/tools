#! /bin/bash
#
# system-helper
# Script to manage interactively some system settings
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

function printHeader() {
	clear && tput reset
	echo "$(tput bold)Shell Launcher$(tput sgr 0)"
	echo "$1"
	echo ""
}

function launcherReboot() {
	printHeader "Reboot system"
    read -r -n 1 -p "$(tput setaf 3)Do you want to reboot?$(tput sgr 0) [y/N]: " REPLY
    case $REPLY in
        [yY]) echo ; echo "Rebooting..."; sleep 1 ; sudo reboot ;;
    esac
}

function launcherShutdown() {
	printHeader "Shutting down system"
    read -r -n 1 -p "$(tput setaf 3)Do you want to shutdown?$(tput sgr 0) [y/N]: " REPLY
    case $REPLY in
        [yY]) echo ; echo "Shutting down system..."; sleep 1 ; sudo systemctl poweroff ;;
    esac
}

function increaseBrightness() {
    BRIGHTNESS=$(cat /sys/class/backlight/backlight/brightness)
    if [[ $BRIGHTNESS -lt 5 ]]; then
            echo $(( BRIGHTNESS + 1 )) > /sys/class/backlight/backlight/brightness
    else
        echo 5 > /sys/class/backlight/backlight/brightness
    fi
}

function decreaseBrightness() {
    BRIGHTNESS=$(cat /sys/class/backlight/backlight/brightness)
    if [[ $BRIGHTNESS -gt 1 ]]; then
            echo $(( BRIGHTNESS - 1 )) > /sys/class/backlight/backlight/brightness
    else
        echo 1 > /sys/class/backlight/backlight/brightness
    fi
}

case $1 in
	increase) increaseBrightness ;;
	decrease) decreaseBrightness ;;
	shutdown) launcherShutdown ;;
	reboot) launcherReboot ;;
esac