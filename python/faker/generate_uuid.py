import uuid
from faker import Faker
import pandas as pd
from datetime import date, datetime
import numpy as np

# generates a list of uuids to populate fake data
uuids = [uuid.uuid4() for _ in range(100)]


from faker import Faker
import pandas as pd
from datetime import date
from json import dumps

CREATE_ROW_CODE = """
{
    "id": faker.words(1, uuids, False)[0],
    "description": faker.bs(),
    "timestamp": faker.date_between(datetime(2021, 2, 15), datetime(2022, 2, 15)),
}
"""


def create_rows(num_rows=1):
    faker = Faker()
    output = []
    for _ in range(num_rows):
        row = eval(CREATE_ROW_CODE)
        output.append(row)
    return output


def main():
    raw_df = pd.DataFrame(create_rows(100000))
    # split synthetic data into chunks to create multiple files
    dfs = np.array_split(raw_df.sort_values('timestamp'), 50)
    for df in dfs:
        max_date = df['timestamp'].max().strftime('%Y-%m-%d')
        df.to_csv(f"./input/unprocessed/data_{max_date}.csv", index=False)


if __name__ == "__main__":
    main()

