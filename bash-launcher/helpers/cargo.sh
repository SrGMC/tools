#! /bin/bash
#
# cargo-helper
# Script to manage interactively cargo and rust commands
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

function printHeader() {
	clear && tput reset
	echo "$(tput bold)Cargo tools$(tput sgr 0)"
	echo "$1"
	echo ""
}

NAME=""
PROJECT=""

function requestName() {
    read -r -p "$(tput setaf 3)Name the new project?: $(tput sgr 0)" NAME
}

function getProject() {
    if [[ -f "Cargo.toml" ]]; then
        PROJECT=$(grep "name" < "Cargo.toml" | awk -F\" '{print $2}')
    else
        echo "$(tput setaf 1)You are not in a Cargo directory $(tput sgr 0)"
        exit
    fi
}

function buildAndStrip() {
    cargo build --release
    strip "./target/release/$PROJECT"
}

# build-release
function buildRelease() {
    printHeader "cargo build --release"
}

# run-release
function runRelease() {
    printHeader "cargo run --release"
    buildAndStrip
    eval "./target/release/$PROJECT";
}

function new() {
    printHeader "New project"
    requestName
    cargo new "$NAME"
}

getProject

case $1 in
    build-release) buildRelease ;;
    run-release) runRelease ;;
    new) new ;;
esac

