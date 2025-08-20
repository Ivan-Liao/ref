import duckdb
import pandas as pd

df = pd.DataFrame({"value": [10,20,30,40,50]})
result = duckdb.query("select avg(value) as avg_value from df").to_df()
print(result)
