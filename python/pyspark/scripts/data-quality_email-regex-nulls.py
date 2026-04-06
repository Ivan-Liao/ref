# Import necessary libraries

import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when

# This script expects 1 command-line argument:
# 1. The destination BigQuery table path in format 'dataset.table'

if len(sys.argv) != 2:
    print("Usage: customer_dq.py <bq_dataset_table>")
    sys.exit(-1)

# Assign command-line argument to variable
bq_dataset_table = sys.argv[1]

# Lab variables are substituted here when the lab runs
bq_project = "qwiklabs-gcp-03-c6a5aae5f4a9"
gcs_source_path = f"gs://{bq_project}-main-bucket/source/customer_contacts_1000.csv"
gcs_dlq_path = f"gs://{bq_project}-dlq-bucket/errors/"

# Initialize a new Spark Session
spark = SparkSession.builder.appName("Customer DQ Check").getOrCreate()

# Step 1: Read the source CSV data from the GCS bucket
df = spark.read.option("header", "true").option("inferSchema", "true").csv(gcs_source_path)

# Step 2: Define the Data Quality rules
# Rule 1: The 'id' column must not be null.
dq_rule_id = col("id").isNotNull()

# Rule 2: The 'email' column must not be null and must match a valid email format regex.
email_regex = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
dq_rule_email = col("email").isNotNull().__and__(col("email").rlike(email_regex))

# Step 3: Apply rules and split the DataFrame into clean and error records
df_with_dq = df.withColumn("dq_passed", when(dq_rule_id.__and__(dq_rule_email), True).otherwise(False))
clean_df = df_with_dq.filter(col("dq_passed") == True).drop("dq_passed")
error_df = df_with_dq.filter(col("dq_passed") == False).drop("dq_passed")

# Step 4: Write the clean records to the specified BigQuery table
# The BigQuery connector requires a temporary GCS bucket NAME.
temp_gcs_bucket_name = f"{bq_project}-main-bucket"

clean_df.write \
    .format("bigquery") \
    .option("table", bq_dataset_table) \
    .option("temporaryGcsBucket", temp_gcs_bucket_name) \
    .option("project", bq_project) \
    .mode("overwrite") \
    .save()

# Step 5: Write the error records to the DLQ bucket in GCS as a single CSV file
error_df.repartition(1).write \
    .option("header", "true") \
    .mode("overwrite") \
    .csv(gcs_dlq_path)

# Stop the Spark session
spark.stop()


'''
# Terraform env variable setup

    # The name for the final table in BigQuery
    export BQ_TABLE="valid_customers"

    # The BigQuery table path in 'dataset.table' format
    export BQ_DATASET_TABLE="customer_data_clean.${BQ_TABLE}"

    # The path to the 1000-record source CSV file
    export GCS_SOURCE_PATH="gs://qwiklabs-gcp-03-c6a5aae5f4a9-main-bucket/source/customer_contacts_1000.csv"

    # The GCS path where error records will be written
    export GCS_DLQ_PATH="gs://qwiklabs-gcp-03-c6a5aae5f4a9-dlq-bucket/errors/"

    # The GCS path to the PySpark script you just uploaded
    export PYSPARK_SCRIPT_PATH="gs://qwiklabs-gcp-03-c6a5aae5f4a9-main-bucket/scripts/customer_dq.py"

    # The full URI of the custom subnet created by Terraform
    export SUBNET_URI="projects/qwiklabs-gcp-03-c6a5aae5f4a9/regions/us-west1/subnetworks/spark-subnet"
'''
'''
 gcloud dataproc batches submit pyspark $PYSPARK_SCRIPT_PATH \
     --version=2.1 \
     --batch="customer-dq-job-$(date +%s)" \
     --region=us-west1 \
     --subnet=$SUBNET_URI \
     --deps-bucket=gs://qwiklabs-gcp-03-c6a5aae5f4a9-main-bucket \
     -- \ # seperates gcloud parameters from pyspark script parameters
     $BQ_DATASET_TABLE
'''