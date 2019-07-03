# Setting up tomcat8 and DHIS2

## Security Considerations
The web application is possibly the most vulnerable component of the system
running in production.  Because of the large number of user interface components and
libraries involved, the
possibility of a vulnerability occurring in the application at some stage in the
future can be quite high.  To mitigate the risk we should:
1.  Mininmize the likliehood of running a vulnerable war file by ensuring that it
is kept up to date.  In general you should strive not to become more than 3 revisions
behind the DHIS2 current release and make sure that patch releases are applied as they
are released.
2.  Take precautions to ensure that if an attacker does succeed via the web application, 
that the damage that can be done is as limited as possible.

## OS setup
The following assumes that you are working off an ubuntu 18.04 base system.  It is recommended
that the environment is dedicated to tomcat and the DHIS2 application.  For example, it can be a 
dedicated virtual machine or a docker container or a lxd/lxc container.  In this guide we assumes
an lxc container but the same principles apply to different environments.

The detailed steps for setting the base system is given in [OS setup](OS.md).  

## Installing java and tomcat8 

The simplest way to setup the java environment is to use the openjdk runtime and install the
tomcat server from system packages.  Note that currently DHIS2 does not work with java versions 
greater than 8, so it is best to install the runtime first to that a later version doesn't get
pulled in as a tomcat dependency.  All that is required are the following commands:

```
apt-get install openjdk-8-jre-headless
apt-get install tomcat8
```

It is a good idea in production to ensure that the tomcat8 user is not able to deploy or modify
the web applications.  There are a number of ways to ensure this, but the simplest is to run:

```
rm -rf /var/lib/tomcat8/webapps/*
chown -R root.root /var/lib/tomcat8/webapps
```

This has the effect of removing any pre-installed example pages and to make sure that only the root
user can deploy webapps.  Note that you cannot then simply drop a war file into webapps.  As we will see in the section below, the war file needs to be unpacked into position.  

Besides that modification, the default permissions and settings of the ubuntu tomcat8 package are generally good.  You will need to modify the server.xml file to suit your environment.  I generally
recommend to replace it rather than modify the default one.  An example is shown below:

```

``` 

### Installing DHIS2
There are two parts to installing DHIS2.  You need to install a war file and you need to setup
the DHIS2_HOME directory.

#### Installing a war file
To deploy an instance of a dhis.war file
to an application called *hmis* you would have to do (as root):

```
rm -rf /var/lib/tomcat/webapps/*
mkdir /var/lib/tomcat/webapps/hmis
unzip dhis.war -d /var/lib/tomcat/webapps/hmis
```

In practice you would run a deployment script on the host machine to push and unpack the war file
into the container.

#### Setting up DHIS2_HOME
DHIS2 will set its home directory to the value of the DHIS2_HOME evironment variable.  If it does not
find this it will default (on linux) to use '/opt/dhis2'. 
