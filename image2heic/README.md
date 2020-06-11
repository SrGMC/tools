# image2heic

Tool to convert images to a HEIC file which vastly reduces file size.
 This script resizes images to a 3508xH or Wx3508 size, an optimum size between
 printing and storage.

## Table of contents

- [image2heic](#image2heic)
  - [Installation](#installation)
    - [imagemagick](#imagemagick)
  - [Usage](#usage)

## Installation

### imagemagick

Imagemagick is required for resizing and converting images. HEIC support must
 be enabled

Debian/Ubuntu

```bash
# Dependencies
sudo apt-get install libwebp-dev libde265-dev

# Install libheif
wget https://github.com/strukturag/libheif/archive/v1.3.2.tar.gz
tar -xvf v1.3.2.tar.gz
cd libheif-1.3.2/
./autogen.sh  && ./configure
make && sudo make install

# Install ImageMagick with WEBP and HEIC support
wget http://www.imagemagick.org/download/ImageMagick.tar.gz
tar -xvf ImageMagick.tar.gz
cd ImageMagick-*/
./configure --with-heic=yes
make && sudo make install
sudo ldconfig /usr/local/lib
```

macOS

```bash
brew install imagemagick --with-libheif
```

## Usage

1. Add images to the `input` directory.
2. Run `./convert.sh`.
3. Output images will be put into the `output` directory.
