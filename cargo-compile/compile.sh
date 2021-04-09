#!/bin/bash
#
# compile.sh
# Cargo cross compiler script
#
# Author: Álvaro Galisteo (https://alvaro.galisteo.me)
# Copyright 2020 - GPLv3

if [[ $# -eq 0 ]]; then
    echo "Compiling in current directory"
else
    echo "Compiling in $1 directory"
    cd "$1" || exit
fi

PROJECT=""
if [[ -f "Cargo.toml" ]]; then
    PROJECT=$(grep "name" < "Cargo.toml" | awk -F\" '{print $2}')
else
    echo "$(tput setaf 1)You are not in a Cargo directory $(tput sgr 0)"
    exit
fi

mkdir bin > /dev/null 2>&1

echo "$(tput bold)Compiling for Linux x64$(tput sgr 0)"
rustup target add x86_64-unknown-linux-musl
cargo build --release --target=x86_64-unknown-linux-musl
cp "target/x86_64-unknown-linux-musl/release/$PROJECT" "bin/$PROJECT-linux-x64"

echo ""
echo "$(tput bold)Compiling for Linux armhf$(tput sgr 0)"
rustup target add arm-unknown-linux-gnueabihf
cargo build --release --target=arm-unknown-linux-gnueabihf
cp "target/arm-unknown-linux-gnueabihf/release/$PROJECT" "bin/$PROJECT-linux-armhf"

echo ""
echo "$(tput bold)Compiling for Linux armv7$(tput sgr 0)"
rustup target add armv7-unknown-linux-gnueabihf
cargo build --release --target=armv7-unknown-linux-gnueabihf
cp "target/armv7-unknown-linux-gnueabihf/release/$PROJECT" "bin/$PROJECT-linux-armv7"

echo ""
echo "$(tput bold)Compiling for Windows x64$(tput sgr 0)"
rustup target add x86_64-pc-windows-gnu
cargo build --release --target=x86_64-pc-windows-gnu
cp "target/x86_64-pc-windows-gnu/release/$PROJECT.exe" "bin/$PROJECT-win-x64.exe"
