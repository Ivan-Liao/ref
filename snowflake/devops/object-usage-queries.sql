-- roles used in the past 10 days
select distinct ROLE_NAME
from snowflake.account_usage.query_history
where USER_NAME != 'fivetran'
    and START_TIME > CURRENT_DATE() - interval '10 day';


-- databases NOT in use in the past month
SELECT DATABASE_NAME from snowflake.information_schema.databases
EXCEPT
(
  select distinct DATABASE_NAME
  from snowflake.account_usage.query_history
  where START_TIME > CURRENT_DATE() - interval '30 day'
)
;


-- schemas NOT in use in the past month
SELECT SCHEMA_NAME from snowflake.information_schema.databases
EXCEPT
(
  select distinct SCHEMA_NAME
  from snowflake.account_usage.query_history
  where START_TIME > CURRENT_DATE() - interval '30 day'
)
;


-- see if a specific table is in use
select * 
from snowflake.account_usage.query_history
where QUERY_TEXT rlike '*ENGAGE_ACTION*'
limit 1;