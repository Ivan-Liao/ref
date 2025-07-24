use role sysadmin;
drop procedure if exists data_admin.public.sp_grant_roles_to_user(string,array);
use database data_admin;
use schema public;
use warehouse dataeng_2_wh;
grant usage on database data_admin to role securityadmin;
grant all on database data_admin to role securityadmin;
grant all on schema data_admin.public to role securityadmin;


--# Stored procedure to assign a variable array of roles to a user.
CREATE OR REPLACE PROCEDURE sp_grant_roles_to_user(USER_NAME string, ROLES array)
RETURNS string
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
    //## Assign roles to user in loop
    for (var RLE of ROLES) {
        try {
            snowflake.execute(
                {
                 sqlText: `grant role ${RLE} to user ${USER_NAME};`
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


grant usage on procedure sp_grant_roles_to_user(string, array) to role securityadmin;