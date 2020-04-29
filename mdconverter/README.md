# mdconverter

Exports markdown files into ready-to-use websites. Useful for documentation files.

## Table of contents

- [mdconverter](#mdconverter)
  - [Installation](#installation)
    - [pandoc](#pandoc)
  - [Usage](#usage)

## Installation

### pandoc

Pandoc is required for converting markdown to html

Debian/Ubuntu

```bash
sudo apt-get install pandoc
```

macOS

```bash
brew install pandoc
```

## Usage

1. Add files to the `content` directory.
2. Run `./run.sh`.
3. Output files will be put into the `html` directory.
