import spark


from pyspark.sql import SparkSession

spark = (
    SparkSession.builder
    .appName("Spark GCS CSV Table Example")
    .config("spark.hadoop.fs.gs.impl","com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
    .config("spark.hadoop.google.cloud.auth.service.account.enable","true")
    .config("spark.hadoop.google.cloud.auth.service.account.json.keyfile","/path/service-account.json")
    .getOrCreate()
)


spark.sql("""
CREATE TABLE orders_iceberg (
    order_id INT,
    user_id INT,
    order_amount DOUBLE,
    order_date DATE
)
USING ICEBERG
LOCATION 'gs://company-analytics-lake/orders_iceberg/'
""")


'''
csv version for reference

spark.sql("""
CREATE TABLE orders_csv (
    order_id INT,
    user_id INT,
    order_amount DOUBLE,
    order_date DATE
)
USING csv
OPTIONS (
    header = "true",
    inferSchema = "true"
)
LOCATION 'gs://company-analytics-lake/orders/'
""")
'''