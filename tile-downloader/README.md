# tile-downloader

Download tiles as PNG files from any server that uses the `{x}/{y}/{z}` system.

**Disclaimer**: This is only used with a local instance of [OpenMapTiles' MapTiler Server](https://openmaptiles.org/docs/), as it is incompatible with ARMv7 devices. I'm not resposible for anything that happens to you if you try to download tiles from Google Maps or similar services.

## Table of contents

- [tile-downloader](#tile-downloader)
  - [Installation](#installation)
    - [Requirements](#requirements)
    - [Compilation](#compilation)
  - [Usage](#usage)
    - [Optimizing tiles](#optimizing-tiles)
    - [Example](#example)

## Installation

### Requirements

tile-downloader uses Rust and Cargo. Download the latest version from the [official website](https://www.rust-lang.org/).

Also requires `wget`, but this should be installed by default on any distro.

If you want to optimize images with `compress.sh`, `pngquant` is also required:

```bash
sudo apt install pngquant
# or
sudo dnf install pngquant
```

### Compilation

Once Rust and Cargo are installed, go to the `tile-downloader` folder and run the following to compile:

```bash
cargo build --release
```

Once compiled, an executable will be generated at `target/release/tile-downloader`

## Usage

`tile-downloader` can be used two ways

1. Executing `./tile-downloader`
2. Executing `cargo run -- <params>`

```
USAGE:
    tile-downloader [OPTIONS] --lat-end <lat-end> --lat-start <lat-start> --lon-end <lon-end> --lon-start <lon-start> --url <url>

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
        --lat-end <lat-end>        Latitude of the final corner
        --lat-start <lat-start>    Latitude of the starting corner
        --lon-end <lon-end>        Longitude of the final corner
        --lon-start <lon-start>    Longitude of the starting corner
        --max-zoom <max-zoom>       [default: 20]
        --min-zoom <min-zoom>       [default: 10]
        --url <url>                URL of the tile server. Must accept z/x/y.png
```

### Optimizing tiles

`compress.sh` is provided to optimize images using `pngquant`, in order to reduce file size without compromising quality.

```
./compresser.sh
```

### Example

```
tile-downloader --lat-start 35.86265426287864 --lon-start 3.303533060563368 --lat-end 43.8427273782447 --lon-end -10.165704794966866 --url http://localhost:8989
```

This will download into a folder called `tiles`, tiles of Spain from zoom level 10 to zoom level 20.
