--We start by creating a new database called sample_data_db. We intend to create two child schemas in this database and populate a few tables in each schema using the sample data provided by Snowflake.
CREATE DATABASE SAMPLE_DATA_DB;
USE DATABASE SAMPLE_DATA_DB; 

--Next, we create a schema in sample_data_db called sample_schema1. We will then create three tables in this schema and demonstrate schema cloning using this schema.
CREATE SCHEMA SAMPLE_SCHEMA1;
USE SCHEMA SAMPLE_SCHEMA1;
CREATE TABLE CUSTOMER AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
CREATE TABLE NATION AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;
CREATE TABLE REGION AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION;

--Let us create an additional schema to demonstrate that during a database cloning operation, the database, its child schemas, and all the child tables are cloned. To create the schema and some sample tables, run the following SQL.
CREATE SCHEMA SAMPLE_SCHEMA2;
USE SCHEMA SAMPLE_SCHEMA2;
CREATE TABLE DATE_DIM AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.DATE_DIM;
CREATE TABLE STORE AS SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.STORE;

--Let us now create a database to demonstrate schema cloning. 
CREATE DATABASE DEMO_SCHEMA_CLONING;
USE DATABASE DEMO_SCHEMA_CLONING;

--To clone the complete SAMPLE_SCHEMA1 run the following SQL. Notice that we use the CLONE keyword during the schema creation process.
CREATE SCHEMA MY_SAMPLE_SCHEMA CLONE SAMPLE_DATA_DB.SAMPLE_SCHEMA1;

--Once the schema creation is complete, use the Snowflake web user interface to view the DEMO_SCHEMA_CLONING  database, its child schemas, and the table within. You will notice that the cloned schema (MY_SAMPLE_SCHEMA) contains all the tables present in the SAMPLE_SCHEMA1. The screenshot below shows the cloned schema


--Next, we demonstrate complete database cloning. The syntax is straightforward and requires using the CLONE keyword during the creation process. To clone the complete SAMPLE_DATA_DB database, run the following SQL.
CREATE DATABASE DEMO_DATABASE_CLONING CLONE SAMPLE_DATA_DB;

--Once the database is created, use the Snowflake web user interface to view the DEMO_DATABASE_CLONING  database, its child schemas, and the table within. You will notice that the cloned database contains all the schemas (SAMPLE_SCHEMA1, SAMPLE_SCHEMA2) from the source database, and all tables contained within the sources schemas are present in the cloned schemas, as shown below.
