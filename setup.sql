-- =====================================================================
-- 0) CONTEXTO (opcional)
-- =====================================================================
-- USE ROLE SYSADMIN;

-- =====================================================================
-- 1) WAREHOUSE LEVE (economiza custo, auto-suspende)
-- =====================================================================
CREATE WAREHOUSE IF NOT EXISTS LAB_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE LAB_WH;

-- =====================================================================
-- 2) DATABASE E SCHEMAS
-- =====================================================================
CREATE DATABASE IF NOT EXISTS LAB_DWH;
USE DATABASE LAB_DWH;

CREATE SCHEMA IF NOT EXISTS STAGING;  -- dados de origem
CREATE SCHEMA IF NOT EXISTS DWH;      -- modelo analítico (estrela)

-- =====================================================================
-- 3) AIRBYTE INTEGRATION
-- =====================================================================
CREATE DATABASE LAB_AIRBYTE;
CREATE SCHEMA STAGING;
CREATE ROLE AIRBYTE_DEV;

CREATE USER AIRBYTE_DEV
  DEFAULT_ROLE = AIRBYTE_DEV
  DEFAULT_WAREHOUSE = LAB_WH
  DEFAULT_NAMESPACE = LAB_AIRBYTE.PUBLIC
  PASSWORD = 'mudar@123';

GRANT ROLE AIRBYTE_DEV TO USER AIRBYTE_DEV;

-- Use of the warehouse, database and schema
GRANT USAGE ON WAREHOUSE LAB_WH TO ROLE AIRBYTE_DEV;
GRANT OPERATE ON WAREHOUSE LAB_WH TO ROLE AIRBYTE_DEV;
GRANT USAGE ON DATABASE LAB_AIRBYTE TO ROLE AIRBYTE_DEV;
GRANT USAGE ON SCHEMA LAB_AIRBYTE.PUBLIC TO ROLE AIRBYTE_DEV;
GRANT USAGE ON SCHEMA LAB_AIRBYTE.STAGING TO ROLE AIRBYTE_DEV;

-- To access to tables
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA LAB_AIRBYTE.PUBLIC TO ROLE AIRBYTE_DEV;
GRANT SELECT, UPDATE, INSERT, DELETE ON FUTURE TABLES IN SCHEMA LAB_AIRBYTE.PUBLIC TO ROLE AIRBYTE_DEV;

-- To create schemas and tables
GRANT CREATE SCHEMA ON DATABASE LAB_AIRBYTE TO ROLE AIRBYTE_DEV;
GRANT CREATE TABLE ON SCHEMA LAB_AIRBYTE.PUBLIC TO ROLE AIRBYTE_DEV;
GRANT CREATE FUNCTION ON SCHEMA LAB_AIRBYTE.PUBLIC TO ROLE AIRBYTE_DEV;
