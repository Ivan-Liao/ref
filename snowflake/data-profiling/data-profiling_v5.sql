-- information schema
-- min and max
-- avg, number of nulls, and pct nulls
-- categorical values
CREATE OR REPLACE PROCEDURE ANALYTICS.PROCEDURES.profile_table(DATABASE_NAME varchar, SOURCE_TABLE_NAME varchar)
RETURNS VARCHAR
LANGUAGE javascript
AS
$$

// constants for conditionals
const NUMERIC_TYPES = ['NUMBER', 'DECIMAL', 'NUMERIC', 'INT', 'INTEGER', 'BIGINT', 'SMALLINT', 'FLOAT', 'DOUBLE', 'REAL'];
const ORDERABLE_TYPES = ['DATE', 'DATETIME', 'TIMESTAMP', 'TIMESTAMP_LTZ', 'TIMESTAMP_NTZ', 'TIMESTAMP_TZ', 'TIME', 'TEXT', 'VARCHAR', 'CHAR', 'STRING'];

// information schema query
var columns_full_path = DATABASE_NAME + ".information_schema.columns";
var info_schema_query = `SELECT table_schema, table_name, column_name, data_type, :3 as database_name
                            FROM identifier(:1)
                            WHERE TABLE_NAME = :2
                        `;
var info_schema_statement = snowflake.createStatement({ 
    sqlText: info_schema_query,
    binds: [columns_full_path, SOURCE_TABLE_NAME, DATABASE_NAME]});
var result_set = info_schema_statement.execute();

// drop temp table
var drop_profile_query = `
                            DROP TABLE if exists ANALYTICS.DBT_SCHEMA.TEMP_PROFILE
                            `;
var drop_profile_statement = snowflake.createStatement({ 
    sqlText: drop_profile_query});
drop_profile_statement.execute();

// create temp table
var create_profile_query = `
                            CREATE TABLE ANALYTICS.DBT_SCHEMA.TEMP_PROFILE (
                                table_schema varchar,
                                table_name varchar,
                                column_name varchar,
                                data_type varchar,
                                min_value varchar,
                                max_value varchar,
                                avg_value number,
                                null_count number,
                                null_pct number,
                                distinct_values variant
                            )
                            `;
var create_profile_statement = snowflake.createStatement({ 
    sqlText: create_profile_query});
create_profile_statement.execute();

// loop through columns and perform data profiling
var results = [];
try {
    while (result_set.next()) {
        var table_schema = result_set.getColumnValue(1);
        var table_name = result_set.getColumnValue(2);
        var column_name = result_set.getColumnValue(3);
        var data_type = result_set.getColumnValue(4);
        var database_name = result_set.getColumnValue(5);
        var table_full_path = database_name + "." + table_schema + "." + table_name;

        // Dynamic sql based on data type
        var avg_clause = `NULL as AVG_VALUE,`
        if (NUMERIC_TYPES.includes(data_type)) {
            // For numbers, we can calculate AVG.
            avg_clause = `AVG(identifier(:4)) as AVG_VALUE,`;
        }

        var insert_profile_query = `
                                INSERT INTO ANALYTICS.DBT_SCHEMA.TEMP_PROFILE (
                                    table_schema,
                                    table_name,
                                    column_name,
                                    data_type,
                                    min_value,
                                    max_value,
                                    avg_value,
                                    null_count,
                                    null_pct,
                                    distinct_values
                                ) SELECT :2,
                                        :3,
                                        :4,
                                        :5,
                                        MIN(identifier(:4)) as MIN_VALUE,
                                        MAX(identifier(:4)) as MAX_VALUE,
                                        ${avg_clause}
                                        COUNT_IF(identifier(:4) IS NULL) AS null_count,
                                        DIV0(null_count, COUNT(*)) * 100 AS null_pct,
                                        SPLIT(listagg(distinct identifier(:4),',') within group (order by identifier(:4)),',')::variant
                                    FROM identifier(:1)
                                    WHERE 1 = 1
                                `;
        var insert_profile_statement = snowflake.createStatement({ 
            sqlText: insert_profile_query,
            binds: [table_full_path, table_schema,table_name,column_name,data_type]});
        insert_profile_statement.execute();
        results.push(`Operation succeeded with avg_clause: ${avg_clause} column_name: ${column_name}, data_type: ${data_type}`);
    }
} catch (err) {
    results.push(`Operation failed with avg_clause: ${avg_clause} column_name: ${column_name}, data_type: ${data_type}, error: ${err}`);
}
return results.join("\n")
$$;

call ANALYTICS.PROCEDURES.profile_table('ANALYTICS','CUSTOMERS')
;
SELECT *
FROM analytics.dbt_schema.temp_profile
LIMIT 20
;