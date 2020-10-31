# cargo-compile

A script to compile and cross-compile Rust projects

## Table of contents

- [cargo-compile](#cargo-compile)
  - [Table of contents](#table-of-contents)
  - [Installation](#installation)
  - [Run](#run)
  - [Tips](#tips)

## Installation

GCC cross compiler tools are required:

```bash
# Dependencies (Ubuntu / Debian)
sudo apt-get install gcc gcc-arm-linux-gnueabi gcc-arm-linux-gnueabihf gcc-mingw-w64 gcc-mingw-w64-x86-64
```

## Run

Run by executing:

```bash
./compile.sh [path-to-cargo-project]
```

## Tips

**openssl-sys cannot be compiled**

Add the following to `Cargo.toml`:

```toml
[dependencies.openssl-sys]
version = "*"
features = ["vendored"]
```