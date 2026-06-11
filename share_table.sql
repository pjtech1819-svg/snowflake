
--The following steps must be run while logged into the provider account.
--Let us start by creating a database and a table which we use to demonstrate sharing.
CREATE OR REPLACE DATABASE demo_sharing;
USE DATABASE demo_sharing;

--Next, we create a new table and populate it with some data. Let us simplify the process by using the CUSTOMER table from the Snowflake sample database. We have named the new table PROSPECTS. To create a table from the sample database, use the following SQL. 
CREATE TABLE PROSPECTS
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

--Next, switch to the ACCOUNTADMIN role, which has the required privileges to create a Share object.
USE ROLE ACCOUNTADMIN;
--Creating a new Share is a straightforward process and can be achieved through the following syntax.
CREATE SHARE shr_prospects;

--Next, we add USAGE privilege on the database and the schema containing the table to be shared. The USAGE privileges must be provided to the share before adding the table to the share. To add the USAGE privilege, run the following SQL.
GRANT USAGE ON DATABASE demo_sharing TO SHARE shr_prospects;
GRANT USAGE ON SCHEMA demo_sharing.public TO SHARE shr_prospects;
--Now we will add the PROSPECTS table to this share. To add a table to a share, grant the share SELECT access to the table. The following SQL adds the PROSPECTS table to the shr_prospects. 
GRANT SELECT ON TABLE demo_sharing.public.PROSPECTS TO SHARE shr_prospects;

--Finally, as the final step on the producer side, we add one or more consumer accounts to the share. This step requires the account name of the consumer. You can find the account name for a Snowflake account in the new Snowfl ake web user interface. The bottom left of the screen shows account information. 
ALTER SHARE shr_prospects ADD ACCOUNT = cx29211;
-To consume shared data, you must create a database on the share. The step requires knowledge of the provider account name. Please follow step 7 to determine the producer account name.
USE ROLE ACCOUNTADMIN;
CREATE DATABASE Marketing_RO FROM SHARE <provider_account_name >.shr_prospects;

--After the database has been created, you can query the table just like any other table in your system.
SELECT * FROM Marketing_RO.public.PROSPECTS;
--Let us count the number of rows in the table because, in the following steps, we will delete some rows on the provider and validate if the change is reflected on the consumer.
SELECT COUNT(*) FROM Marketing_RO.public.PROSPECTS;