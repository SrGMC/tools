#! /bin/bash
#
# git-helper
# Script to manage interactively some git actions
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

function printHeader() {
	clear && tput reset
	echo "$(tput bold)Git tools$(tput sgr 0)"
	echo "$1"
	echo ""
}

ITEMS=""
NAME=""
function requestItems() {
    read -p "$(tput setaf 3)What items? (. for everything): $(tput sgr 0)" ITEMS
    git add $ITEMS
}

function requestName() {
    read -p "$(tput setaf 3)Name your commit?: $(tput sgr 0)" NAME
}

# NEW.
function gnew() {
    printHeader "📦 New"
    requestItems
    requestName
    git commit -m "📦 New: $NAME"
}

# IMPROVE.
function gimp() {
    printHeader "✨ Improvement"
    requestItems
    requestName
    git commit -m "✨ Improve: $NAME"
}

# FIX.
function gfix() {
    printHeader "🐛 Fix"
    requestItems
    requestName
    git commit -m "🐛 Fix: $NAME"
}

# REMOVE.
function grm() {
    printHeader "🗑 Removal"
    requestItems
    requestName
    git commit -m "🗑 Remove: $NAME"
}

# RELEASE.
function grlz() {
    printHeader "🚀 Release"
    requestItems
    requestName
    git commit -m "🚀 Release: $NAME"
}

# DOC.
function gdoc() {
    printHeader "📖 Doc"
    requestItems
    requestName
    git commit -m "📖 Doc: $NAME"
}

# TEST.
function gtst() {
    printHeader "🤖 Test"
    requestItems
    requestName
    git commit -m "🤖 Test: $NAME"
}

# BREAKING CHANGE.
function gbrk() {
    printHeader "‼ Breaking changes"
    requestItems
    requestName
    git commit -m "‼ Breaking: $NAME"
}

# GITIGNORE.
function gign() {
    printHeader "🙈 .gitignore"
    requestItems
    requestName
    git commit -m "🙈 .gitignore: $NAME"
}

# INIT.
function ginit() {
    printHeader "🎉 Initial commit"
    git add .
    git commit -m "🎉 Initial commit"
}

# CLEAN.
function gclean() {
    printHeader "💩 Needs cleaning"
    requestItems
    requestName
    git commit -m "💩 Needs cleaning: $NAME"
}

case $1 in
    new) gnew ;;
    imp) gimp ;;
    fix) gfix ;;
    rm) grm ;;
    rel) grlz ;;
    doc) gdoc ;;
    test) gtst ;;
    brk) gbrk ;;
    ign) gign ;;
    clean) gclean;;
    init) ginit;;
esac

