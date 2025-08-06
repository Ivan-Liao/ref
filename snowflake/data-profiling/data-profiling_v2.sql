-- information schema
-- profiles min and max value
CREATE OR REPLACE PROCEDURE ANALYTICS.PROCEDURES.profile_table(DATABASE_NAME varchar, SOURCE_TABLE_NAME varchar)
RETURNS STRING
LANGUAGE javascript
AS
$$
var info_schema_query = `SELECT table_schema, table_name, column_name, data_type
                            FROM ANALYTICS.INFORMATION_SCHEMA.COLUMNS
                            WHERE TABLE_NAME = ?
                        `;
var info_schema_statement = snowflake.createStatement({ 
    sqlText: info_schema_query,
    binds: [SOURCE_TABLE_NAME]});
var result_set = info_schema_statement.execute();

var drop_profile_query = `
                            DROP TABLE if exists ANALYTICS.DBT_SCHEMA.TEMP_PROFILE
                            `;
var drop_profile_statement = snowflake.createStatement({ 
    sqlText: drop_profile_query});
drop_profile_statement.execute();

var create_profile_query = `
                            CREATE TABLE ANALYTICS.DBT_SCHEMA.TEMP_PROFILE (
                                table_schema varchar,
                                table_name varchar,
                                column_name varchar,
                                data_type varchar
                            )
                            `;
var create_profile_statement = snowflake.createStatement({ 
    sqlText: create_profile_query});
create_profile_statement.execute();
    
while (result_set.next()) {
    var table_schema = result_set.getColumnValue(1);
    var table_name = result_set.getColumnValue(2);
    var column_name = result_set.getColumnValue(3);
    var data_type = result_set.getColumnValue(4);

    var insert_profile_query = `
                            INSERT INTO ANALYTICS.DBT_SCHEMA.TEMP_PROFILE (
                                table_schema,
                                table_name,
                                column_name,
                                data_type
                            ) VALUES (:1,
                                :2,
                                :3,
                                :4)
                            `;
    var insert_profile_statement = snowflake.createStatement({ 
        sqlText: insert_profile_query,
        binds: [table_schema,table_name,column_name,data_type]});
    insert_profile_statement.execute();
    
}
$$;

call ANALYTICS.PROCEDURES.profile_table('ANALYTICS','CUSTOMERS')
;
SELECT *
FROM analytics.dbt_schema.temp_profile
LIMIT 20
;
drop table analytics.dbt_schema.temp_profile;