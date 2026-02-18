- [Errors](#errors)
- [Products](#products)
- [Use Cases](#use-cases)

# Errors
1. Exceeded rate limits: too many concurrent queries for this project_and_region
   1. report generation queries should be run in batch mode
2. A hot key HOT_KEY_NAME was detected in…
   1. data skew problem, solved by evenly distributing keys

# Products
1. Alloy DB (mission-critical vs more general Cloud SQL)
   1. Managed PostgresQL database
2. Analytics Hub
   1. Private and public datasets
   2. publishers and subscribers
   3. access control and monetization settings
3. Batch
   1. Designed for multi day batch jobs, managed service
4. Bigquery
   1. Cloud serverless data warehouse
   2. Federated queries (for data outside of Bigquery)
      1. query data in-place (use case for small changing dataset that augments a larger more static dataset)\
   3. Flex slots, short burst demand
   4. Materialized Views for precomputed views that are cached
      1. user defined schedule (default 30 min) possible
      2. typically updates within 5 min of base table change
   5. Object tables (for unstructured data)
   6. Paritioning and clustering (clustering is within partitions by key)
      1. Common partition is by ingestion-time or timestamp
   7. Policy tags for fine grained column access
   8. views
      1. use case for frequently used query
      2. authorized views
5. Bigtable 
   1. low-latency, high-throughput access
   2. excels at single row lookup
   3. no support for SQL or complex aggregation
   4. Can handle terabytes of data if key-value pairs like time series financial data
6. Catalog
   1. Can tag data entries to give more transparency to data origin and descriptions
7. Cloud Build
   1. CI/CD pipeline creation (can monitor updates in a source repository)
8. Cloud Composer
   1. Managed Apache Airflow
   2. Orchestrates a series of data pipelines tasks, allocates resources
   3. Tasks should be one task per operation
9.  Cloud KMS (key management service)
10. Cloud monitoring
   1.  Can set up alerts for dataflow system lag
11. Cloud Run
   1. Deploying and running containerized applications (Caas)
   2. Often paired with Cloud Tasks to rate limit and control scheduling
12. Cloud Scheduler
   1. Allows scheduling for future events, does not allocate resources
13. Cloud SQL
   1. Does not scale well for high velocity operational data
14. Connected Sheets
    1.  Bigquery to google sheets connection
15. Data Access Audit Logs
    1.  Must be enabled first, used for analyzing object access records
16. Dataflow
   1. Data transformation pipelines
   2. requires schema definition
   3. side output (Tag) can rerout invalid records to a seperate PCollection (Dead Letter file in GCS)
   4. Windows
      1. sliding window (overlapping data)
      2. fixed window (tumbling e.g. 10-11 am, 11-12 pm, etc.)
      3. session window (group by activity)
   5. Dataflow snapshots to plan for disaster recovery
17. Data Fusion
   1. no/low code complex, enterprise-grade ETL pipelines
   2. Powered by dataproc and generally a monthly cost for instance
18. Dataplex
   1. For different types of data with many producers
   2. raw and curated zones (unprocessed and process data)
   3. exclude patterns
   4. data lakes
19. Dataprep
   1. Low code for data transformation, free for UI, costs based on Dataflow jobs
   2. runs on Dataflow and connects to more destinations like Oracle, SAP, Salesforce
20. Dataproc
   1. Managed Hadoop/Spark service
   2. ephemeral clusters spin up and shut down with demand (useful for prioritizing jobs)
   3. master nodes set on creation of cluster
      1. HA (high availability) 3 masters mode is a common pattern
   4. worker nodes can be resized
   5. Has a serverless version
   6. autoscaling
      1. suggested use case is with single job clusters since there will be no overlap with other job scaling
21. Datastore
   1. NoSQL database
22. Datastream
23. DLP (Data Loss Prevention) API
   1. Identifies and redacts data that matches infoTypes like credit card numbers, phone, numbers, email IDs
24. Firestore 
    1.  NoSQL document database for app development and smaller-scare structures vs Bigtable
25. IAM (Identity and Access Management)
    1.  Related to ACLS (access control list on the resource level)
26. Logging (GCL)
27. Looker
    1.  Has modeling tools to abstract data sources
28. Looker Studio (prev. Data Studio)
    1.  Vizualization tool
29. PubSub
   1. streaming data
30. Spanner
    1.  RDS high availability and horizontal scalability globally
    2.  Automatic sharding and scaling
31. Storage (GCS)
   1. Equivalent to AWS S3
   2. HTTPS requests including ranged GETS to get a portion of data
   3. Lifecycle policy for moving data between storage classes on a schedule
   4. Retention period can be set
   5. Size limits 5 TB per object
   6. Storage classes ... standards (none minimum days), nearline (30 days), coldline (90 days), archive (365 days)
32. Storage Transfer Service
    1.  Connects from HTTPS endpoint to Google Cloud (used to transfer TBs of data)
33. Workflows
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