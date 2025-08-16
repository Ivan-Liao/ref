use role securityadmin;
use warehouse dataeng_2_wh;


// set parameters
set USER_NAME = 'ihl_test';  -- 
set LOGIN_NAME = 'ihl_test@xselltechnologies.com';
set USER_PASSWORD = '';  -- create and save in 1pass if this is a service user
set DEFAULT_WAREHOUSE = 'dateng_2_wh';
set DEFAULT_ROLE = 'READALL_ROLE';
show variables;


create user if not exists identifier($USER_NAME)
password = $USER_PASSWORD
login_name = $LOGIN_NAME
default_role = $DEFAULT_ROLE
MUST_CHANGE_PASSWORD = False
default_warehouse = $DEFAULT_WAREHOUSE;


call dataeng_test.test.sp_grant_roles_to_user($USER_NAME, ARRAY_CONSTRUCT('READALL_ROLE', 'REPORTING_ATT_ROLE', 'DEV_ROLE', 'LEAD_DEV'));


//create user if not exists identifier($USER_NAME)
//password = $USER_PASSWORD
//login_name = $LOGIN_NAME
//default_role = $DEFAULT_ROLE
//MUST_CHANGE_PASSWORD = False
//default_warehouse = $DEFAULT_WAREHOUSE;
//
show grants to user ihl_test;
//drop user ihl_test;