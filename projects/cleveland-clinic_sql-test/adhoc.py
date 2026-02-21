"""
Docstring for projects.cleveland-clinic_sql-test.adhoc

Run adhoc SQL queries in database
"""

import duckdb


def main() -> None:
    # Path to the persistent DuckDB database file
    db_path = "./cleveland_clinic_db.duckdb"

    with duckdb.connect(database=db_path, read_only=False) as conn:
        data = conn.execute("""

-- 6 Returns the top 5 duos of attending and treatment team members with the most encounter records.
SELECT Attending_Name, 
    Treatment_Team_Name, 
    count(PAT_ENC_CSN_ID) as total_encounters
FROM Encounter
GROUP BY Attending_Name, Treatment_Team_Name
ORDER BY count(PAT_ENC_CSN_ID) desc
LIMIT 5
;



            """).fetchdf()

        print(data)

if __name__ == "__main__":
    main()