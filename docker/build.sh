#!/bin/bash
mkdir node-python
cp Dockerfiles/node-python.Dockerfile node-python/Dockerfile
cd node-python
sudo docker build . -t srgmc/python-nodejs:n12-p3.9

cd ..

git clone https://github.com/agstrike/docker
mv docker silverstrike
cp Dockerfiles/silverstrike.Dockerfile silverstrike/Dockerfile
cd silverstrike
sudo docker build . -t srgmc/silverstrike:armv7l

cd ..

git clone https://github.com/shlinkio/shlink
cd shlink
sudo docker build . -t srgmc/shlink:armv7l

cd ..

git clone https://github.com/milesmcc/shynet
cd shynet
sudo docker build . -t srgmc/shynet:armv7l

cd ..

git clone https://github.com/freeCodeCamp/devdocs.git
cp Dockerfiles/devdocs.Dockerfile devdocs/Dockerfile
cd devdocs
sudo docker build . -t srgmc/devdocs:armv7l

cd ..

docker build -t plexinc/pms-docker:latest -f Dockerfile.armv7 .