# update a dockerized IRIS container
#
# build the new image with:
# $ docker build --force-rm --no-cache

FROM docker.iscinternal.com:5000/isc-iris:gs2017


# configure defaults
COPY DefaultInstallerClass.xml $ISC_PACKAGE_INSTALLDIR/mgr/
COPY UsersExport.xml $ISC_PACKAGE_INSTALLDIR/mgr/
COPY cache.key $ISC_PACKAGE_INSTALLDIR/mgr/
COPY coffeemakers.gof $ISC_PACKAGE_INSTALLDIR/mgr/
COPY BeforeDemoAndEx2.xml $ISC_PACKAGE_INSTALLDIR/mgr/
ADD coffee.tar.gz $ISC_PACKAGE_INSTALLDIR/csp/
COPY install.scr $ISC_PACKAGE_INSTALLDIR/mgr/

 # Start Caché
 RUN ccontrol start $ISC_PACKAGE_INSTANCENAME \

 # run install script
 && csession $ISC_PACKAGE_INSTANCENAME -U%SYS < /usr/cachesys/mgr/install.scr \

 # Stop Cache
 && ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly \

 #remove install.scr
 && rm /usr/cachesys/mgr/install.scr



# Create temporary folder
RUN mkdir /tmp/webterminal


COPY WebTerminal-v4.6.1.xml /tmp/webterminal/webterminal.xml

# Start InterSystems IRIS Instance
# Generate login and password for csession if needed, and Load downloaded xml with compilation
# WebTerminal will be installed during compilation process

#RUN ccontrol start $ISC_PACKAGE_INSTANCENAME && printf "_SYSTEM\nSYS\n" \
# |  csession $ISC_PACKAGE_INSTANCENAME -UUSER "##class(%SYSTEM.OBJ).Load(\"/tmp/webterminal/webterminal.xml\",\"cdk\")"

#RUN ccontrol start $ISC_PACKAGE_INSTANCENAME && printf "_SYSTEM\nSYS\n" \
# |  csession $ISC_PACKAGE_INSTANCENAME -UENSEMBLE "##class(%SYSTEM.OBJ).Load(\"/usr/cachesys/mgr/BeforeDemoAndEx2.xml\",\"cdk\")"

# Stop Caché instance
# 	RUN ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly 

# Clean Temporary folder
RUN rm -rf /tmp/webterminal/