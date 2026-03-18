1. Setup connection to AlloyDB
   1. Add data from Bigquery explorer
   2. Select Google Cloud AloyDB under Featured data sources
   3. Click Bigquery Federation
      1. alloydb instance is a uri like //alloydb.googleapis.com/projects/qwiklabs-gcp-01-dd01ff1e1baa/locations/us-west1/clusters/cymbal-cluster/instances/cymbal-instance
2. Set IAM permissions
   1. Service Account ID
      1. Get from bq like service-188738345590@gcp-sa-bigqueryconnection.iam.gserviceaccount.com
   2. Roles
      1. AlloyDB Client
      2. BigQuery Connection User
3. Query 
```
WITH log AS (
  SELECT customer_id, log_id, timestamp, url FROM EXTERNAL_QUERY("qwiklabs-gcp-01-dd01ff1e1baa.us-west1.AlloyDB-weblog", "SELECT customer_id, CAST(log_id AS VARCHAR(200)) AS log_id, timestamp, url FROM web_log LIMIT 100"))
SELECT  log.customer_id
, log.timestamp
, log.url
, C.*
FROM customers.customer_details AS C
INNER JOIN log
ON C.id = log.customer_id
ORDER BY C.id
LIMIT 100;
```