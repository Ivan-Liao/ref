"""
Docstring for projects.cleveland-clinic_sql-test.adhoc

Run adhoc SQL queries in database
"""

import duckdb


def main() -> None:
    # Path to the persistent DuckDB database file
    db_path = "./cleveland_clinic_db.duckdb"

    with duckdb.connect(database=db_path, read_only=False) as conn:
        conn.execute("""
INSERT INTO EMS VALUES 
    (27, 'Ride Share', 1),
    (28, 'Lincoln FD', 1),
    (29, 'Out of Network Ambulance', 1),
    (30, 'Ride Share', 0);
                    """)

if __name__ == "__main__":
    main()