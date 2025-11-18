"""
source: tom bailey Udemy course
"""

import os
from snowflake.snowpark import Session
from snowflake.snowpark.functions import col

connection_parameters = {
"account": os.environ["snowflake_account"],
"user": os.environ["snowflake_user"],
"password": os.environ["snowflake_password"],
"role": os.environ["snowflake_user_role"],
"warehouse": os.environ["snowflake_warehouse"],
"database": os.environ["snowflake_database"],
"schema": os.environ["snowflake_schema"]
}

session = Session.builder.configs(connection_parameters).create()
transactions_df = session.table("transactions")
print(transactions_df.collect())

transactions_df_filtered = transactions_df.filter(col("amount") >= 1000.00)
transaction_counts_df = transactions_df_filtered.group_by("account_id").count()
flagged_transactions_df = transaction_counts_df.filter(col("count") >= 2).rename(col("count"), "flagged_count")
flagged_transactions_df.write.save_as_table("flagged_transactions", mode="append")
print(flagged_transactions_df.show())
session.close()
