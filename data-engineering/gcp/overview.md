# Products
1. Bigquery
   1. cloud datawarehouse
   2. paritioning and clustering (clustering is within partitions by key)
   3. views
      1. authorized
2. Cloud Bigtable 
   1. low-latency, high-throughput access
   2. excels at single row lookup
   3. no support for SQL or complex aggregation
   4. serverless data warehouse
3. Cloud KMS (key management service)
4. Cloud SQL
   1. Does not scale well for high velocity operational data
5. Dataflow
   1. Data transformation pipelines
   2. requires schema definition
   3. side output (Tag) can rerout invalid records to a seperate PCollection (Dead Letter file in GCS)
   4. Windows
      1. sliding window (overlapping data)
      2. fixed window (tumbling e.g. 10-11 am, 11-12 pm, etc.)
      3. session window (group by activity)
6. Dataplex
   1. For different types of data with many producers
7. Dataprep
   1. Low code for data transformation
8. Dataproc
   1. Managed Hadoop/Spark service
   2. ephemeral clusters spin up and shut down with demand
   3. master nodes set on creation of cluster
      1. HA (high availability) 3 masters mode is a common pattern
   4. worker nodes can be resized
9.  Datastore
   1. NoSQL database
10. DLP (Data Loss Prevention) API
   1. Identifies and redacts data that matches infoTypes like credit card numbers, phone, numbers, email IDs
11. Logging (GCL)
12. PubSub
   1. streaming data
13. Storage (GCS)
   1. equivalent to AWS S3
   2. Retention period can be set
14. Storage Transfer Service
    1.  Connects from HTTPS endpoint to Google Cloud (used to transfer TBs of data)

# Use Cases
1. High throughput, low latency data lookup as well as analytical aggregations
   1. Cloud Bigtable for low latency lookup and export to Bigquery for analytical needs
2. Json file source files with frequent schema changes (schema drift)
   1. (preferred for performance) Load into bigquery with schema-auto-detection feature enables
   2. (preferred for flexibility and archival) Load into GCS and define a Bigquery external table
3. PC/Mobile application data handling 2 hour delays
   1. Dataflow with fixed window with allowedLateness = 2 hours
4. Uploading a large (TB) amount of data
   1. Order a transfer appliance and ship to Google
   2. NOT through google cloud console