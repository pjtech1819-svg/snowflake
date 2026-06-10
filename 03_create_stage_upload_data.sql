CREATE OR REPLACE STAGE LU_Airport_CSV_Stage
  FILE_FORMAT = (TYPE = csv FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);


--This next step must be run through SnowSQL. 

USE DATABASE dev_lnd;
PUT 'file:///C:\Users/pj/course/L_AIRPORT_ID.csv' @LU_Airport_CSV_Stage;


--Please remember that the previous step’s <PATH> placeholder needs to be updated with the path to the L_AIRPORT_ID.csv file you just uploaded. Also, remember to use forwards slashes instead of backslashes when creating the route. It follows then that if you’re operating on a PC running Windows, and the file is located in the C:\Users\smith\ L_AIRPORT_ID.csv, then you’ll need to specify the C:/Users/smith/ L_AIRPORT_ID.csv in the PUT statement.


LIST @LU_Airport_CSV_Stage;