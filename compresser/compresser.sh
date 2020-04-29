#! /bin/bash
#
# compresser.sh
# Tool to compress PDFs and files into 7z archives
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

IFS=""
current=$(pwd)

# Create directories if they don't exist
if [ ! -d "input" ]; then
  mkdir input
fi
if [ ! -d "output" ]; then
  mkdir output
fi

cd input

for folder in *; do
    if [ -d "${folder}" ]; then
        cp -r "$folder" "$current/output/$folder"
    fi
done

for folder in *; do
    if [ -d "${folder}" ]; then
        cd $folder
        find . -name '*.pdf' \( -exec $current/helper.sh "{}" "$folder" "$current" \; -o -print \)
        cd ..
    fi
done

cd $current/output

for folder in *; do
    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $folder.7z $folder
done

