#!/bin/sh
# set -e

# new way to install postgres 9.2 (https://wiki.postgresql.org/wiki/Apt)
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" >/etc/apt/sources.list.d/pgdg.list
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

# need to use a ppa for nginx
sudo apt-get -y install python-software-properties -y
sudo add-apt-repository ppa:nginx/stable -y 
sudo apt-get -y update

# install the dhis2-tools deb
dpkg -i dhis2-tools* 
apt-get -y install -f
