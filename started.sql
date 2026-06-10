CREATE DATABASE hello_world;
use database hello_world;
CREATE TABLE customer
(
  Customer_ID NUMBER,
  Name STRING,
  Address STRING,
  City STRING,
  Zip STRING,
  Country STRING

);

--sample data for the table above is present in AWS S3 at


COPY INTO customer
  FROM s3://snowpro-core-getting-started/customers.csv
  FILE_FORMAT = (TYPE = csv FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);

SELECT * FROM customer;

SELECT COUNT(*) FROM customer;
