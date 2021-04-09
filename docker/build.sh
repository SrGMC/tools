#!/bin/bash
#
# docker
# Script to create docker images
#
# Author: Álvaro Galisteo (https://alvaro.galisteo.me)
# Copyright 2020 - GPLv3

set -e

function help {
    echo -e "$(tput bold)docker$(tput sgr 0)"
    echo -e "Script to create docker images"
    echo -e "Note: Requires sudo"
    echo -e ""
    echo -e "USAGE:"
    echo -e "    ./build.sh [FLAGS] [OPTIONS]"
    echo -e ""
    echo -e "OPTIONS:"
    echo -e "    -t=, --tag=        Tag to add to all images."
    echo -e "                       Example: {username}/image_name:{tag}"
    echo -e "    -u=, --username=   Username to add to all images"
    echo -e "                       Example: {username}/image_name:{tag}"
    echo -e "    -ag                Build SilverStrike image"
    echo -e "    -dd                Build DevDocs image"
    echo -e "    -np                Build Node.js + Python image"
    echo -e "    -sl                Build Shlink image"
    echo -e "    -sn                Build Shynet image"
    echo -e ""
    echo -e "FLAGS:\n"
    echo -e "    --help, -h         Show this help"
    echo -e ""
    echo -e "NOTES:"
    echo -e "    If no image option is provided, nothing will be built."
}

# Parse CLI arguments
for i in "$@"; do
    case $i in
    	--help|-h)
			help ; exit ;;
	    -t=*|--tag=*)
	    	TAG="${i#*=}";;
	    -u=*|--username=*)
	    	USERNAME="${i#*=}";;
        -ag)
            SILVERSTRIKE="1" ;;
        -dd)
            DEVDOCS="1" ;;
        -np)
            NODE_PYTHON="1";;
        -sl)
            SHLINK="1" ;;
        -sn)
            SHYNET="1" ;;
        *)
            echo -e "error: Unrecognized parameter $1\n"; help; exit 1;;
    esac
done

if [[ $TAG == '' ]]; then
	echo "error: TAG is not set"
	echo ""
	help
	exit 1
fi

if [[ $USERNAME == '' ]]; then
	echo "error: USERNAME is not set"
	echo ""
	help
	exit 1
fi

# Ask for sudo
if [[ "$EUID" = 0 ]]; then
    echo "Running as root"
else
	echo "Please, run as root"
	exit 1
fi

function buildSilverstrike {
	git clone https://github.com/agstrike/docker
	mv docker silverstrike
	cp Dockerfiles/silverstrike.Dockerfile silverstrike/Dockerfile
	cd silverstrike
	sudo docker build . -t $USERNAME/silverstrike:$TAG
}

function buildDevDocs {
	git clone https://github.com/freeCodeCamp/devdocs.git
	cp Dockerfiles/devdocs.Dockerfile devdocs/Dockerfile
	cd devdocs
	sudo docker build . -t $USERNAME/devdocs:$TAG
}

function buildNodePython {
	mkdir node-python
	cp Dockerfiles/node-python.Dockerfile node-python/Dockerfile
	cd node-python
	sudo docker build . -t $USERNAME/python-nodejs:$TAG
}

function buildShlink {
	git clone https://github.com/shlinkio/shlink
	cd shlink
	sudo docker build . -t $USERNAME/shlink:$TAG
}

function buildShynet {
	git clone https://github.com/milesmcc/shynet
	cd shynet
	sudo docker build . -t $USERNAME/shynet:$TAG
}

# Main logic
if [[ $SILVERSTRIKE -eq 1 ]]; then
	(buildSilverstrike)
	rm -rf silverstrike
fi

if [[ $DEVDOCS -eq 1 ]]; then
	(buildDevDocs)
	rm -rf devdocs
fi


if [[ $NODE_PYTHON -eq 1 ]]; then
	(buildNodePython)
	rm -rf node-python
fi

if [[ $SHLINK -eq 1 ]]; then
	(buildShlink)
	rm -rf shlink
fi

if [[ $SHYNET -eq 1 ]]; then
	(buildShynet)
	rm -rf shynet
fi