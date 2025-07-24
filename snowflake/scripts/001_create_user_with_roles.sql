use role securityadmin;
use warehouse dataeng_2_wh;


// set parameters
set USER_NAME = '<YOUR_USER_NAME>';  -- e.g. ihl_test
set LOGIN_NAME = '<YOUR_LOGIN_NAME>'; -- e.g. ihl_test@xselltechnologies.com
set USER_PASSWORD = '';  -- create and save in 1pass if this is a service user
set DEFAULT_WAREHOUSE = '<YOUR_DEFAULT_WAREHOUSE>'; -- e.g. dateng_2_wh
set DEFAULT_ROLE = '<YOUR_DEFAULT_ROLE>'; -- e.g. REPORTING_ATT_ROLE


create user if not exists identifier($USER_NAME)
password = $USER_PASSWORD
login_name = $LOGIN_NAME
default_role = $DEFAULT_ROLE
MUST_CHANGE_PASSWORD = False
default_warehouse = $DEFAULT_WAREHOUSE;


-- e.g. 'DATA_SCIENCE_ATT_ROLE', 'REPORTING_ATT_ROLE', 'SISENSE_ATT_ROLE'
call data_admin.public.sp_grant_roles_to_user($USER_NAME, ARRAY_CONSTRUCT(<YOUR_COMMA_SEPERATED_LIST_OF_ROLES>));
show grants to user identifier($USER_NAME);