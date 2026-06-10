CREATE OR REPLACE STAGE flights_stage
  url='s3://ca-flight-data-daily/2020/06/01/'
  file_format = (type = 'CSV' field_delimiter = ',' field_optionally_enclosed_by = '"' skip_header = 1);


LIST @flights_stage;


USE DATABASE dev_lnd;
COPY INTO Flight_Details
  FROM @flights_stage
 PATTERN = '.*[.]csv';
 
 
 SELECT * FROM Flight_Details;