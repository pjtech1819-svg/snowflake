--Create an additional table in the timetravel_demo database.
USE DATABASE timetravel_demo; 
CREATE TABLE CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER;

--Next, let us simulate an accidental drop of the STORE table we had previously created. To do so, run the following SQL.
DROP TABLE STORE;

--Let us validate that the table is indeed dropped by trying to run a query on the table. The query should fail.
SELECT COUNT(*) FROM STORE;

--Now, we undrop the table, which can be achieved through the following SQL.
UNDROP TABLE STORE;

--Let us run another query on the STORE table to validate that the table has indeed recovered. The following query should complete successfully, indicating that the table has been restored successfully.
SELECT COUNT(*) FROM STORE;

--Now we drop the whole timeravel_demo database.
DROP DATABASE timetravel_demo;

--Let us validate that the database is dropped by running the following set of SQLs. Each statement should fail.
USE DATABASE timetravel_demo;
SELECT COUNT(*) FROM timetravel_demo.public.STORE;


--To recover from this situation, we can use UNDROP to recover the whole database, including its children schema and any tables included in it. To do so, run the following SQL.
UNDROP DATABASE timetravel_demo;

--Let us validate that the database is restored by running the following set of SQLs. Each statement should succeed, demonstrating that the undrop was successful and has recovered the drop database and any schemas and tables within it.
USE DATABASE timetravel_demo;
SELECT COUNT(*) FROM STORE;
SELECT COUNT(*) FROM CUSTOMER;
