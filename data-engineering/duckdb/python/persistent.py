import duckdb


def main() -> None:
    # Path to the persistent DuckDB database file
    db_path = "./employees_db.duckdb"

    with duckdb.connect(database=db_path, read_only=False) as conn:
        # Read data from CSV file into a relation
        ## one time read 
        table_list = conn.execute("SHOW TABLES").fetchdf()
        if 'employees' not in table_list:
            employees_csv = conn.read_csv("./data/employees.csv")
    

        # # Insert a new record into the employees table
        # conn.execute("INSERT INTO employees VALUES ('Alice', 'Manager', 5000)")

        # Preview data from the employees table
        conn.execute("""
                            create table if not exists employees as (
                            SELECT * FROM employees_csv)
                            """)
        data = conn.execute("SELECT * FROM employees").fetchdf()
        print("Preview of the employees table:")
        print(data)


if __name__ == "__main__":
    main()