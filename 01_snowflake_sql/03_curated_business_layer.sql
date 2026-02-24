/* ============================================================
   Project: Agriculture Scenario Impact Analysis
   Layer: CURATED (Scenario Modeling & Business Logic)
   Author: Prajwal Anand
   Description:
   - Applies rainfall increase (+10%)
   - Applies cultivated area reduction (-10%)
   - Uses rainfall elasticity (0.6)
   - Calculates yield adjustment (+6%)
   - Computes scenario revenue impact
   - Generates summary comparison view
   ============================================================ */


/* ------------------------------------------------------------
   1. Set Context
   ------------------------------------------------------------ */

USE DATABASE AGRICULTURE_DB;
USE SCHEMA CURATED;


/* ------------------------------------------------------------
   2. Create Analytical Table
   ------------------------------------------------------------ */

CREATE OR REPLACE TABLE CURATED.AGRICULTURE_ANALYTICS AS
SELECT
    YEAR,
    LOCATION,
    AREA,
    RAINFALL,
    TEMPERATURE,
    SOIL_TYPE,
    IRRIGATION,
    YIELDS,
    HUMIDITY,
    CROPS,
    PRICE,
    LOAD_TIMESTAMP,

    /* -----------------------------------------------------
       DIMENSION GROUPING
       ----------------------------------------------------- */

    CASE
        WHEN YEAR BETWEEN 2004 AND 2008 THEN '2004-2008'
        WHEN YEAR BETWEEN 2009 AND 2015 THEN '2009-2015'
        ELSE '2016+'
    END AS YEAR_GROUP,

    CASE
        WHEN RAINFALL < 2500 THEN 'LOW'
        WHEN RAINFALL BETWEEN 2500 AND 3200 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS RAINFALL_GROUP,


    /* -----------------------------------------------------
       BASE METRICS
       ----------------------------------------------------- */

    ROUND(YIELDS / NULLIF(AREA, 0), 2) AS BASE_YIELD_PER_AREA,
    ROUND(YIELDS * PRICE, 2) AS BASE_REVENUE,


    /* -----------------------------------------------------
       SCENARIO ASSUMPTIONS
       -----------------------------------------------------
       +10% Rainfall
       -10% Area
       Rainfall Elasticity = 0.6
       Yield Increase = 10% * 0.6 = 6%
       ----------------------------------------------------- */

    ROUND(RAINFALL * 1.10, 2) AS SCENARIO_RAINFALL,
    ROUND(AREA * 0.90, 2) AS SCENARIO_AREA,


    /* -----------------------------------------------------
       SCENARIO METRICS
       ----------------------------------------------------- */

    -- Adjusted yield per area (+6%)
    ROUND((YIELDS / NULLIF(AREA, 0)) * 1.06, 2) AS SCENARIO_YIELD_PER_AREA,

    -- Total scenario yield (adjusted yield per area × reduced area)
    ROUND(
        ((YIELDS / NULLIF(AREA, 0)) * 1.06) * (AREA * 0.90),
        2
    ) AS SCENARIO_YIELDS,

    -- Final scenario revenue
    ROUND(
        (((YIELDS / NULLIF(AREA, 0)) * 1.06) * (AREA * 0.90)) * PRICE,
        2
    ) AS SCENARIO_REVENUE

FROM AGRICULTURE_DB.STAGING.AGRICULTURE_DATA_CLEAN;



/* ------------------------------------------------------------
   3. Scenario Summary View
   ------------------------------------------------------------ */

CREATE OR REPLACE VIEW CURATED.AGRICULTURE_SCENARIO_SUMMARY AS
SELECT
    ROUND(SUM(BASE_REVENUE), 2) AS TOTAL_BASE_REVENUE,
    ROUND(SUM(SCENARIO_REVENUE), 2) AS TOTAL_SCENARIO_REVENUE,
    ROUND(SUM(SCENARIO_REVENUE) - SUM(BASE_REVENUE), 2) AS TOTAL_REVENUE_DIFF,
    ROUND(
        (SUM(SCENARIO_REVENUE) - SUM(BASE_REVENUE))
        / NULLIF(SUM(BASE_REVENUE), 0),
        2
    ) AS DIFF_PERCENTAGE
FROM CURATED.AGRICULTURE_ANALYTICS;