-- set parameters
set warehouse_name = 'WAREHOUSE_HERE' -- e.g. 'dataeng_wh';
set role_name = 'ROLE_HERE'; -- e.g. 'data_engineering_role';


-- create role and integrate with sysadmin -- @ihl seems dangerous
create role if not exists identifier($role_name);
grant role identifier($role_name) to role SYSADMIN;


-- Create a warehouse
-------------------------------------------------------------------
use role sysadmin;
create warehouse if not exists identifier($warehouse_name)
warehouse_size = xsmall
warehouse_type = standard
auto_suspend = 60
auto_resume = true
initially_suspended = true;

-- grant the role access to warehouse
use role securityadmin;
grant USAGE
    on warehouse identifier($warehouse_name)
        to role identifier($role_name);