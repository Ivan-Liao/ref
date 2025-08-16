-- set parameters
set database_name = 'raw_elevance_staging';
set schema_name = 'post_implementation';


-- create database and schema
use role sysadmin;
create database if not exists identifier($database_name);
use database  identifier($database_name);
create schema identifier($schema_name);

-- grant usage is read only, grant select is read only
-- grant all privileges is write and read

-- grant the role to access to database
grant USAGE
    on database identifier($database_name)
        to role identifier($role_name);


-- grant the role to access usage privilege to all schemas in database
grant USAGE
    on all schemas in database identifier($database_name)
        to role identifier($role_name);



-- grant role to select privilege to all tables in database
grant SELECT
    on all tables in database identifier($database_name)
        to role identifier($role_name);


-- change role to securityadmin for future access to database steps  -- @ihl why is this necessary?
 use role securityadmin;
-- grant role to future privileges in database
grant USAGE
on future schemas in database identifier($database_name)
to role identifier($role_name);

grant SELECT
    on future tables in database identifier($database_name)
        to role identifier($role_name);

grant SELECT
    on future views in database identifier($database_name)
        to role identifier($role_name);


--ONLY USE FOR FIVETRAN ROLE RAW DATA(Run once per account)--
   --grant fivetran access to database
   --grant CREATE SCHEMA, MONITOR, USAGE
   --on database identifier($database_name)
   --to role identifier($role_name);

   -- change role to ACCOUNTADMIN for STORAGE INTEGRATION support
   --use role accountadmin;
   --grant CREATE INTEGRATION on account to role identifier($role_name);
   --use role sysadmin;


-- individual object access
-- use role securityadmin;

-- grant SELECT
--     on view "DW_ATT"."REPORTING_SANDBOX"."V_LOGIN_MSS"
--         to role identifier(SISENSE_ATT_ROLE);