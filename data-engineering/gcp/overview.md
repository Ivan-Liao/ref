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
3. App Engine
   1. Service that apps can be deployed onto
   2. Features
      1. Persistent storage with queries, sorting, and transactions
      2. Asynchronous task queues
      3. Scheduled tasks for triggering events at specified times
      4. Automatic scaling and load balancing
4. Artifact Registry
   1. Repos for things like Docker images
5. Batch
   1. Designed for multi day batch jobs, managed service
6. Biglake
   1. Can query data across Cloud Storage, and even other cloud object stores
   2. Tables are more capable than bigquery external tables
      1. Streamlined security management through service accounts
      2. Connects to external cloud providers like AWS S3
      3. Iceberg, Delta, Hudi support
      4. Column-level security
      5. Data masking
   3. Metadata caching behind the scenes
      1. Freshness set between 30 minutes and 7 days
   4. Built on Apache arrow
7. Bigquery
   1. Cloud serverless data warehouse
   2. views
      1. use case for frequently used query
      2. authorized views
   3. UDFs
      1. SQL
      2. Javascript
   4. Query management
      1. save, version, schedule, share
   5. Dataform
      1. Complex SQL workflows
      2. Running other SQL scripts, data quality tests, configuring security
      3. sqlx file (config, js [local js functions and constraints], pre_operations, SQL body, post_operations)
         1. use case like reusable js functions (e.g. mapping countries to categorical list instead of long case statement)
         2. config types (declaration, table, incremental, view, assertion, operations)
   6. External tables
      1. Cloud Storage, Google Sheets, and Bigtable
      2. For less frequent access and no data movement
      3. Slower performance, unknown cost estimation, no table preview, no query caching
   7. Federated queries (for data outside of Bigquery)
      1. query data in-place (use case for small changing dataset that augments a larger more static dataset)\
   8. Materialized Views for precomputed views that are cached
      1. user defined schedule (default 30 min) possible
      2. typically updates within 5 min of base table change
   9.  Object tables (for unstructured data)
   10. Paritioning and clustering (clustering is within partitions by key)
      1. Common partition is by ingestion-time or timestamp
   11. Policy tags for fine grained column access
   12. Flex slots, short burst demand
   13. AI integration
       1. (20260311, can only run on one table at a time)
       2.  Table Explorer
           1.  Select fields and bq will generate interactive cards that create queries
       3.  Insights
           1.  Generates automatic queries
       4.  Code assist
       5.  Data Canvas
           1.  Low code, prompt based, supports dashboarding
   14. Misc
       1.  10 GB streaming API limit
8. Bigtable 
   1. low-latency (millisecond level), high-throughput access
   2. wide column, with column family
   3. excels at single row lookup
   4. no support for SQL or complex aggregation
   5. Can handle terabytes of data if key-value pairs like time series financial data
9.  Catalog
   1. Can tag data entries to give more transparency to data origin and descriptions
10. Cloud Build
   1. CI/CD pipeline creation (can monitor updates in a source repository)
11. Cloud Composer
   1. Managed Apache Airflow (not serverless)
   2. Orchestrates a series of data pipelines tasks, allocates resources
   3. Tasks should be one task per operation
12. Cloud KMS (key management service)
13. Cloud monitoring
   1.  Can set up alerts for dataflow system lag
14. Cloud Run
   1. Execute code based on Google Cloud events
      1.  Triggers include HTTP/S calls, Pub/Sub messages, Cloud storage changes, Firestore updates, custom Eventarc events
   2. Deploying and running containerized applications (Caas)
   3. Often paired with Cloud Tasks to rate limit and control scheduling
15. Cloud Scheduler
   1. Allows scheduling for future events with YAML
      1. Frequency and precise time of day
      2. Triggers include HTTP/S calls, App Engine HTTP calls, Pub/Sub messages, Workflows
      3. does not allocate resources
16. Cloud SQL
   1. Can be suitable for > 20 CCU (concurrent users)
   2. Does not scale well for very high velocity operational data, use AlloyDB instead
17. Compute Engine (AWS EC2)
18. Connected Sheets
    1.  Bigquery to google sheets connection
19. Data Access Audit Logs
    1.  Must be enabled first, used for analyzing object access records
20. Dataflow
   1. Data transformation pipelines, templates, notebooks
   2. requires schema definition
   3. side output (Tag) can rerout invalid records to a seperate PCollection (Dead Letter file in GCS)
   4. Windows
      1. sliding window (overlapping data)
      2. fixed window (tumbling e.g. 10-11 am, 11-12 pm, etc.)
      3. session window (group by activity)
   5. Dataflow snapshots to plan for disaster recovery
   6. Misc
      1. Max limit 10 TB per day per job
21. Data Fusion
   1. no/low code drag and drop for complex, enterprise-grade ETL pipelines, not serverless
   2. Powered by dataproc and generally a monthly cost for instance
22. Dataplex
   1. For different types of data with many producers
   2. raw and curated zones (unprocessed and process data)
   3. exclude patterns
   4. data lakes
23. Dataprep
   1. Low code for data transformation (recipes), free for UI, costs based on Dataflow jobs
   2. runs on Dataflow and connects to more destinations like Oracle, SAP, Salesforce
24. Dataproc
   1. Managed Hadoop/Spark service, Jupyter integration
   2. ephemeral clusters spin up and shut down with demand (useful for prioritizing jobs)
   3. master nodes set on creation of cluster
      1. HA (high availability) 3 masters mode is a common pattern
   4. worker nodes can be resized
   5. Has a serverless version
   6. autoscaling
      1. suggested use case is with single job clusters since there will be no overlap with other job scaling
   7. Connectors to Bigquery and Bigtable
   8. Workflow templates specified in YAML files (order of execution, required parameters)
   9. Spark SQL for structured data (batch processing, interactive notebooks), Spark streaming for real time, MLlib for ML (VertexAI), GraphX for graph data
25. Datastore
   1. NoSQL database
26. Datastream
    1.  Datastream enables continuous replication of on-premises or multi-cloud relational databases such as Oracle, MySQL, PostgresSQ,L or SQL Server into Google Cloud, Bigquery, or Dataflow
    2.  Datastream events
        1.  Metadata provides context about the data, like source table, timestamps, and related information.
        2.  Payload contains the actual data changes in a key-value format, reflecting column names and their corresponding values.
    3.  Taps into the source database's write-ahead log (WAL)
    4.  Flexibility in connectivity options and can selectively replicate data at the schema, table, or column level.
27. DLP (Data Loss Prevention) API
   1. Identifies and redacts data that matches infoTypes like credit card numbers, phone, numbers, email IDs
28. Eventarc
    1.  Connects event sources via Pub/Sub
        1.  Google Cloud services, third-party, custom events, Cloud Run
    2.  Use cases
        1.  BQ insert operation >> Cloud Audit Log event >> Eventarc >> (rebuild dashboard, train ML model, etc.)
29. Firestore 
    1.  NoSQL document database for app development and smaller-scare structures vs Bigtable
30. IAM (Identity and Access Management)
    1.  Related to ACLS (access control list on the resource level)
31. Logging (GCL)
32. Looker
    1.  Has modeling tools to abstract data sources
33. Looker Studio (prev. Data Studio)
    1.  Vizualization tool
34. PubSub
   1. streaming data
35. Spanner
    1.  RDS high availability and horizontal scalability globally, best function rds
    2.  Automatic sharding and scaling
36. Storage (GCS)
   1. Equivalent to AWS S3
   2. HTTPS requests including ranged GETS to get a portion of data
   3. Lifecycle policy for moving data between storage classes on a schedule
   4. Retention period can be set
   5. Size limits 5 TB per object
   6. Storage classes ... standards (none minimum days), nearline (30 days), coldline (90 days), archive (365 days)
   7. When you "create" a folder in the console or via CLI, you are typically creating a 0-byte object that ends in a slash.
37. Storage Transfer
    1.  gloud storage command (typically 100 MB/sec)
        1.  from file systems, object stores, HDFS
    2.  Storage Transfer Service (up to 10GB/sec)
        1.  Connects from HTTPS endpoint to Google Cloud (used to transfer TBs of data)
    3.  Transfer Appliance service (offline)
    4.  
38. Workflows
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