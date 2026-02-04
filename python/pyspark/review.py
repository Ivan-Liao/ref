# Script 1: Monthly Revenue Analysis (Finance / Analytics)

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, to_date, date_format, row_number
from pyspark.sql.window import Window

# Create Spark session
spark = SparkSession.builder.appName("MonthlyRevenueAnalysis").getOrCreate()

# Load sales data
sales_df = spark.read.csv("sales.csv", header=True, inferSchema=True)

# Convert order_date to a proper date type
sales_df = sales_df.withColumn("order_date", to_date(col("order_date")))

# Extract year-month string (e.g., 2025-01)
sales_df = sales_df.withColumn(
    "year_month",
    date_format(col("order_date"), "yyyy-MM")
)

# Aggregate revenue by month and product
monthly_revenue = (
    sales_df.groupBy("year_month", "product_id")
            .agg(sum("revenue").alias("total_revenue"))
)

# Window specification to rank products per month
window_spec = Window.partitionBy("year_month").orderBy(col("total_revenue").desc())

# Rank products and select the top one per month
top_products = (
    monthly_revenue.withColumn("rank", row_number().over(window_spec))
                   .filter(col("rank") == 1)
                   .drop("rank")
)

top_products.show()

# Script 2: Customer Segmentation by Behavior (Marketing)

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, countDistinct, when

spark = SparkSession.builder.appName("CustomerSegmentation").getOrCreate()

# Load datasets
customers_df = spark.read.csv("customers.csv", header=True, inferSchema=True)
transactions_df = spark.read.csv("transactions.csv", header=True, inferSchema=True)

# Left join customers with transactions
df = customers_df.join(transactions_df, on="customer_id", how="left")

# Replace null purchase amounts with 0
df = df.fillna({"purchase_amount": 0})

# Aggregate customer behavior metrics
customer_metrics = (
    df.groupBy("customer_id")
      .agg(
          sum("purchase_amount").alias("total_spent"),
          countDistinct("order_id").alias("num_orders")
      )
)

# Create spending segments using conditional logic
customer_metrics = customer_metrics.withColumn(
    "spend_segment",
    when(col("total_spent") == 0, "No Spend")
    .when(col("total_spent") <= 500, "Low")
    .when(col("total_spent") <= 2000, "Medium")
    .otherwise("High")
)

# Count customers per segment
segment_counts = customer_metrics.groupBy("spend_segment").count()

segment_counts.show()

# Script 3: Data Quality Validation Pipeline (Data Engineering)
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.appName("DataQualityChecks").getOrCreate()

# Load incoming dataset
df = spark.read.csv("incoming_data.csv", header=True, inferSchema=True)

# Count missing values per column
missing_counts = {
    column: df.filter(col(column).isNull()).count()
    for column in df.columns
}

# Count duplicate rows
duplicate_count = df.count() - df.dropDuplicates().count()

# Identify numeric columns
numeric_columns = [
    name for name, dtype in df.dtypes
    if dtype in ("int", "bigint", "double", "float")
]

# Cast numeric columns to double for consistency
for column in numeric_columns:
    df = df.withColumn(column, col(column).cast("double"))

print("Missing values per column:")
for k, v in missing_counts.items():
    print(f"{k}: {v}")

print(f"\nDuplicate rows: {duplicate_count}")

# Script 4: Time-Series Demand Forecast Preparation (Operations)

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, to_date, weekofyear, year, avg, lag
from pyspark.sql.window import Window

spark = SparkSession.builder.appName("DemandForecastPrep").getOrCreate()

# Load demand data
df = spark.read.csv("daily_demand.csv", header=True, inferSchema=True)

# Convert date column to date type
df = df.withColumn("date", to_date(col("date")))

# Create year-week identifier
df = df.withColumn("year", year(col("date")))
df = df.withColumn("week", weekofyear(col("date")))

# Aggregate weekly demand
weekly_demand = (
    df.groupBy("year", "week")
      .agg({"units_sold": "sum"})
      .withColumnRenamed("sum(units_sold)", "weekly_units_sold")
)

# Window for time-based calculations
window_spec = Window.orderBy("year", "week")

# Create rolling 4-week average
weekly_demand = weekly_demand.withColumn(
    "rolling_4_week_avg",
    avg("weekly_units_sold").over(window_spec.rowsBetween(-3, 0))
)

# Create lag feature
weekly_demand = weekly_demand.withColumn(
    "prev_week_demand",
    lag("weekly_units_sold", 1).over(window_spec)
)

# Remove rows with nulls caused by rolling and lag
weekly_demand = weekly_demand.dropna()

weekly_demand.show()

# Script 5: Operational KPI Dashboard Metrics (Product / Ops)

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, count

spark = SparkSession.builder.appName("OperationalKPIs").getOrCreate()

# Load API log data
logs_df = spark.read.json("api_logs.json")

# Convert timestamp to timestamp type
logs_df = logs_df.withColumn("timestamp", col("timestamp").cast("timestamp"))

# Calculate endpoint usage counts
endpoint_usage = (
    logs_df.groupBy("endpoint")
           .count()
           .withColumnRenamed("count", "request_count")
)

endpoint_usage.show()

# Extract hour of day
logs_df = logs_df.withColumn("hour", hour(col("timestamp")))

# Create hourly usage pivot table
hourly_usage = (
    logs_df.groupBy("hour")
           .pivot("endpoint")
           .agg(count("user_id"))
           .fillna(0)
)

hourly_usage.show()
