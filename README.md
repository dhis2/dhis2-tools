     ____  __  ______________ 
    / __ \/ / / /  _/ ___/__ \
   / / / / /_/ // / \__ \__/ /
  / /_/ / __  // / ___/ / __/ 
 /_____/_/ /_/___//____/____/
 
DHIS2 tools readme.

The package can be installed by running:
  ```bash
  $ sudo add-apt-repository ppa:simjes91/dhis2-tools
  $ sudo apt-get update
  $ sudo apt-get install dhis2-tools
  ```

To build the debian package from source (on a linux computer), run the following commands in the dhis2-tools folder:
  ```bash
  $ make
  ```
This will assemble the source files into a dhis2-tools_x.xubuntu2_all.deb package.  
Required to build:  
* xsltproc  
* docbook-xsl  
* ubuntu-dev-tools  
* debhelper
