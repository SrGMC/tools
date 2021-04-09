#! /bin/bash
#
# mdconverter
# Exports markdown files into websites
#
# Author: Álvaro Galisteo (https://alvaro.galisteo.me)
# Copyright 2020 - GPLv3

current="$(pwd)"

# Create directories if they don't exist
if [ ! -d "content" ]; then
  mkdir content
fi

# Delete previous files
rm -rf html
mkdir html

# Copy CSS files
cp common.css html/common.css

# Traverse every directory
for d in $(find ./content -type d); do

  # Copy every directory to html
  in="$d"
  out="${d//content/html}"
  echo "Content dir: $d"
  echo "Output dir:  ${d//content/html}"
  mkdir -p "$out"

  # Parse every file from content
  for f in $in/*; do
  	filename=$(basename "$f")
	  extension="${filename##*.}"
	  filename="${filename%.*}"

    # Skip empty directories
    if [[ "$filename" == "*" ]]; then
      continue
    fi    

    # Export markdown to html, or copy it
	  if [[ "$filename" == "md" ]]; then
      echo "  $f"
      pandoc "$f" -o "${out}/${filename}.html" --toc -c "common.css" -m
      sed -i -e 's/\.md/\.html/g' "${out}/${filename}.html"
  	else
      cp "$f" "${f//content/html}"
    fi
  done
done