import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

sns.set_theme(color_codes=True)

df = pd.read_csv("data.csv")
df.head(5)
df.tail(5)
df.dtypes
df = df.drop(['Engine Fuel Type', 'Market Category', 'Vehicle Style', 'Popularity', 'Number of Doors', 'Vehicle Size'], axis=1)
df = df.rename(columns={"Engine HP": "HP", "Engine Cylinders": "Cylinders", "Transmission Type": "Transmission",})


duplicate_rows_df = df[df.duplicated()]
df.count()
df = df.drop_duplicates()
df.count()

print(df.isnull().sum())
df = df.dropna()

df = pd.read_csv("sales.csv")

df["order_date"] = pd.to_datetime(df["order_date"])

df["year_month"] = df["order_date"].dt.to_period("M")

monthly_revenue = (
    df.groupby(["year_month"],["product_id"])
      .agg(total_revenue=("revenue","sum"))
      .reset_index()
)

top_products = (
    monthly_revenue.sort_values("total_revenue", ascending=False)
                   .groupby("year_month")
                   .head(1)
)

df = customers.merge(transactions, on="customer_id", how="left")

df["purchase_amount"] = df["purchase_amount"].fillna(0)

customer_metrics = (
    df.groupby("customer_id")
      .agg(
          total_spent=("purchase_amount","sum"),
          num_orders=("order_id", "nunique")
      )
)

customer_metrics["spend_segment"] = pd.cut(
    customer_metrics["total_spent"],
    bins=[-1,0,500,2000, float("inf")],
    labels = ["No Spend", "Low", "Medium", "High"]
)

segment_counts = customer_metrics["spend_segment"].value_counts()

