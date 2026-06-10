USE DATABASE dev_lnd;
COPY INTO LU_Airport
  FROM @LU_Airport_CSV_Stage;

SELECT * FROM LU_Airport;

REMOVE @LU_Airport_CSV_Stage;