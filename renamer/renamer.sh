#!/bin/bash

set -e

red="\e[0;91m"
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"
blue="\e[0;94m"
purple="\e[0;35m"

function help() {
    echo -e "${bold}Renamer${reset}"
    echo -e "A bash script to bulk rename files in a folder. Extensions are lower cased and kept.\n"
    echo -e "Files are renamed with a number, starting with ${blue}Prefix_X.ext${reset}, where ${blue}Prefix${reset}"
    echo -e "is configurable and ${blue}X${reset} is a number starting by ${blue}0${reset}"
    echo -e ""
    echo -e "Usage: $0 [-h] ${green}/path/to/files${reset} ${purple}prefix${reset}"
    echo -e ""
    echo -e "Requiered arguments"
    echo -e "  ${green}/path/to/files${reset}    Path where files to rename are located"
    echo -e "  ${purple}prefix${reset}            Prefix to append to the files"
    echo -e ""
    echo -e "Optional arguments"
    echo -e "  -h, --help        Display this message"
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ "$2" == "-h" ] || [ "$2" == "--help" ] || [ "$3" == "-h" ] || [ "$3" == "--help" ]; then
    help
    exit 0
elif [[ $# -lt 2 ]]; then
    help
    echo -e ""
    echo -e "${red}Error: missing parameters${reset}"
    exit 1
elif [[ $# -gt 2 ]]; then
    help
    echo -e ""
    echo -e "${red}Error: invalid number of parameters${reset}"
    exit 1
fi

FILE_PATH="$1"
PREFIX="$2"

N=0
for file in "$FILE_PATH"/*; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    extension="$(echo $extension | tr '[:upper:]' '[:lower:]')"
    mv "$file" "${FILE_PATH}/${PREFIX}_${N}.$extension"
    N="$((N + 1))"
done