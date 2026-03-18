1. Set up a connection
   1. Bigquery Studio > add data
   2. Search Vertex AI and set up a federated connection
   3. In project > Connections, note the service account id
2. Grant permissions
   1. Navigate to IAM and +Grant access
   2. Use the service account id and assing Storage Object Viewer role
3. Set up a Bigquery Biglake table dataset
   1. Create dataset demo_dataset
   2. Create table
      1. Load from GCS
      2. Browse for customers.csv in bucket
      3. Name the table
      4. Table type: External table
      5. Create a BigLake table using a Cloud Resource connection
      6. Schema enable edit as text
```
// shortened example, other data types NUMERIC, TIMESTAMP
[
{
    "name": "customer_id",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "first_name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "last_name",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "support_rep_id",
    "type": "INTEGER",
    "mode": "NULLABLE"
  }
]
```
   3. Policy tags
      1. Can edit schema of table and set policy tag to restrict column access
      2. Can still query unrestricted columns
```
SELECT * EXCEPT(address, phone, postal_code)
FROM `qwiklabs-gcp-03-8a4d4330f25c.demo_dataset.biglake_table`
```
4. Set up an external table
   1. Same steps as 3 but don't use the Connection
   2. Update external table to Biglake table
```
export PROJECT_ID=$(gcloud config get-value project)
bq mkdef \
--autodetect \
--connection_id=$PROJECT_ID.US.my-connection \
--source_format=CSV \
"gs://$PROJECT_ID/invoice.csv" > /tmp/tabledef.json

cat /tmp/tabledef.json

bq show --schema --format=prettyjson  demo_dataset.external_table > /tmp/schema

bq update --external_table_definition=/tmp/tabledef.json --schema=/tmp/schema demo_dataset.external_table
```