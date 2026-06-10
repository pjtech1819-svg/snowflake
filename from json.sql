USE DATABASE dev_lnd;
USE SCHEMA public;

CREATE TABLE flight_data_json
(
json_data VARIANT
);

CREATE OR REPLACE STAGE flights_json_stage
url='s3://ca-flight-json-data-daily/2020/07/01/'
file_format = (type = 'JSON');

LIST @flights_json_stage;

SELECT PARSE_JSON($1)
FROM @flights_json_stage;

USE DATABASE dev_lnd;

//Let us load the data into the FLIGHT_DATA_JSON table from the external stage. We will use the standard COPY command to load the data from the external stage//
COPY INTO flight_data_json
FROM @flights_json_stage;
SELECT * FROM flight_data_json;

//we will extract data out of this array in an incremental manner. Start by selecting the flights array object and reviewing the output.//
SELECT json_data:flights FROM flight_data_json;

//Since flights is a JSON array, we can access elements of this array using a numerical value. For example, to access the first value, run the following SQL.//
SELECT json_data:flights[0] FROM flight_data_json;
//Now we can try and access an individual element from this array, for example, the FL_DATE element.//
SELECT json_data:flights[0].FL_DATE
FROM flight_data_json;
//Similarly, we can access other elements in the JSON array per our requirements, as shown in the example SQL below.//
SELECT json_data:flights[0].FL_DATE,
json_data:flights[0].OP_CARRIER_FL_NUM,
json_data:flights[0].ORIGIN,
json_data:flights[0].DESTINATION
FROM flight_data_json;
//Note that the ORIGIN & the DESTINATION elements are nested JSON elements with further sub-elements. If you need sub-elements, you access them through the . syntax as shown below.//
SELECT json_data:flights[0].FL_DATE,
json_data:flights[0].OP_CARRIER_FL_NUM,
json_data:flights[0].ORIGIN.ORIGIN_STATE_ABR,
json_data:flights[0].ORIGIN.DEP_TIME,
json_data:flights[0].DESTINATION.DEST_STATE_ABR,
json_data:flights[0].DESTINATION.ARR_TIME
 
FROM flight_data_json;
//So far, we have seen that we can parse and extract elements out of the loaded JSON. However, the data is not in a tabular format that we can use in queries like other tables. For example, we can access individual elements of the flights array by specifying the element position, but it is not feasible to access each element by its position. We need to pivot the JSON data so that each element in the array becomes a row and the final data is tabular. We will use the FLATTEN function to convert the JSON array into rows. FLATTEN is a built-in Snowflake function that can convert compound values into multiple rows. It is often used to convert semi-structured data into a relational or tabular view. To do so, run the following SQL.//
SELECT
*
FROM
flight_data_json
, LATERAL FLATTEN( input => flight_data_json.json_data:flights );
//The VALUE column here contains the JSON for each row after the FLATTEN function has converted the array into multiple rows. We will use the VALUE column to extract the individual value for each row.//
SELECT
value:FL_DATE,
value:OP_CARRIER_FL_NUM,
value:ORIGIN.ORIGIN_STATE_ABR,
value:ORIGIN.DEP_TIME,
value:DESTINATION.DEST_STATE_ABR,
value:DESTINATION.ARR_TIME
FROM
flight_data_json
, LATERAL FLATTEN( input => flight_data_json.json_data:flights );

//And if you want, you can set the data type of each column and name each column as shown in the following SQL. You can also add additional columns as needed.//
SELECT
value:FL_DATE::Date AS Flight_Date,
value:OP_CARRIER_FL_NUM::String AS Airline_Flight_Number,
value:ORIGIN.ORIGIN_STATE_ABR::String AS Origin_State_Code,
value:ORIGIN.DEP_TIME::Number AS Departure_Time,
value:DESTINATION.DEST_STATE_ABR::String AS Dest_State_Code,
value:DESTINATION.ARR_TIME::Number AS Arrival_Time
FROM
flight_data_json
, LATERAL FLATTEN( input => flight_data_json.json_data:flights );
