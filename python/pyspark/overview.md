# Architecture
1. Driver directs Executors
   1. Executors are located on JVM with X number of cores in each JVM, each core is an executor
   2. Shuffle is a task where data is persisted into another phase
   3. Tasks are performed by executors
2. Execution plans are defined as DAGs

# Functions
## General
1. concat()
2. filter()
3. Window
```
# Partition by the unique key and order by timestamp to find the latest record.
window_spec = Window.partitionBy("transaction_id").orderBy(df.event_timestamp.desc())

# 2. Add the rank column, then filter to keep only the latest record (rank=1).
# The original schema is preserved without a complex aggregation.
clean_df = (df.withColumn("rank", row_number().over(window_spec))
              .filter("rank = 1")
              .drop("rank")) # Drop the temporary rank column
```
4. when()
   1. when(isnull(col("created_at")), ...)
## Preprocessing
1. trim()