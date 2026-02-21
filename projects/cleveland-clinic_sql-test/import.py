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
        data = conn.execute("SELECT * FROM Encounter").fetchdf()
        print("Preview of the Encounter table:")
        print(data)


if __name__ == "__main__":
    main()