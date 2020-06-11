# compresser.sh

Tool to compress PDFs and files into 7z archives.

## Table of contents

- [compresser.sh](#compressersh)
  - [Installation](#installation)
    - [7zip](#7zip)
    - [Ghostscript](#ghostscript)
  - [Usage](#usage)

## Installation

### 7zip

7zip is required for compressing files.

Debian/Ubuntu

```bash
sudo apt-get install p7zip p7zip-full
```

macOS

```bash
brew install p7zip
```

### Ghostscript

Ghostscript is necessary for the ps2pdf utility that can be used to compress
 PDF files.

Debian/Ubuntu

```bash
sudo apt-get install ghostscript
```

macOS

```bash
brew install ghostscript
```

## Usage

1. Add all the folders that you want to compress into the `input` directory.
 The script will traverse all folders and process all PDF files.
2. Run `./compresser.sh`
3. Compressed directories will be put into the `output`
