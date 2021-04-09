#! /bin/bash
#
# pihole-lists
# A script to unify and generate blocklists for Pi-Hole.
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2021 - GPLv3

mkdir blocklists/
while IFS= read -r line; do
    (cd blocklists && wget "$line")
done < blocklists.txt

for file in blocklists/*; do
    cat "$file" >> temp.txt
done

sed -i.bak '/^[[:blank:]]*#/d' "temp.txt"
sed -i.bak '/^[[:space:]]*$/d' "temp.txt"
sort -u temp.txt > hosts.txt
rm -rf blocklists temp.txt temp.txt.bak