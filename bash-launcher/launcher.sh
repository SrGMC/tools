#! /bin/bash
#
# bash-launcher
# Bash based launcher
#
# Author: Álvaro Galisteo (https://alvaro.galisteo.me)
# Copyright 2020 - GPLv3

set -o errexit

# Default config path
CONFIGPATH="$HOME/.config/launcher/config.json"

#
# Functions
#

# Colors
function resetTerminal {
    tput sgr 0
}

# setColor bg|fg color
function setColor {
    COLOR=0
    case $2 in
        black) COLOR=0 ;;
        red) COLOR=1 ;;
        green) COLOR=2 ;;
        yellow) COLOR=3 ;;
        blue) COLOR=4 ;;
        magenta) COLOR=5 ;;
        cyan) COLOR=6 ;;
        white) COLOR=7 ;;
        *) COLOR=7 ;;
    esac

    if [[ $1 == "bg" ]]; then
        tput setab $COLOR
    else
        tput setaf $COLOR
    fi
}

function help {
    printf "%sBash shell launcher\n%s" "$(tput bold)" "$(resetTerminal)"
    printf "Author: Álvaro Galisteo (https://alvaro.galisteo.me)\n"
    printf "Command line utility to create menus and/or command launchers with arrow key selection\n\n"
    printf "Arguments:\n"
    printf "  --config=PATH        Path for the config file.\n"
    printf "                       Default: %s/.config/launcher/config.json\n" "$HOME"
    printf "  --help/-h            Show this help.\n"
    exit
}

function run {
    clear
    TYPE=$(echo "$CONFIG" | jq ".items[$1].type" -r)
    RUN=$(echo "$CONFIG" | jq ".items[$1].run" -r)
    WAIT=$(echo "$CONFIG" | jq ".items[$1].wait" -r)
    if [[ $TYPE == "command" ]]; then
        eval "$RUN"
        if [[ $WAIT == "true" ]]; then
            echo ""
            read -r -p "$(setColor fg yellow)Press any key to continue...$(resetTerminal)"
        fi
    elif [[ $TYPE == "submenu" ]]; then
        eval "$0" --config="$RUN"
    elif [[ $TYPE == "exit" ]]; then
        clear
        exit
    fi
    printMenu
}

# BG_COLOR ITEM DESCRIPTION
function printItem {
    STRINGSIZE=${#2}
    SPACES=$(( MAX_STRING_SIZE - STRINGSIZE ))
    STRING="  $2 "
    for i in $(seq 0 $SPACES); do
        STRING+=" "
    done

    if [[ $1 == "none" ]]; then
        echo "$STRING  $3"
    else
        echo "$(setColor bg "$1")$(setColor fg black)$STRING$(resetTerminal)  $3"
    fi
}

function printMenu {
    # Clear screen, then print selections
    clear && tput reset
    echo -e "$(tput bold)$TITLE$(resetTerminal)"
    echo -e "$SUBTITLE\n"

    for i in $(seq 0 $((ITEM_COUNT - 1))); do
        if [[ $i -eq $SELECTION ]]; then
            printItem "${COLORS[$i]}" "${ITEMS[$i]}" "${DESCRIPTION[$i]}"
        else
            printItem none "${ITEMS[$i]}" "${DESCRIPTION[$i]}"
        fi
    done
}

function fillItems {
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for i in $(echo "$CONFIG" | jq ".items[].name" -r); do
        ITEMS+=("$i")
    done
    for i in $(echo "$CONFIG" | jq ".items[].description" -r); do
        DESCRIPTION+=("$i")
    done
    for i in $(echo "$CONFIG" | jq ".items[].color" -r); do
        COLORS+=("$i")
    done
        for i in $(echo "$CONFIG" | jq ".items[].type" -r); do
        TYPE+=("$i")
    done
    IFS=$SAVEIFS
}

# Parse CLI arguments
for i in "$@"; do
    case $i in
        --config=*)
            CONFIGPATH="${i#*=}" ;;
        --help|-h)
            help ;;
        *)
            echo "Unknown argument $i" ; help ;;
    esac
done

#
# Global variables
#
# In-memory config
CONFIG=$(cat "$CONFIGPATH")

# Title and subtitle
TITLE=$(echo "$CONFIG" | jq ".title" -r)
SUBTITLE=$(echo "$CONFIG" | jq ".subtitle" -r)

# Characters
esc=$'\e'
up=$'\e[A'
down=$'\e[B'

# Selection and size
SELECTION=0
MAX_STRING_SIZE=0
ITEM_COUNT=$(echo "$CONFIG" | jq ".items | length")

# Items
ITEMS=()
COLORS=()
DESCRIPTION=()
TYPE=()

#
# Main
#

# Fill items from config
fillItems

# Get max string size
for i in $(seq 0 $((ITEM_COUNT - 1))); do
    STRING=${ITEMS[$i]}
    if [[ ${#STRING} -gt $MAX_STRING_SIZE ]]; then
        MAX_STRING_SIZE="${#STRING}"
    fi
done

printMenu

while true; do
    while IFS="" read -r -n1 -s char ; do
        if [[ "$char" == "$esc" ]]; then
            # Get the rest of the escape sequence (3 characters total)
            while read -r -n2 -s rest ; do
                char+="$rest"
                break
            done
        fi

        if [[ "$char" == "$up" && $SELECTION -gt 0 ]] ; then
            tput cup $(( SELECTION + 3 )) 0
            printItem none "${ITEMS[$SELECTION]}" "${DESCRIPTION[$SELECTION]}"

            # Skip separators
            SELECTION=$(( SELECTION - 1 ))
            while [[ ${TYPE[$SELECTION]} == "separator" ]] ; do
                SELECTION=$(( SELECTION - 1 ))
            done

            tput cup $(( SELECTION + 3 )) 0
            printItem "${COLORS[$SELECTION]}" "${ITEMS[$SELECTION]}" "${DESCRIPTION[$SELECTION]}"
            tput cup $(( SELECTION + 3 )) 0

            break
        elif [[ "$char" == "$down" && $SELECTION -lt $(( ${#ITEMS[*]} - 1 )) ]]; then
            tput cup $(( SELECTION + 3 )) 0
            printItem none "${ITEMS[$SELECTION]}" "${DESCRIPTION[$SELECTION]}"

            # Skip separators
            SELECTION=$(( SELECTION + 1 ))
            while [[ ${TYPE[$SELECTION]} == "separator" ]] ; do
                SELECTION=$(( SELECTION + 1 ))
            done

            tput cup $(( SELECTION + 3 )) 0
            printItem "${COLORS[$SELECTION]}" "${ITEMS[$SELECTION]}" "${DESCRIPTION[$SELECTION]}"
            tput cup $(( SELECTION + 3 )) 0
            break
        elif [[ -z "$char" ]]; then # user pressed ENTER
            run $SELECTION
            break
        fi
    done
done
