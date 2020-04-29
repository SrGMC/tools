#! /bin/bash
#
# image2heic
# Converts images to a 3508xH / Wx3508 size HEIC file
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

# Create directories if they don't exist
if [ ! -d "input" ]; then
  mkdir input
fi
if [ ! -d "output" ]; then
  mkdir output
fi

for file in input/*.{jpeg,jpg,png,heic,gif,bmp}; do
    res=$(identify -format "%[fx:w] %[fx:h]" "$file")
    width=$(echo $res | awk '{print $1}')
    height=$(echo $res | awk '{print $2}')

    filename=$(basename -- "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"

    echo "Converting ${filename}.${extension} to ${filename}.heic"
    if [[ $width -gt $height ]]; then
        convert "$file" -resize "3508" "output/$filename.heic"
        #echo "Bigger width"
    else
        convert "$file" -resize "x3508" "output/$filename.heic"
        #echo "Bigger height"
    fi
done
