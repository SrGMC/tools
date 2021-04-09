# /bin/bash
# 
# tile-downloader
# Download tiles as PNG files from any server that uses the `{x}/{y}/{z}` system.
# 
# Script to optimize images using pngquant
# 
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2021 - GPLv3

find ./tiles -type f -iname '*.png' -exec pngquant --force --quality=50-100 --skip-if-larger --strip --speed 3 --verbose {} --output {} \;