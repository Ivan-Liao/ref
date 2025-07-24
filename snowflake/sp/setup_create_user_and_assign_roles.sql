use role sysadmin;
drop procedure if exists DATAENG_TEST.TEST.sp_grant_roles_to_user(string,array);

use database dataeng_test;
use schema test;
use warehouse dataeng_2_wh;
grant usage on database dataeng_test to role securityadmin;
grant all on database dataeng_test to role securityadmin;
grant all on schema dataeng_test.test to role securityadmin;


CREATE OR REPLACE PROCEDURE sp_grant_roles_to_user(USER_NAME string, ROLES array)
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
    //# Assign roles to user in loop
    for (var RLE of ROLES) {
        try {
            snowflake.execute(
                {
                 sqlText: `grant role identifier(:1) to user identifier(:2);`
                 ,binds: [RLE, USER_NAME]
                }
            );
        }
        catch(err){
            return "Failed: " + err;
        };
    };
    
    return "Succeded.";
$$;
alter procedure DATAENG_TEST.TEST.sp_grant_roles_to_user(string, array)
execute as CALLER;
grant usage on procedure DATAENG_TEST.TEST.sp_grant_roles_to_user(string, array) to role securityadmin;
grant all on procedure DATAENG_TEST.TEST.sp_grant_roles_to_user(string, array) to role securityadmin;
show procedures;