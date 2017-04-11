#!/usr/bin/env bash
#       ____  __  ______________
#      / __ \/ / / /  _/ ___/__ \
#     / / / / /_/ // / \__ \__/ /
#    / /_/ / __  // / ___/ / __/
#   /_____/_/ /_/___//____/____/
#
#   DHIS2 installation helper script

set -e

# Make sure we are on a supported distribution
DISTRO=$(lsb_release -si)
RELEASE=$(lsb_release -sr)

echo "Attempting installion of dhis2-tools on $DISTRO linux version $RELEASE"
# No CentOS version yet :-(
if [ $DISTRO != 'Ubuntu' ]
then
  echo "Sorry installation only supported on Ubuntu at this time"
  echo "Exiting ..."
  exit 1
fi

# Only tested on LTS Ubuntu versions
case $RELEASE in

  14.04)
    echo "installing on 14.04";;

  16.04)
    echo "installing on 16.04";;

  *)
    echo "The PPA only contains packages for Ubuntu LTS 14.04 and 16.04";
    echo "You can build for other versions if you want, the source code is located at https://github.com/dhis2/dhis2-tools";
    echo "Exiting ...";
    exit 1;;
esac


#add PPA
apt-get install software-properties-common
add-apt-repository -y ppa:bobjolliffe/dhis2-tools
add-apt-repository -y ppa:webupd8team/java
apt-get -y update

#accept oracle license
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

#install java8 and dhis2-tools
apt-get -y install oracle-java8-installer
apt-get -y install dhis2-tools


# Uncomment below to install postgres and nginx servers on this machine
# apt-get -y install nginx postgresql
echo "The dhis2-tools are now installed. You may also want to"
echo "install nginx and postgresql servers on this machine. You"
echo "can do so by running:"
echo
echo "apt-get install nginx postgresql"
echo
echo "You should check out the DHIS2 documentation for Postgres performance tuning and more configuration help: https://goo.gl/8GGtIB"
echo
echo "Type 'apropos dhis2' to see available manual pages."
