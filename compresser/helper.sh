#! /bin/bash
#
# compresser.sh / helper.sh
# Helper script to compress PDF files
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

echo "$3/input/$2/$1 > $3/output/$2/$1"
ps2pdf "$3/input/$2/$1" "$3/output/$2/$1"
