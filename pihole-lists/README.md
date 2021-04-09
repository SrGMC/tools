# pihole-lists

A script to unify and generate blocklists for Pi-Hole.

## Table of contents

- [pihole-lists](#pihole-lists)
  - [Usage](#usage)

## Usage

First, create a `blocklists.txt`. This contains a list of urls where to download blocklists. **Don't forget** to add a trailing empty line.

Then, run:

```
$ ./join.sh
```

This will unify and remove duplicates under one file, `hosts.txt`.

Feed this file to Pi-Hole to start using.

A basic `blocklist.txt` file is provided, along with `whitelist.txt` that contains some common false positives to whitelist.
