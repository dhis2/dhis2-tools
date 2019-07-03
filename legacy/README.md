![DHIS2 logo](../dhis2_logo.png)

DHIS2 tools readme.

The package can be installed by running the provided install script or by:

```bash
$ sudo add-apt-repository ppa:bobjolliffe/dhis2-tools
$ sudo apt-get update
$ sudo apt-get install dhis2-tools
```   
  
The lines below are a little out of date ...

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
