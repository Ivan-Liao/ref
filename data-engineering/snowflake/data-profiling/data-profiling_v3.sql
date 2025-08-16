-- information schema
-- min and max
CREATE OR REPLACE PROCEDURE ANALYTICS.PROCEDURES.profile_table(DATABASE_NAME varchar, SOURCE_TABLE_NAME varchar)
RETURNS STRING
LANGUAGE javascript
AS
$$
var columns_full_path = DATABASE_NAME + ".information_schema.columns";
var info_schema_query = `SELECT table_schema, table_name, column_name, data_type, :3 as database_name
                            FROM identifier(:1)
                            WHERE TABLE_NAME = :2
                        `;
var info_schema_statement = snowflake.createStatement({ 
    sqlText: info_schema_query,
    binds: [columns_full_path, SOURCE_TABLE_NAME, DATABASE_NAME]});
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
                                data_type varchar,
                                min_value varchar,
                                max_value varchar
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
    var database_name = result_set.getColumnValue(5);
    var table_full_path = database_name + "." + table_schema + "." + table_name;

    var insert_profile_query = `
                            INSERT INTO ANALYTICS.DBT_SCHEMA.TEMP_PROFILE (
                                table_schema,
                                table_name,
                                column_name,
                                data_type,
                                min_value,
                                max_value
                            ) SELECT :2,
                                    :3,
                                    :4,
                                    :5,
                                    CASE WHEN :5 IN ('NUMBER','TEXT','DATE') THEN MIN(identifier(:4)) ELSE null END as MIN_VALUE,
                                    CASE WHEN :5 IN ('NUMBER','TEXT','DATE') THEN MAX(identifier(:4)) ELSE null END as MAX_VALUE
                                FROM identifier(:1)
                                WHERE 1 = 1
                            `;
    var insert_profile_statement = snowflake.createStatement({ 
        sqlText: insert_profile_query,
        binds: [table_full_path, table_schema,table_name,column_name,data_type]});
    insert_profile_statement.execute();
    
}
$$;

call ANALYTICS.PROCEDURES.profile_table('ANALYTICS','CUSTOMERS')
;
SELECT *
FROM analytics.dbt_schema.temp_profile
LIMIT 20
;