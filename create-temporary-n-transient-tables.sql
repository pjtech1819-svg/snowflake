--We start by creating a database in which we will create our tables.
CREATE DATABASE failsafe_demo;
USE DATABASE failsafe_demo;

--Let us create a temporary table first. The syntax is quite similar to a normal table, except that we add the TEMPORARY keyword before the TABLE keyword. Here we are creating the table with some sample data.
CREATE TEMPORARY TABLE CUSTOMER_TEMP
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;

--Validate that the table is created and has data by running a count query on it.
SELECT COUNT(*) FROM CUSTOMER_TEMP;

--Since we are going to demonstrate Time Travel functionality for temporary tables, we will make note of the current time stamp which we will use in the next steps. To do so, run the following SQL and save the output somewhere.
SELECT CURRENT_TIMESTAMP;

--Let us now update the table and set the C_NAME to NULL for the whole table.
UPDATE CUSTOMER_TEMP SET C_NAME = NULL;

--Now we will use the Time Travel extension just like we have used it in previous labs to see the state of data before the update was run. To do so, run the following SQL and make sure you replace the <timestamp> placeholder with the timestamp from step 4. This step will return non NULL values indicating that you are accessing the table before the update.
SELECT DISTINCT C_NAME FROM CUSTOMER_TEMP
AT(TIMESTAMP => '<timestamp>'::timestamp_ltz);

--The previous step demonstrates that the Time Travel extensions work for temporary tables. However, note that the Time Travel for temporary tables is only 1 days, so if you tried this same SQL after 24 hours, you will not get the desired results. 
--Now to demonstrate that a temporary table is not available in a different session, open a new worksheet (or if using SnowSQL, start another SnowSQL session). Run the following SQL. The SELECT statement will fail because the temporary table CUSTOMER_TEMP is not available outside of the session it was created in.
USE DATABASE failsafe_demo;
SELECT * FROM CUSTOMER_TEMP;

--Let us now demonstrate the same concepts for a transient table.  Again, the syntax is quite similar to a normal table creation, except that we add the TRANSIENT keyword before the TABLE keyword. Here we are creating the table with some sample data.
USE DATABASE failsafe_demo;
CREATE TRANSIENT TABLE NATION_TRA
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;

--Validate that the table is created and has data by running a count query on it.
SELECT COUNT(*) FROM NATION_TRA;

--Since we are going to demonstrate Time Travel functionality for transient tables, we will make note of the current time stamp which we will use in the next steps. To do so, run the following SQL and save the output somewhere.
SELECT CURRENT_TIMESTAMP;

--Let us now update the table and set the N_COMMENT to NULL for the whole table.
UPDATE NATION_TRA SET N_COMMENT = NULL;

--Now we will use the Time Travel extension just like we have used it in previous labs to see the state of data before the update was run. To do so, run the following SQL and make sure you replace the <timestamp> placeholder with the timestamp from step 11. This step will return non NULL values indicating that you are accessing the table before the update.
SELECT DISTINCT N_COMMENT FROM NATION_TRA
AT(TIMESTAMP => '<timestamp>'::timestamp_ltz);

--Now to demonstrate that a transient table is available in a different session, open a new worksheet (or if using SnowSQL, start another SnowSQL session). Run the following SQL. The SELECT statement will succeed because the transient table NATION_TEMP can be accessed from any session assuming the user has the required rights.
SELECT * FROM NATION_TRA;

--Another way to check that a table is available across sessions it to view the table through the user interface. You will notice that it shows up in the database/table tree as shown.

 
