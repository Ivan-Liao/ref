import duckdb
from faker import Faker
from datetime import date
min_arrival_date = date(2020, 5, 17)
max_arrival_date = date(2020, 5, 17)
min_departure_date = date(2020, 5, 17)
max_departure_date = date(2020, 5, 17)
# Attending_Name list of names from faker
# Treatment_Team_Name list of names from faker
age_range_min = 0
age_range_max = 99


def main() -> None:
    # Path to the persistent DuckDB database file
    db_path = "./cleveland_clinic_db.duckdb"

    with duckdb.connect(database=db_path, read_only=False) as conn:
        data_ranges = conn.execute("""
            SELECT MAX(PAT_ENC_CSN_ID) as max_encounter_id,
                MIN(PAT_ENC_CSN_ID) as min_encounter_id,
                MAX(Means_Of_Arrival_CD),
                MIN(Means_Of_Arrival_CD).
            FROM
            WHERE  1 = 1
            AND
            LIMIT 20
            ;
        """).fetchdf()

        print(data_ranges)
        data_arrival_categories = conn.execute("""
            SELECT DISTINCT Means_Of_Arrival_CD
            FROM Encounter
            ;
        """).fetchdf()

        print(data_arrival_categories)
if __name__ == "__main__":
    main()