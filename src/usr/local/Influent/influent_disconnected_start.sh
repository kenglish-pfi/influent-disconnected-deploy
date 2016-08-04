#!/bin/bash

cd /usr/local/Influent/solr-4.9.1/example
java -jar start.jar > /usr/local/Influent/log/solr.log 2>&1 &

cd /usr/local/Influent/unchartedsoftware/influent/influent-app
export MAVEN_OPTS=-Xmx3G
mvn package jetty:run > /usr/local/Influent/log/influent.log 2>&1 &

cat << __FURTHER_INSTRUCTIONS__
You should now be able to access the following URLs:
Solr:
    http://localhost:8983/solr/#/
Influent:
    http://localhost:8080/influent/

__FURTHER_INSTRUCTIONS__