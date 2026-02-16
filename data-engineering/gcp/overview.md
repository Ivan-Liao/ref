# Products
1. Batch
   1. Designed for multi day batch jobs, managed service
2. Bigquery
   1. cloud serverless data warehouse
   2. paritioning and clustering (clustering is within partitions by key)
      1. Common partition is by ingestion-time or timestamp
   3. views
      1. use case for frequently used query
      2. authorized
   4. Federated queries
      1. query data in-place (use case for small changing dataset that augments a larger more static dataset)
3. Bigtable 
   1. low-latency, high-throughput access
   2. excels at single row lookup
   3. no support for SQL or complex aggregation
   4. Can handle terabytes of data if key-value pairs like time series financial data
4. Catalog
   1. Can tag data entries to give more transparency to data origin and descriptions
5. Cloud Build
   1. CI/CD pipeline creation (can monitor updates in a source repository)
6. Cloud Composer
   1. Orchestrates a series of data pipelines tasks, allocates resources
   2. Managed Apache Airflow
7. Cloud KMS (key management service)
8. Cloud Run
   1. Deploying and running containerized applications (Caas)
   2. Often paired with Cloud Tasks to rate limit and control scheduling
9.  Cloud Scheduler
   1. Allows scheduling for future events, does not allocate resources
10. Cloud SQL
   1. Does not scale well for high velocity operational data
11. Data Access Audit Logs
    1.  Must be enabled first, used for analyzing object access records
12. Dataflow
   1. Data transformation pipelines
   2. requires schema definition
   3. side output (Tag) can rerout invalid records to a seperate PCollection (Dead Letter file in GCS)
   4. Windows
      1. sliding window (overlapping data)
      2. fixed window (tumbling e.g. 10-11 am, 11-12 pm, etc.)
      3. session window (group by activity)
13. Data Fusion
   1. no/low code complex, enterprise-grade ETL pipelines
   2. Powered by dataproc and generally a monthly cost for instance
14. Dataplex
   1. For different types of data with many producers
   2. raw and curated zones (unprocessed and process data)
15. Dataprep
   1. Low code for data transformation, free for UI, costs based on Dataflow jobs
   2. runs on Dataflow and connects to more destinations like Oracle, SAP, Salesforce
16. Dataproc
   1. Managed Hadoop/Spark service
   2. ephemeral clusters spin up and shut down with demand
   3. master nodes set on creation of cluster
      1. HA (high availability) 3 masters mode is a common pattern
   4. worker nodes can be resized
   5. Has a serverless version
17. Datastore
   1. NoSQL database
18. DLP (Data Loss Prevention) API
   1. Identifies and redacts data that matches infoTypes like credit card numbers, phone, numbers, email IDs
19. IAM (Identity and Access Management)
    1.  Related to ACLS (access control list on the resource level)
20. Logging (GCL)
21. PubSub
   1. streaming data
22. Spanner
    1.  RDS high availability and horizontal scalability globally
    2.  Automatic sharding and scaling
23. Storage (GCS)
   1. equivalent to AWS S3
   2. Retention period can be set
   3. lifecycle policy for moving data between storage classes on a schedule
   4. Storage classes ... standards (none minimum days), nearline (30 days), coldline (90 days), archive (365 days)
24. Storage Transfer Service
    1.  Connects from HTTPS endpoint to Google Cloud (used to transfer TBs of data)
25. Workflows
    1. Connects a series of shorter tasks

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