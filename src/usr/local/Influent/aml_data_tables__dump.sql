SELECT 
    *
FROM
    aml.accounts
INTO OUTFILE 'aml_accounts.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\n';

SELECT 
    *
FROM
    aml.transactions
INTO OUTFILE 'aml_transactions.csv' 
FIELDS ENCLOSED BY '"' 
TERMINATED BY ',' 
ESCAPED BY '"' 
LINES TERMINATED BY '\n';

