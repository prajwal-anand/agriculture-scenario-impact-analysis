/* ============================================================
   Project: Agriculture Scenario Impact Analysis
   Layer: RAW (External Ingestion & Base Table Creation)
   Author: Prajwal Anand
   Description:
   - Creates database and schemas
   - Configures S3 storage integration
   - Creates external stage and file format
   - Loads raw agricultural dataset into Snowflake
   ============================================================ */
   
/* ------------------------------------------------------------
   1. Environment Setup
   ------------------------------------------------------------ */

USE ROLE accountadmin;
USE WAREHOUSE "COMPUTE_WH";

CREATE OR REPLACE DATABASE Agriculture_DB;

CREATE OR REPLACE SCHEMA Agriculture_DB.Raw;
CREATE OR REPLACE SCHEMA Agriculture_DB.Staging;
CREATE OR REPLACE SCHEMA Agriculture_DB.Curated;

USE DATABASE Agriculture_DB;
USE SCHEMA Raw;

/* ------------------------------------------------------------
   2. RAW Table Definition
   ------------------------------------------------------------ */

CREATE OR REPLACE TABLE  Raw.Agriculture_Data
(
    year            NUMBER(4,0),
    location        VARCHAR(100),
    area            NUMBER(12,2),
    rainfall        NUMBER(10,2),
    temperature     NUMBER(5,2),
    soil_type       VARCHAR(50),
    irrigation      VARCHAR(50),
    yields          NUMBER(12,2),
    humidity        NUMBER(5,2),
    crops           VARCHAR(100),
    price           NUMBER(12,2),
    season          VARCHAR(20)
);
    
/* QUERY EMPTY TABLE AND VALIDATE COLUMN NAMES AND DATA TYPES */

SELECT * FROM AGRICULTURE_DATA;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'AGRICULTURE_DATA';

/* ------------------------------------------------------------
   3. Storage Integration (AWS S3)
   ------------------------------------------------------------ */
/*
  NOTE:
  Replace placeholders with actual secure configuration.
  Infrastructure identifiers are intentionally omitted from this public repository.
*/

CREATE STORAGE INTEGRATION AGRICULTURE_S3_INTEGRATION
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
STORAGE_AWS_ROLE_ARN = '<AWS_ROLE_ARN>'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('<S3_BUCKET_PATH>')
COMMENT = 'S3 Integration For Agriculture Dataset'

/* VALIDATE SUCCESSFUL CREATION OF STORAGE INTEGRATION */
DESCRIBE INTEGRATION AGRICULTURE_S3_INTEGRATION;
SHOW STORAGE INTEGRATIONS;

GRANT USAGE ON INTEGRATION AGRICULTURE_S3_INTEGRATION TO ROLE ACCOUNTADMIN;

/* ------------------------------------------------------------
   4. File Format & Stage Creation
   ------------------------------------------------------------ */

CREATE OR REPLACE FILE FORMAT RAW.CSV_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
NULL_IF = ('NULL', 'null', '')

CREATE STAGE RAW.AGRICULTURE_S3_STAGE
URL = '<S3_BUCKET_PATH>'
STORAGE_INTEGRATION = AGRICULTURE_S3_INTEGRATION
FILE_FORMAT = RAW.CSV_FORMAT
COMMENT = 'Agriculture CSV Stage for Raw Data'

GRANT USAGE ON STAGE RAW.AGRICULTURE_S3_STAGE TO ROLE ACCOUNTADMIN;

/* VALIDATE SUCCESSFUL STAGE CREATION */
SHOW STAGES;
LIST @RAW.AGRIGULTURE_S3_STAGE;

/* ------------------------------------------------------------
   5. Load Data into RAW Table
   ------------------------------------------------------------ */

COPY INTO RAW.AGRICULTURE_DATA
FROM @RAW.AGRICULTURE_S3_STAGE
on_error = 'ABORT_STATEMENT';

SELECT * FROM RAW.AGRICULTURE_DATA;