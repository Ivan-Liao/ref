begin;
------------------------------------------------------
--# Configuration
------------------------------------------------------
--------------------------
--## Set These Variables Every Time
--------------------------
set CLIENT = '<YOUR_CLIENT>'; -- e.g. ATT
set SISENSE_SERVICE_PWD = '<YOUR_PASSWORD>';  -- Self generate and save in data engineering 1pass vault
--------------------------
--## Default Variables (changed sometimes)
--------------------------
set DEFAULT_SISENSE_WAREHOUSE = 'SISENSE_WH';
set DEFAULT_REPORTING_WAREHOUSE = 'REPORTING_WH';
set DEFAULT_DATASCIENCE_WAREHOUSE = 'DATASCIENCE_WH';
set KAFKA_CONNECT_ROLE = 'KAFKA_CONNECT_ROLE'
set KAFKA_CONNECT_DEV_ROLE = 'KAFKA_CONNECT_DEV_ROLE'
--------------------------
--## Derived Variables
--------------------------
--
--### Database and Schema Variables
--
set DB_RAW_CLIENT= 'RAW_' || $CLIENT;
set DB_RAW_CLIENT_SCHEMA_APPLICATION = $DB_RAW_CLIENT || '.APPLICATION';
set DB_RAW_CLIENT_SCHEMA_PRE_IMPLEMENTATION = $DB_RAW_CLIENT || '.PRE_IMPLEMENTATION';
set DB_RAW_CLIENT_SCHEMA_POST_IMPLEMENTATION = $DB_RAW_CLIENT || '.POST_IMPLEMENTATION';
set DB_DW_CLIENT = 'DW_' || $CLIENT;
set DB_DW_CLIENT_SCHEMA_APPLICATION = $DB_DW_CLIENT || '.APPLICATION';
set DB_DW_CLIENT_SCHEMA_DATA_SCIENCE = $DB_DW_CLIENT || '.DATA_SCIENCE';
set DB_DW_CLIENT_SCHEMA_PRE_IMPLEMENTATION = $DB_DW_CLIENT || '.PRE_IMPLEMENTATION';
set DB_DW_CLIENT_SCHEMA_POST_IMPLEMENTATION = $DB_DW_CLIENT || '.POST_IMPLEMENTATION';
set DB_DW_CLIENT_SCHEMA_REPORTING = $DB_DW_CLIENT || '.REPORTING';
set DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX = $DW_CLIENT_DB || '.REPORTING_SANDBOX';
--
--### Role Variables
--
set READONLY_CLIENT_ROLE = 'READONLY_' || $CLIENT || '_ROLE';
set DATA_SCIENCE_CLIENT_ROLE = 'DATA_SCIENCE_' || $CLIENT || '_ROLE';
set REPORTING_CLIENT_ROLE = 'REPORTING_' || $CLIENT || '_ROLE';
set SISENSE_CLIENT_ROLE = 'SISENSE_' || $CLIENT || '_ROLE';
--
--### Others
--
set SISENSE_SERVICE_USER = 'SISENSE_' || $CLIENT || '_SERVICE'
------------------------------------------------------
------------------------------------------------------
--# Database and Schemas
------------------------------------------------------
--------------------------
--## Create Database and Schemas
--------------------------
use role sysadmin;
create database if not exists identifier($DB_DW_CLIENT);
create schema identifier($DB_RAW_CLIENT_SCHEMA_APPLICATION);
create schema identifier($DB_RAW_CLIENT_SCHEMA_PRE_IMPLEMENTATION);
create schema identifier($DB_RAW_CLIENT_SCHEMA_POST_IMPLEMENTATION);
create database if not exists identifier($DB_RAW_CLIENT);
create schema identifier($DB_DW_CLIENT_SCHEMA_APPLICATION);
create schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE);
create schema identifier($DB_DW_CLIENT_SCHEMA_PRE_IMPLEMENTATION);
create schema identifier($DB_DW_CLIENT_SCHEMA_POST_IMPLEMENTATION);
create schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING);
create schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX);

------------------------------------------------------
--# Roles
------------------------------------------------------
--------------------------
--## Create Client Specific Roles and Transfer Grants to SYSADMIN
--------------------------
use role securityadmin;
create role if not exists identifier($READONLY_CLIENT_ROLE);
grant role identifier($READONLY_CLIENT_ROLE) to role SYSADMIN;
create role if not exists identifier($DATA_SCIENCE_CLIENT_ROLE);
grant role identifier($DATA_SCIENCE_CLIENT_ROLE) to role SYSADMIN;
create role if not exists identifier($REPORTING_CLIENT_ROLE);
grant role identifier($REPORTING_CLIENT_ROLE) to role SYSADMIN;
create role if not exists identifier($SISENSE_CLIENT_ROLE);
grant role identifier($SISENSE_CLIENT_ROLE) to role SYSADMIN;
--------------------------
--## Grant Client Specific Readonly Access to READONLY_<client>_ROLE
--------------------------
use role securityadmin;
grant USAGE on database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant USAGE on all schemas in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on all tables in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on all views in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant USAGE on future schemas in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on future tables in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on future views in database identifier($DB_RAW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant USAGE on database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant USAGE on all schemas in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on all tables in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on all views in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant USAGEin future schemas in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on future tables in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
grant SELECT on future views in database identifier($DB_DW_CLIENT)
to role identifier($READONLY_CLIENT_ROLE);
--------------------------
--## Integrate READONLY_<client>_ROLE with Roles that Inherit
--------------------------
use role securityadmin;
grant role identifier($READONLY_CLIENT_ROLE) to role DATA_SCIENCE_CLIENT_ROLE;
grant role identifier($READONLY_CLIENT_ROLE) to role REPORTING_CLIENT_ROLE;
grant role identifier($READONLY_CLIENT_ROLE) to role SISENSE_CLIENT_ROLE;
--------------------------
--## Grant Additional Access to Roles that inherit from READONLY_<client>_ROLE
--------------------------
--
--### Grant Additional Access to DATA_SCIENCE_<client>_ROLE
--
use role securityadmin;
-- Write access to DW_<client>.DATA_SCIENCE schema
grant all privileges on schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE) to role identifier($DATA_SCIENCE_CLIENT_ROLE);
grant all privileges on all tables in schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE) to role identifier($DATA_SCIENCE_CLIENT_ROLE);
grant all privileges on all views in schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE) to role identifier($DATA_SCIENCE_CLIENT_ROLE);
grant all privileges on future tables in schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE) to role identifier($DATA_SCIENCE_CLIENT_ROLE);
grant all privileges on future views in schema identifier($DB_DW_CLIENT_SCHEMA_DATA_SCIENCE) to role identifier($DATA_SCIENCE_CLIENT_ROLE);
--
--### Grant Additional Access to REPORTING_<client>_ROLE
--
use role securityadmin;
-- Full access to DW_<client>.REPORTING schema
grant all privileges on schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on all tables in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on all views in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on future tables in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on future views in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING) to role identifier($REPORTING_CLIENT_ROLE);
-- Full access to DW_<client>.REPORTING_SANDBOX schema
use role securityadmin;
grant all privileges on schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on all tables in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on all views in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on future tables in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX) to role identifier($REPORTING_CLIENT_ROLE);
grant all privileges on future views in schema identifier($DB_DW_CLIENT_SCHEMA_REPORTING_SANDBOX) to role identifier($REPORTING_CLIENT_ROLE);
--
--### Create Service Account for SISENSE_<client>_ROLE
use role securityadmin;
create user if not exists identifier($SISENSE_SERVICE_USER)
password = $SISENSE_SERVICE_PWD
login_name = $SISENSE_SERVICE_USER
default_role = $SISENSE_CLIENT_ROLE
MUST_CHANGE_PASSWORD = False
default_warehouse = $DEFAULT_SISENSE_WAREHOUSE;
--------------------------
--## Grant Access to FIVETRAN_ROLE
--------------------------
use role securityadmin;
GRANT ALL PRIVILEGES ON DATABASE identifier($DB_RAW_CLIENT)
  TO ROLE FIVETRAN_ROLE;
GRANT OWNERSHIP on SCHEMA identifier($DB_RAW_CLIENT_SCHEMA_PRE_IMPLEMENTATION) 
  TO FIVETRAN_ROLE REVOKE CURRENT GRANTS;
GRANT OWNERSHIP on ALL TABLES IN SCHEMA identifier($DB_RAW_CLIENT_SCHEMA_PRE_IMPLEMENTATION) 
  TO FIVETRAN_ROLE REVOKE CURRENT GRANTS;


--------------------------
--## Grant Access to MATILLION_ROLE
--------------------------
use role securityadmin;
grant usage on database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
grant usage on all schemas in database identifier($DB_DW_CLIENT) to role  identifier($MATTILION_ROLE);
grant usage on future schemas in database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
grant all privileges on all tables in database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
grant all privileges on all views in database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
grant all privileges on future tables in database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
grant all privileges on future views in database identifier($DB_DW_CLIENT) to role identifier($MATTILION_ROLE);
--------------------------
--## Grant Access to MATILLION_DEV_ROLE
--------------------------
-- TODO, need the proper requirements (same as MATILLION_ROLE but can't write to DW_<client>?).  Could have MATILLION_DEV_ROLE transfer grants to MATILLION_ROLE


-----------------------------------------------------------
--# Warehouse Access
-----------------------------------------------------------
use role securityadmin;
grant USAGE on warehouse identifier($DEFAULT_DATA_SCIENCE_WAREHOUSE)
to role identifier($DATA_SCIENCE_CLIENT_ROLE);
grant USAGE on warehouse identifier($DEFAULT_SISENSE_WAREHOUSE)
to role identifier($SISENSE_CLIENT_ROLE);
grant USAGE on warehouse identifier($DEFAULT_REPORTING_WAREHOUSE)
to role identifier($REPORTING_CLIENT_ROLE);


-----------------------------------------------------------
--## Setup KAFKA prod/dev roles for raw database
-----------------------------------------------------------
--TODO Confirm is this always run?
use role securityadmin;
-- Grant all privileges on RAW_<client> to KAFKA_CONNECT_ROLE and KAFKA_CONNECT_DEV_ROLE
grant usage on database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant usage on all schemas in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant usage on future schemas in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant all privileges on all tables in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant all privileges on all views in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant all privileges on future tables in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant all privileges on future views in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant usage on database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_ROLE);
grant usage on all schemas in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);
grant usage on future schemas in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);
grant all privileges on all tables in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);
grant all privileges on all views in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);
grant all privileges on future tables in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);
grant all privileges on future views in database identifier($DB_RAW_CLIENT) to role identifier($KAFKA_CONNECT_DEV_ROLE);

--------------------------
--## Assign public key to kafka user
--------------------------
-- TODO Confirm is this always run.  Also do we generate and store rsa_public_key?
use role identifier($KAFKA_CONNECT_DEV_ROLE);
alter user identifier($user_name);'
set rsa_public_key='<insert key from 1Password>';
use role identifier($KAFKA_CONNECT_DEV_ROLE);
alter user identifier($user_name);'
set rsa_public_key='<insert key from 1Password>';


-----------------------------------------------------------
--# Done once per account
-----------------------------------------------------------
--------------------------
--## Grant CREATE INTEGRATION to FIVETRAN_ROLE
--------------------------
-- use role accountadmin;
-- grant CREATE INTEGRATION on account to role FIVETRAN_ROLE;

commit;