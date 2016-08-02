#!/bin/bash
#
#  A very important discussion related to CentOs and MySql's ability to
#  read and write data files:  https://blogs.oracle.com/jsmyth/entry/selinux_and_mysql
#

DB_DIR=/var/lib/mysql/aml/

ACCOUNT_CSV_FILE=$DB_DIR`basename $1`
TRANS_CSV_FILE=$DB_DIR`basename $2`

service mysqld status
if [ $? != 0 ]; then
    echo MySQL must be running
    exit
fi

cp $1 $DB_DIR
cp $2 $DB_DIR
chmod a+rw $ACCOUNT_CSV_FILE $TRANS_CSV_FILE
chgrp mysql $ACCOUNT_CSV_FILE $TRANS_CSV_FILE
chown mysql $ACCOUNT_CSV_FILE $TRANS_CSV_FILE
chmod a+rw $ACCOUNT_CSV_FILE $TRANS_CSV_FILE

ls -l $DB_DIR

ACCOUNT_CSV_FILE_QUOTED="'"`basename $1`"'"
TRANS_CSV_FILE_QUOTED="'"`basename $2`"'"

mysql < aml_data_tables__recreate.sql
mysql << __LOAD_SCRIPT__
use aml;

LOAD DATA INFILE $ACCOUNT_CSV_FILE_QUOTED
INTO TABLE accounts
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

LOAD DATA INFILE $TRANS_CSV_FILE_QUOTED
INTO TABLE transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

__LOAD_SCRIPT__

rm $ACCOUNT_CSV_FILE 
rm $TRANS_CSV_FILE 

ls

mysql < aml_influent_tables__recreate.sql
mysql < aml_influent_tables__populate.sql

cat << __FURTHER_INSTRUCTIONS__
The Solr Index must now be re-built.
1.  Unload the AML core in the Solr Admin Tool  (http://localhost:8983/solr/#/~cores/aml)
2.  Recreate the AML core:  http://localhost:8983/solr
3.  Go to Core Admin and click Add Core button
4.  Enter the following:
  o  name:         aml
  o  instanceDir:  /usr/local/Influent/solr-4.9.1/example/solr/aml/
  o  dataDir:      /usr/local/Influent/solr-4.9.1/example/solr/aml/data/
  o  config:       solrconfig.xml
  o  schema:       schema.xml
5. Click Add Core Button
6. Browse back to the “Solr Dashboard”
7. Choose “aml” in the “Core Selector” drop down in the LHS panel
8. Choose “Dataimport” in the menu tree below the Core Selector in the LHS panel
9. Click “Execute”
   <Wait>
   Click “Refresh Status” button periodically until you see:  "Indexing completed"
__FURTHER_INSTRUCTIONS__
