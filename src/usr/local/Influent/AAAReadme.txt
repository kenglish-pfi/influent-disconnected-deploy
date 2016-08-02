The copy-deploy of Influent 2.0 that has been tested on CentOs 6.5 and scripts to support replacing the financial data.  

Steps to use:
1. Make sure pre-requisites are installed on CentOs:
    a.      MySQL
    b.      Maven
2. Create the directory
    /usr/local/Influent
    (Yes, that is a capitol “I” on Influent)
3. Copy these two files into /usr/local/Influent: 
    https://s3.amazonaws.com/influent/influent_all.zip 
    https://s3.amazonaws.com/influent/influent_disconnected_deploy.sh
4. Run influent_disconnected_deploy.sh
5. Run influent_disconnected_start.sh
6. Follow the instructions at the end of the aml_data__load.sh starting at Step 2 in order to get the demo data indexed
7. Influent should be available at 
   http://localhost:8080/influent/
8. The data can be replaced by running the aml_data__load.sh script and passing as parameters the entity and transaction CSVs and then following the re-indexing instructions it prints at the end.
