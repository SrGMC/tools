# Renamer

Simple CLI script to bulk rename files. Extensions are lower cased and preserved, and only the name is changed.

Files are renamed with a number, starting with `Prefix_X.ext`, where `Prefix` is configurable and `X` is a number starting by `0`

## Table of contents

- [compresser.sh](#compressersh)
  - [Installation](#installation)
    - [7zip](#7zip)
    - [Ghostscript](#ghostscript)
  - [Usage](#usage)

## Usage

Run with:

```
$ ./renamer [-h] /path/to/files prefix
```

**Requiered arguments**

- `/path/to/files`: Path where files to rename are located
- `prefix`: Prefix to append to the files

**Optional arguments**

- `-h, --help`: Display help message
