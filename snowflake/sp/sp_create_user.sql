CREATE OR REPLACE PROCEDURE sp_create_user(USER_NAME string, LOGIN_NAME string, USER_PASSWORD string, WAREHOUSE_NAME string, DEFAULT_ROLE string)
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
    //# Create user
    try {
      snowflake.execute(
        {
          sqlText: `create user if not exists ${USER_NAME}
                    password = ${USER_PASSWORD}
                    login_name = ${LOGIN_NAME}
                    default_role = ${DEFAULT_ROLE}
                    MUST_CHANGE_PASSWORD = False
                    default_warehouse = ${WAREHOUSE_NAME};`
          ,binds:[USER_NAME,USER_PASSWORD,LOGIN_NAME,DEFAULT_ROLE,WAREHOUSE_NAME]
        }
      )
    }
    catch(err){
      return "Failed 1: " + err;
    };
    return "Succeded.";
$$;

/* useful snippets
grant all on procedure DATAENG_TEST.TEST.sp_create_user(string,string,string,string,string) to role securityadmin;

use role securityadmin;
set USER_NAME = 'ihl_test';
set LOGIN_NAME = 'ihl_test@xselltechnologies.com';
set USER_PASSWORD = '';
set DEFAULT_WAREHOUSE = 'dateng_wh';
set DEFAULT_ROLE = 'SANDBOX_ROLE';
call sp_create_user($USER_NAME, $LOGIN_NAME, $USER_PASSWORD, $DEFAULT_WAREHOUSE, $DEFAULT_ROLE);
call sp_grant_roles_to_user($USER_NAME, ARRAY_CONSTRUCT('READALL_ROLE', 'SANDBOX_ROLE', 'DEV_ROLE', 'LEAD_DEV'))
*/