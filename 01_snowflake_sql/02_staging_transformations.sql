/* ============================================================
   Project: Agriculture Scenario Impact Analysis
   Layer: STAGING (Data Cleaning & Standardization)
   Author: Prajwal Anand
   Description:
   - Cleans RAW agricultural dataset
   - Standardizes categorical fields
   - Applies basic data validation rules
   - Prepares dataset for scenario modeling
   ============================================================ */


/* ------------------------------------------------------------
   1. Set Context
   ------------------------------------------------------------ */

USE DATABASE AGRICULTURE_DB;
USE SCHEMA STAGING;


/* ------------------------------------------------------------
   2. Create Cleaned Staging Table
   ------------------------------------------------------------ */

CREATE OR REPLACE TABLE AGRICULTURE_DATA_CLEAN AS
SELECT
    YEAR,

    /* Standardize text fields */
    TRIM(UPPER(LOCATION))    AS LOCATION,
    TRIM(UPPER(SOIL_TYPE))   AS SOIL_TYPE,
    TRIM(UPPER(IRRIGATION))  AS IRRIGATION,
    TRIM(UPPER(CROPS))       AS CROPS,

    /* Numerical fields */
    AREA,
    RAINFALL,
    TEMPERATURE,
    YIELDS,
    HUMIDITY,
    PRICE,

    /* Metadata */
    CURRENT_TIMESTAMP()      AS LOAD_TIMESTAMP

FROM AGRICULTURE_DB.RAW.AGRICULTURE_DATA

/* Basic data validation */
WHERE YEAR IS NOT NULL
  AND AREA > 0
  AND YIELDS >= 0;