import duckdb


def main() -> None:
    # Path to the persistent DuckDB database file
    db_path = "./cleveland_clinic_db.duckdb"

    with duckdb.connect(database=db_path, read_only=False) as conn:
        # Read data from excel file into tables
        ## one time read 
        table_list = conn.execute("SHOW TABLES").fetchdf()
        print(table_list)
        if 'Encounter' not in table_list.values:

            # # Insert a new record into the employees table
            # conn.execute("INSERT INTO employees VALUES ('Alice', 'Manager', 5000)")

            # Preview data from the employees table
            conn.execute("""
                            CREATE TABLE Encounter AS
                            SELECT * FROM read_xlsx('SQL Test DB Dev.xlsx', sheet = 'Encounter');
                        """)
        if 'EMS' not in table_list.values:

            # # Insert a new record into the employees table
            # conn.execute("INSERT INTO employees VALUES ('Alice', 'Manager', 5000)")

            # Preview data from the employees table
            conn.execute("""
                            CREATE TABLE EMS AS
                            SELECT * FROM read_xlsx('SQL Test DB Dev.xlsx', sheet = 'EMS', ignore_errors=true);
                        """)
        if 'Provider_LOS' not in table_list.values:

            # # Insert a new record into the employees table
            # conn.execute("INSERT INTO employees VALUES ('Alice', 'Manager', 5000)")

            # Preview data from the employees table
            conn.execute("""
                            CREATE TABLE Provider_LOS AS
                            SELECT * FROM read_xlsx('SQL Test DB Dev.xlsx', sheet = 'Provider_LOS');
                        """)
        data = conn.execute("SELECT * FROM Encounter").fetchdf()
        print("Preview of the Encounter table:")
        print(data)
        data = conn.execute("SELECT * FROM EMS").fetchdf()
        print("Preview of the EMS table:")
        print(data)
        data = conn.execute("SELECT * FROM Provider_LOS").fetchdf()
        print("Preview of the Provider_LOS table:")
        print(data)


if __name__ == "__main__":
    main()