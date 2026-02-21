import duckdb
# Connect to a database (or in-memory) and create a dummy table
db_path = "./cleveland_clinic_db.duckdb"
table_name = 'Provider_LOS'

with duckdb.connect(database=db_path, read_only=False) as con:
    # Query the column names and types from the metadata function
    columns_info = con.execute("""
        SELECT column_name, data_type
        FROM duckdb_columns()
        WHERE table_name = ($1)
        ORDER BY column_index;
    """,[table_name]).fetchall()
    print(columns_info)

    # Construct the 'CREATE TABLE' part
    columns_definition = ', \n'.join([f"    {col[0]} {col[1]}" for col in columns_info])
    create_statement = f"CREATE TABLE {table_name} (\n{columns_definition}\n);"

    # Alternatively, construct a CTAS statement for an empty copy (schema only)
    ctas_schema_only = f"CREATE TABLE {table_name}_schema_only AS FROM {table_name} WHERE 1=0;"

    # Or a CTAS statement to copy all data
    ctas_full_copy = f"CREATE TABLE {table_name}_full_copy AS SELECT * FROM {table_name};"

    print(f"CTAS: {create_statement}")
    print(f"Schema only CTAS: {ctas_schema_only}")
    print(f"Full copy CTAS: {ctas_full_copy}")

    # Execute the full copy CTAS
    # con.execute(ctas_full_copy)
    # con.execute("SELECT * FROM new_table_full_copy").fetch_df()