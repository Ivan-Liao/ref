# Script 1: Monthly Revenue Analysis (Finance / Analytics)
import pandas as pd

# Load transactional sales data
# Expected columns: order_id, product_id, revenue, order_date
df = pd.read_csv("sales.csv")

# Convert order_date from string to datetime
df["order_date"] = pd.to_datetime(df["order_date"])

# Extract year-month for aggregation
df["year_month"] = df["order_date"].dt.to_period("M") # to_period D (day), W (week), Q (Quarter), h (hourly), min, s, ms, us, ns

# Aggregate revenue by month and product
monthly_revenue = (
    df.groupby(["year_month", "product_id"])
      .agg(total_revenue=("revenue", "sum"))
      .reset_index() # clean sequential index after groupby
)

# Find top product per month
top_products = (
    monthly_revenue.sort_values("total_revenue", ascending=False)
                   .groupby("year_month")
                   .head(1)
)

print(top_products)

# Script 2: Customer Segmentation by Behavior (Marketing)
import pandas as pd

# Load customer master data
customers = pd.read_csv("customers.csv")

# Load transactional purchase data
transactions = pd.read_csv("transactions.csv")

# Merge customer info with transactions
df = customers.merge(transactions, on="customer_id", how="left")

# Replace missing purchase values with 0
df["purchase_amount"] = df["purchase_amount"].fillna(0)

# Aggregate behavior metrics per customer
customer_metrics = (
    df.groupby("customer_id")
      .agg(
          total_spent=("purchase_amount", "sum"),
          num_orders=("order_id", "nunique")
      )
)

# Create spending tiers using binning
customer_metrics["spend_segment"] = pd.cut(
    customer_metrics["total_spent"],
    bins=[-1, 0, 500, 2000, float("inf")],
    labels=["No Spend", "Low", "Medium", "High"]
)

# Count customers per segment
segment_counts = customer_metrics["spend_segment"].value_counts()

print(segment_counts)

# Script 3: Data Quality Validation Pipeline (Data Engineering)

import pandas as pd

# Load incoming dataset
df = pd.read_csv("incoming_data.csv")

# Check for missing values per column
missing_summary = df.isna().sum()

# Detect duplicate rows
duplicate_count = df.duplicated().sum()

# Identify numeric columns
numeric_columns = df.select_dtypes(include=["number"]).columns

# Convert numeric columns to float for consistency
df[numeric_columns] = df[numeric_columns].astype(float)

print("Missing values per column:")
print(missing_summary)

print("\nDuplicate rows:", duplicate_count)


# Script 4: Time-Series Demand Forecast Preparation (Operations)
import pandas as pd

# Load historical demand data
# Expected columns: date, units_sold
df = pd.read_csv("daily_demand.csv")

# Convert date to datetime
df["date"] = pd.to_datetime(df["date"])

# Set date as index for time-series operations
df = df.set_index("date")

# Resample to weekly demand
weekly_demand = df.resample("W").sum()

# Create rolling averages for trend analysis
weekly_demand["rolling_4_week_avg"] = (
    weekly_demand["units_sold"].rolling(window=4).mean()
)

# Create lag feature (previous week's demand)
weekly_demand["prev_week_demand"] = weekly_demand["units_sold"].shift(1)

# Drop rows with missing values introduced by rolling and shifting
weekly_demand = weekly_demand.dropna()

print(weekly_demand.head())

# Script 5: Operational KPI Dashboard Metrics (Product / Ops)
import pandas as pd

# Load application log data
# Expected columns: timestamp, user_id, endpoint
df = pd.read_json("api_logs.json")

# Convert timestamp to datetime
df["timestamp"] = pd.to_datetime(df["timestamp"])

# Calculate endpoint usage distribution
endpoint_usage = (
    df["endpoint"]
    .value_counts(normalize=True)
    .rename("usage_ratio")
    .round(3)
)

# Create hourly usage pivot table
df["hour"] = df["timestamp"].dt.hour

hourly_usage = pd.pivot_table(
    df,
    index="hour",
    columns="endpoint",
    values="user_id",
    aggfunc="count",
    fill_value=0
)

print("Endpoint Usage Ratio:")
print(endpoint_usage)

print("\nHourly Usage Pivot Table:")
print(hourly_usage.head())
