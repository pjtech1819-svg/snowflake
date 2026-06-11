--We start by creating a new database called test_cloning.
CREATE OR REPLACE DATABASE test_cloning;
USE DATABASE test_cloning; 

--Next, we create a table that will be used to demonstrate the cloning concepts. Let us load this table with data from the sample database. Note that we have purposedly chosen a table approximately 10GB in size. This demonstrates the duration it takes to copy a large table physically. We are using the create table as (CTAS) expression to create this table which reads all data in the CUSTOMER table in the sample data database and populates a table with the same name in the test_cloning database.
CREATE TABLE test_cloning.public.CUSTOMER
AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000.CUSTOMER;

--Let us find out what is the count of rows in this table. You should see around 15M rows in this table.
SELECT COUNT(*) FROM CUSTOMER;

--Now we clone the CUSTOMER table to another table called CUSTOMER_COPY. We will use the CLONE keyword in the CREATE TABLE statement to create a table as a clone of another table. The following CLONE statement should execute much faster than our step 2 since cloning is a metadata-only operation.
CREATE TABLE CUSTOMER_COPY CLONE CUSTOMER;

--Let us find out the count of rows in the cloned table. You should see around 15M rows in the cloned table, indicating that the two tables have the same data.
SELECT COUNT(*) FROM CUSTOMER_COPY;

--We will demonstrate that although the CUSTOMER_COPY table has been cloned from the CUSTOMER table. The two can be updated independently, contain different data, and not impact each other when updates are performed. To demonstrate this, we update the C_MKTSEGMENT column in the cloned CUSTOMER_COPY table as shown in the following SQL.
UPDATE CUSTOMER_COPY SET C_MKTSEGMENT = 'AUTO' WHERE C_MKTSEGMENT =
'AUTOMOBILE';

--Let us now check what distinct marketing segments exist in both tables by running the following SQLs. 
SELECT DISTINCT C_MKTSEGMENT FROM CUSTOMER;
SELECT DISTINCT C_MKTSEGMENT FROM CUSTOMER_COPY;

--You will see that the C_MKTSEGMENT columns are almost identical in both tables; however, one table has the AUTOMOBILE segment, and the other has the AUTO segment (since we had performed that update). This demonstrates that a cloned table can be changed independently of the source table and vice versa.