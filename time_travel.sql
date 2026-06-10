--Let us start by creating a database in which we will create our test tables.
CREATE DATABASE timetravel_demo;
USE DATABASE timetravel_demo; 

--Next, we will create a new table and populate it with some data. You can always create a new table and load new data using the COPY command, but to simplify the process, let us use a table from the Snowflake sample database. To create a table from the sample database, use the following SQL.
CREATE TABLE STORE
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE;

--Let us validate that our table has some data by running a count query on the table as follows.
SELECT COUNT(*) FROM STORE;

--Because our next step will be to perform an accidental update of the table, let us note the current time before we perform the next step. To do so, run the following SQL and make sure you save the output somewhere, e.g., in notepad. 
SELECT CURRENT_TIMESTAMP;

--Now let us update one of the table’s columns. The idea is to simulate an accidental update of a complete column. 
UPDATE STORE SET s_manager = NULL;

--Now, if we do a SELECT * from the table, you will note that the s_manager column is NULL as expected.
SELECT * FROM STORE;

--To recover from this situation, we can use the Time Travel capability to access the data as it existed before the accidental update. To do so, we will use the BEFORE clause and the timestamp parameter to see the table data as it existed before the specified time. To do so, please use the timestamp value that you would have copied from step 4. Once you run the SQL, notice that in the result set, the s_manager field has a non NULL value, indicating that it is the state of the table as it existed before the update was run.
SELECT * FROM STORE
BEFORE(TIMESTAMP => '2026-06-10 09:37:07.632 -0700'::timestamp_ltz);

--Note that we used the BEFORE clause to get this data. In this specific situation, the AT clause will also return the same results because AT returns the data before and inclusive of the provided parameter value, which in this case is the timestamp. So the AT clause will return the data as it existed at that timestamp, and we know that we hadn’t run the update at that timestamp.
SELECT * FROM STORE
AT(TIMESTAMP => '2026-06-10 09:40:07.632 -0700'::timestamp_ltz);

--Let us now delete all rows from the table to simulate an accidental removal of all rows in a table.
--Make sure you copy the Query ID of the statement being run, as it will be required for the next step.
DELETE FROM STORE;

--Let us count the number of rows in the table using the following SQL. The result should be zero since all rows have been deleted. 
SELECT COUNT(*) FROM STORE;

--Now we will use the BEFORE syntax with statement parameter to get the state of the data as it existed before the UPDATE query was run. To do so run the following SQL, but make sure to replace the <query id> placeholder with the Query ID that you copied from step 9.
SELECT * FROM STORE
BEFORE(STATEMENT => '01c4f5af-3202-c832-0017-2292000d3e3e');

--The previous query should return a non-zero result showing data before the DELETE statement was run. Note that in this case, if we use the AT clause rather than BEFORE, we will not get the same results. The AT clause includes the changes, which means it will include the changes done by the UPDATE query. You can test that by running the following SQL.
SELECT * FROM STORE
AT(STATEMENT => '01c4f5af-3202-c832-0017-2292000d3e3e');

--Finally, before we finish this lab, let us try one more time travel method: the offset parameter. Offset specifies the number of seconds from the current time, so as an example, a negative 300 value will result in data being returned from 5 minutes ago. You can use the following SQL to see how Time Travel works with the offset parameter. Please change -120 with other negative values to see how data existed at various points in time during this exercise. The values will differ for each individual and will depend on how fast or slow you went through the lab steps. Note: if you specify a time too much into the past, you may get this error “Time travel data is not available for table STORE. The requested time is either beyond the allowed time travel period or before the object creation time.”
SELECT * FROM STORE
AT(OFFSET => -300);