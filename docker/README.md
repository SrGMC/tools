# Docker

Script that builds several images, so I can have armv7l support for them

## Dependencies

- [Docker](https://docs.docker.com/engine/install/)

## Usage

Run
```
bash build.sh
```

```
USAGE:
    ./build.sh [FLAGS] [OPTIONS]

OPTIONS:
    -t=, --tag=        Tag to add to all images.
                       Example: {username}/image_name:{tag}
    -u=, --username=   Username to add to all images
                       Example: {username}/image_name:{tag}
    -ag                Build SilverStrike image
    -dd                Build DevDocs image
    -np                Build Node.js + Python image
    -sl                Build Shlink image
    -sn                Build Shynet image

FLAGS:

    --help, -h         Show this help

NOTES:
    If no image option is provided, nothing will be built.
```

### Example

```
./build.sh -t=amd64 -u=srgmc -dd -np
```

This will build the DevDocs and Node.js + Python images as `srgmc/devdocs:amd64` and `srgmc/python-nodejs:amd64` respectively.

## Images

- [SilverStrike](https://github.com/agstrike/silverstrike)
- [DevDocs](https://github.com/freeCodeCamp/devdocs)
- [docker-python-nodejs](https://github.com/nikolaik/docker-python-nodejs)
  - Node.js 12 and Python 3.8 are installed
- [Shlink](https://github.com/shlinkio/shlink)
- [Shynet](https://github.com/milesmcc/shynet)