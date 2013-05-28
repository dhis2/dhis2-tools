#!/bin/sh
# set -e

# need to use a ppa for postgres 9.2 and nginx
sudo apt-get -y install python-software-properties -y
sudo add-apt-repository ppa:pitti/postgresql -y 
sudo add-apt-repository ppa:nginx/stable -y 
sudo apt-get -y update

# install the dhis2-tools deb
dpkg -i dhis2-tools* 
apt-get -y install -f
