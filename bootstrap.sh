#!/usr/bin/env bash
add-apt-repository ppa:chris-lea/node.js
apt-get update

# Install nodejs & npm
apt-get install -y python-software-properties python g++ make
apt-get install -y nodejs
