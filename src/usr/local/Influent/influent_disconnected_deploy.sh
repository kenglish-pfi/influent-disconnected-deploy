#!/bin/bash

# !!! Run this script as root
#
# install mysql if not already installed
# service mysqld start
#
# copy the file influent_all.zip to the directory /usr/local/Influent
#
mysql -V
mvn --version
service mysqld status
if [ $? != 0 ]; then
    echo MySQL must be running
    exit
fi

cd /usr/local/Influent
unzip influent_all.zip

chmod a+x influent_disconnected_start.sh aml_data__load.sh

cd
unzip -u /usr/local/Influent/m2.zip
cd /usr/local/Influent
unzip aml_mysqldump.zip
mysql < AML.sql
mysql <<__GRANT_HERE__
CREATE USER 'influent'@'%' IDENTIFIED BY 'influent';
GRANT ALL PRIVILEGES ON *.* TO 'influent'@'%' WITH GRANT OPTION;
CREATE USER 'influent'@'localhost' IDENTIFIED BY 'influent';
GRANT ALL PRIVILEGES ON *.* TO 'influent'@'localhost' WITH GRANT OPTION;
__GRANT_HERE__
unzip solr-4.9.1.zip
# Overlay Solr conf and lib folders
unzip aml_solr_conflib.zip
mkdir solr-4.9.1/example/solr/aml/data
mkdir /usr/local/Influent/log

unzip unchartedsoftware-2.0.zip
cd /usr/local/Influent/unchartedsoftware/aperturejs
mvn install
cd /usr/local/Influent/unchartedsoftware/ensemble-clustering
mvn install
cd /usr/local/Influent/unchartedsoftware/influent
mvn install
cd /usr/local/Influent
