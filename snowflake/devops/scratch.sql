use role accountadmin;
use database DATAENG_TEST;
use schema TEST;

set USER_NAME = 'ihl_test'
set LOGIN_NAME = 'ihl_test@xselltechnologies.com'
set USER_PASSWORD = '';
set WAREHOUSE_NAME = 'dateng_wh'
set DEFAULT_ROLE = 'SANDBOX_ROLE'
set ROLES = ['READALL_ROLE', 'SANDBOX_ROLE', 'DEV_ROLE', 'LEAD_DEV'];

-- Review all parameters by searching for the prefix YOUR_
CREATE OR REPLACE PROCEDURE sp_create_user(USER_NAME string, LOGIN_NAME string, USER_PASSWORD string, WAREHOUSE_NAME string, DEFAULT_ROLE string, ROLES array)
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
    //# Create user
    try {
      snowflake.execute(
        {
          sqlText: `create user if not exists ${USER_NAME}
                    password = '${USER_PASSWORD}'
                    login_name = '${LOGIN_NAME}'
                    default_role = '${DEFAULT_ROLE}'
                    MUST_CHANGE_PASSWORD = False
                    default_warehouse = '${WAREHOUSE_NAME}';`
          ,binds:[USER_NAME,USER_PASSWORD,LOGIN_NAME,DEFAULT_ROLE,WAREHOUSE_NAME]
        }
      )
    }
    catch(err){
      return "Failed 1: " + err;
    };
    //# Assign roles to user in loop
    for (var rol of roles) {
        try {
            snowflake.execute(
                {
                 sqlText: `grant role identifier(:1) to user identifier(:2);`
                   ,binds: [rol, user_name]
                }
            );
        
        catch(err){
            return "Failed 2: " + err;
        };
    };
    
    return "Succeded.";
$$;

-- part 1
        {
          sqlText: `create user if not exists ${USER_NAME}
                    password = ${USER_PASSWORD}
                    login_name = ${LOGIN_NAME}
                    default_role = ${DEFAULT_ROLE}
                    MUST_CHANGE_PASSWORD = False
                    default_warehouse = ${WAREHOUSE_NAME};`
          ,binds:[USER_NAME,USER_PASSWORD,LOGIN_NAME,DEFAULT_ROLE,WAREHOUSE_NAME]
        }

-- part 1 v2
CREATE OR REPLACE PROCEDURE sp_create_user(USER_NAME string, LOGIN_NAME string, USER_PASSWORD string, WAREHOUSE_NAME string, DEFAULT_ROLE string, ROLES array)
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
    //# Create user
    try {
      snowflake.execute(
        {
          sqlText: `create user if not exists ${USER_NAME} password = ${USER_PASSWORD} login_name = ${LOGIN_NAME} default_role = ${DEFAULT_ROLE} MUST_CHANGE_PASSWORD = False default_warehouse = ${WAREHOUSE_NAME};`
        }
      )
    }
    catch(err){
      return "Failed 1: " + err;
    };
    return "Succeded.";
$$;

call sp_create_user(USER_NAME, LOGIN_NAME, USER_PASSWORD, WAREHOUSE_NAME, DEFAULT_ROLE, ARRAY_CONSTRUCT('READALL_ROLE', 'SANDBOX_ROLE', 'DEV_ROLE', 'LEAD_DEV'));