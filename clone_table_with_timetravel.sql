--start by creating a new database called test_timetravel_cloning.
CREATE OR REPLACE DATABASE test_timetravel_cloning;
USE DATABASE test_timetravel_cloning; 

--Next, we create a table that will be used to demonstrate cloning with time travel concepts. Let us load this table with data from the sample database. We are using the create table as (CTAS) expression to create this table which reads all data in the CUSTOMER table in the sample data database and populates a table with the same name in the test_timetravel_cloning database.
CREATE TABLE test_timetravel_cloning.public.CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.CUSTOMER;

--Let us find out the count of rows in this table. You should see around 1.5M rows in this table.
SELECT COUNT(*) FROM CUSTOMER;

--Let's us note the current time before we perform the next step. To do so, run the following SQL and make sure you save the output somewhere, e.g., in notepad. 
SELECT CURRENT_TIMESTAMP;

--Let us update the customer table and set all names to John Smith.
UPDATE CUSTOMER SET C_NAME = 'John Smith';


--Now, we clone the CUSTOMER table to another table called CUSTOMER_COPY while using the Time Travel extensions. We will create the clone as it existed before the names were changed to John Smith. Please make sure you replace the <timestamp> below with the timestamp copied from step 4.
CREATE TABLE CUSTOMER_COPY CLONE CUSTOMER BEFORE(TIMESTAMP => '2026-06-10 11:32:29.615 -0700'::timestamp_ltz);

--Let us find distinct names in the cloned table. Since it was a clone before the update query was run, we should see several names in the result, not just John Smith. 
SELECT DISTINCT C_NAME FROM CUSTOMER_COPY;

SELECT DISTINCT C_NAME FROM CUSTOMER;