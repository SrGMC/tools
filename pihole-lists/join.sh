#! /bin/bash

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