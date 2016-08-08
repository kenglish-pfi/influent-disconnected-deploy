# influent-disconnected-deploy
Deployment scripts and a release of Inlfuent 2.0

This is a copy-deploy of Influent 2.0 that has been tested on CentOs 6.5 on a disconnected system and scripts to support replacing the financial data.  [See](https://github.com/unchartedsoftware/influent) 

Steps to use:

1. Make sure pre-requisites are installed on CentOs:
  * MySQL
  * Maven
    
2. Create the directory  
    /usr/local/Influent  
    (Yes, that is a capitol “I” on Influent)
    
3. Copy these two files into /usr/local/Influent:  
    https://s3.amazonaws.com/influent/influent_all.zip  
    ./src/usr/local/Influent/influent_disconnected_deploy.sh
    
4. Run influent_disconnected_deploy.sh

5. Run influent_disconnected_start.sh

6. Follow the instructions at the end of the aml_data__load.sh starting at Step 2 in order to get the demo data indexed

7. Influent should be available at  
   http://localhost:8080/influent/
   
8. The data can be replaced by running the aml_data__load.sh script and passing as parameters the entity and transaction CSVs and then following the re-indexing instructions it prints at the end.

Note: The scripts in ./src/usr/local/Influent in this repo other than influent_disconnected_deploy.sh are included in the top level directory of the Zip.  It is prudent to verify that the Zip you obtain contains the latest versions of these scripts.
