--# Create a user and assign roles
use role securityadmin;
set USER_NAME = 'YOUR_USER_NAME' -- e.g. 'ihl_test';
set LOGIN_NAME = 'YOUR_LOGIN_NAME' -- e.g. 'ihl_test@xselltechnologies.com';
set USER_PASSWORD = 'YOUR_USER_PASSWORD' -- '' for non service accounts. Remember to save in 1pass if creating a password for service accounts.;
set DEFAULT_WAREHOUSE = 'YOUR_DEFAULT_WAREHOUSE' -- e.g. 'DATAENG_2_WH';
set DEFAULT_ROLE = 'YOUR_SANDBOX_ROLE' -- e.g. 'SANDBOX_ROLE';
call sp_create_user($USER_NAME, $LOGIN_NAME, $USER_PASSWORD, $DEFAULT_WAREHOUSE, $DEFAULT_ROLE);
call sp_grant_roles_to_user($USER_NAME, ARRAY_CONSTRUCT('YOUR_COMMA_SEPERATED_ROLES')) e.g. -- ARRAY_CONSTRUCT('READALL_ROLE', 'SANDBOX_ROLE', 'DEV_ROLE', 'LEAD_DEV');


--# explore grants
select * 
from "SNOWFLAKE"."ACCOUNT_USAGE"."GRANTS_TO_ROLES" 
where grantee_name = 'FIVETRAN_ROLE'
    and TABLE_CATALOG = 'RAW_BENEFYTT';


-- solution for Fivetran access
set role_name = 'FIVETRAN_ROLE';
set database_name = 'RAW_ELEVANCE';


GRANT ALL PRIVILEGES
ON DATABASE identifier($database_name)
TO ROLE identifier($role_name);

--set schema_name = "POST_IMPLEMENTATION";
GRANT OWNERSHIP on SCHEMA "RAW_ELEVANCE"."POST_IMPLEMENTATION" to FIVETRAN_ROLE REVOKE CURRENT GRANTS;`
GRANT OWNERSHIP on ALL TABLES IN SCHEMA "RAW_ELEVANCE"."POST_IMPLEMENTATION" to FIVETRAN_ROLE REVOKE CURRENT GRANTS;
GRANT ALL on ALL TABLES IN RAW_ELEVANCE.POST_IMPLEMENTATION to FIVETRAN_