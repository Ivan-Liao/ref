- [Errors](#errors)
- [Products](#products)
- [References](#references)
- [Use Cases](#use-cases)

# Errors
1. Bigquery
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
   1. Containerized or script based batch jobs, automatically provisions and scales compute engine resources
   2. Designed for multi day batch jobs, managed service
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
   5. Creation
      1. From Bigquery, creating a BigLake table using a Cloud resource connection
   6. Use cases
      1. Biglake tables >> Apache Spark / Trino / Apache Flink / Bigquery
7. Bigquery main
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
      1. Table definition on data in Cloud Storage, Google Sheets, and Bigtable
         1. Connected Sheets (google sheets)
      2. For less frequent access and no data movement
      3. Slower performance, unknown cost estimation, no table preview, no query caching
   7. Federated queries (for data outside of Bigquery e.g. AlloyDB, Spanner, Cloud SQL)
      1. Connection object to query data in-place (use case for small changing dataset that augments a larger more static dataset)
      2. Storage and compute takes place on external engine
   8. Materialized Views for precomputed views that are cached
      1. user defined schedule (default 30 min) possible
      2. typically updates within 5 min of base table change
   9.  Object tables (for unstructured data)
   10. Partitioning and clustering (clustering is within partitions by key)
      1. Common partition is by ingestion-time or timestamp
      2. Support table level filter enforcement (--require-partition-filter=True)
   11. Policy tags for fine grained column access
   12. Flex slots, short burst demand
   13. AI integration
       1.  Table Explorer
           1.  Select fields and bq will generate interactive cards that create queries
       2.  Insights
           1.  Generates automatic queries
           2.  (20260311, can only run on one table at a time)
       3.  Code assist in SQL query tabs
       4.  Data Canvas
           1.  Low code, prompt enabled, supports dashboarding
   14. Data transfer service
       1.  Batch service with support sources like Salesforce and Paypal
   15. Streaming
       1. Storage write API
          1.  default implicit streaming
          2.  explicit streaming (committed, pending, buffered)
   16. CDC (change data capture)
   17. Continuous Queries
       1.  Continuous execution
       2.  SQL based and scheduled
       3.  Event-driven
   18. Reverse ETL 
       1.  e.g. push to Bigtable, other operational database, stream topic (Pub/Sub), Spanner, other bq tables
   19. Misc
       1.  10 GB streaming API limit
       2.  slots (workers) and shuffle (parallel processing) enable massive at scale analytics
       3.  Colossus is bq's query engine, Jupiter is google's petabit internal network shuffling processor 
8. Bigtable 
   1. low-latency (millisecond level), high-throughput access
   2. wide column, with column family (partitioning like benefits)
   3. excels at single row lookup
   4. no support for SQL or complex aggregation
   5. Can handle terabytes of data if key-value pairs like time series financial data
   6. Secondary indexes
      1. Used to facilitate complex queries that the default row key doesn't handle
9. Catalog
   1. Can tag data entries to give more transparency to data origin and descriptions
10. Cloud Build
   1. CI/CD pipeline creation (can monitor updates in a source repository)
11. Cloud Composer
   1. Overview
      1. Managed Apache Airflow (not serverless)
      2. Orchestrates a series of data pipelines tasks, allocates resources
      3. Tasks should be one task per operation
   2. Use case
      1. Suitable for complex tasks
      2. Python based, managed airflow
      3. Some latency (seconds) between tasks
      4. Allows retry from a step
      5. Airflow UI with operational tools, dashboards, logs
12. Cloud DQ
    1.  Data quality check defined by yaml
```
rules:
- nonNullExpectation: {}
  column: id
  dimension: COMPLETENESS
  threshold: 1
- regexExpectation:
    regex: '^[^@]+[@]{1}[^@]+$'
  column: email
  dimension: CONFORMANCE
  ignoreNull: true
  threshold: .85
postScanActions:
  bigqueryExport:
    resultsTable: projects/qwiklabs-gcp-01-8543c11be25c/datasets/customers_dq_dataset/tables/dq_results
```
13. Cloud KMS (key management service)
14.  Cloud monitoring
   1.  Can set up alerts for dataflow system lag
15.  Cloud Run
   1. Execute code based on Google Cloud events
      1.  Triggers include HTTP/S calls, Pub/Sub messages, Cloud storage changes, Firestore updates, custom Eventarc events
   2. Deploying and running containerized applications (Caas)
   3. Often paired with Cloud Tasks to rate limit and control scheduling
16.  Cloud Scheduler
   1. Allows scheduling for future events with YAML
      1. Google's equivalent of cron scheduler
      2. Frequency and precise time of day
      3. Triggers include HTTP/S calls, App Engine HTTP calls, Pub/Sub messages, Workflows
      4. does not allocate resources
17.  Cloud SQL
   1. Can be suitable for > 20 CCU (concurrent users)
   2. Does not scale well for very high velocity operational data, use AlloyDB instead
18. Compute Engine (AWS EC2)
19. Data Access Audit Logs
    1.  Must be enabled first, used for analyzing object access records
20. Dataflow main
   1. Data transformation pipelines, templates, notebooks
   2. Requires schema definition in json
   3. Side output (Tag) can rerout invalid records to a seperate PCollection (Dead Letter file in GCS)
   4. Windows
      1. sliding window (overlapping data)
      2. fixed window (tumbling e.g. 10-11 am, 11-12 pm, etc.)
      3. session window (group by activity)
   5. Dataflow snapshots to plan for disaster recovery
   6. Misc
      1. Max limit 10 TB per day per job
   7. Dataflow AI insights automatic detection of performance issues
   8. Job monitoring interface execution graphs to detect inefficiences and monitor overall health
   9.  Optimization parameters
      1.  worker machine types and auto scaling limits
      2.  optimize custom UDFs/transforms
      3.  Pre-process data to mitigate skew or use Beam's re-partitioning
      4.  Configure sources and sinks with focus on file size, compression, and data partitioning
    10. Monitoring
        1.  Job List
        2.  Job Info ... metadata, resources, parameters
        3.  Logs (worker logs)
        4.  Job Graph
            1.  Custom metrics
                1.  Counter
                2.  Distribution (Count, min, max, mean)
                3.  Guage (latest value)
                4.  Job Metrics
                    1. num workers, throughput ... monitor for uneven resource usage skew
                    2. data freshness
                    3. system latency
                    4. Input and output metrics
                       1. Requests per second
                       2. Response errors per second
                5.  Cloud Monitoring Metrics Explorer 
                    1.  custom dashboards
    11. Disaster recovery
        1.  Recommended
            1.  Dataflow snapshot with sources >> Stop and Drain pipeline >> create new job from snapshot
        2.  7 days of data retention
    12. Templates
        1.  Classic ... stages the pipeline as a template file on Google Cloud Storage
            1. Lacks ValueProvider system Support (allows users to submit runtime parameters) ... a system that allows uers to change between output to Bigquery or Cloud storage would require 2 classic templates
            2. Lacks dynamic DAG support
        2.  Flex
            1.  Docker images uploaded to Google Container Registry and metadata spec file in Cloud Stoage (optional regex validation for parameters), job graph generated at the end
        3.  Google-provided
    13. Misc
        1.  Cannot change location of job after start
21. Data Fusion
   1. no/low code drag and drop for complex, enterprise-grade ETL pipelines, not serverless
   2. Powered by dataproc and generally a monthly cost for instance
22. Dataplex
   1. For different types of data with many producers
   2. raw and curated zones (unprocessed and process data)
   3. exclude patterns
   4. data lakehouse management
23. Dataprep
   1. Low code for data transformation (recipes), free for UI, costs based on Dataflow jobs
   2. runs on Dataflow and connects to more destinations like Oracle, SAP, Salesforce
24. Dataproc (Spark serverless)
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
   10. Spark History Server (SSUI) with execution graphs and metrics
   11. Cloud logging and monitoring (custom dashboards and alerts)
   12. Optimization
       1.  executor memory/cores, num executers
       2.  optimize Spark application code (dataframes, SQL, joins, repartitioning)
       3.  Key salting, custom partitioning, pre-aggregation
       4.  Configure sources and sinks with focus on file size, compression, and data partitioning
25. Datastore
   1. NoSQL database for smaller application backends, less optimized (key value NoSQL dB)
26. Datastream
    1.  Datastream enables continuous replication of on-premises or multi-cloud relational databases such as Oracle, MySQL, PostgresSQ,L or SQL Server into Google Cloud, Bigquery, or Dataflow
    2.  Datastream events
        1.  Metadata provides context about the data, like source table, timestamps, and related information.
        2.  Payload contains the actual data changes in a key-value format, reflecting column names and their corresponding values.
    3.  Taps into the source database's write-ahead log (WAL)
    4.  Flexibility in connectivity options and can selectively replicate data at the schema, table, or column level.
27. DLP (Data Loss Prevention) API
   1. Identifies and redacts data that matches infoTypes like credit card numbers, phone, numbers, email IDs
   2. Sensitive Data Protection can scan columns for sensitive data like PPI
28. Eventarc
    1.  Connects event sources via Pub/Sub
        1.  Google Cloud services, third-party, custom events, Cloud Run
    2.  Use cases
        1.  BQ insert operation >> Cloud Audit Log event >> Eventarc >> (rebuild dashboard, train ML model, etc.)
29. Firestore 
    1.  NoSQL document database for app development and smaller-scare structures vs Bigtable
    2.  Firestore in datastore mode is an option
30. Gemini
    1.  Local, Remote (AI cloud), Imported (e.g. from Tensorflow)
31. IAM (Identity and Access Management)
    1.  Related to ACLS (access control list on the resource level)
    2.  IAM users get permissions
    3.  Service account grant principals access
32. Logging (GCL)
33. Looker
    1.  Has modeling tools to abstract data sources
34. Looker Studio (prev. Data Studio)
    1.  Vizualization tool
35. Managed Service for Kafka main
    1.  streaming data
    2.  vCPU and memory require config but Google handles broker sizing, cluster creation, storage management, and rebalancing
    3.  persistent log potentially forever
    4.  message order within partition and exactly-once delivery optional
    5.  Offers Kafka connect for Pub/Sub
    6.  Producer, Consumer, and consumer group instead of publisher, subscriber and subscription
36. Pub/Sub main
   1. streaming data
   2. serverless no ops, scales automatically, no cluster or partitions to worry about
   3. message retention default 7 days can extend to 30 days, has seek function
   4. At least once delivery but offers exactly once delivery (build additional idempotent logic into subscriber to handle the duplicate messages)
   5. Ordered keys to maintain message order of messages with same key
   6. More tight integration with GCP
   7. single message transforms (SMT) like javascript UDF
   8. Message filtering
   9. Dead letter topics (DLT)
37. Spanner
    1.  RDS high availability and horizontal scalability globally, best function and scale RDS GCP has to offer (64+ TB should upgrade from Cloud SQL)
    2.  Automatic sharding and scaling
38. Storage (GCS)
   1. Equivalent to AWS S3
   2. HTTPS requests including ranged GETS to get a portion of data
   3. Lifecycle policy for moving data between storage classes on a schedule
   4. Retention period can be set
   5. Size limits 5 TB per object
   6. Storage classes ... standards (none minimum storage days), nearline (30 days), coldline (90 days), archive (365 days)
   7. When you "create" a folder in the console or via CLI, you are typically creating a 0-byte object that ends in a forward slash.
39. Storage Transfer
    1.  gloud storage command (typically 100 MB/sec)
        1.  from file systems, object stores, HDFS
    2.  Storage Transfer Service (up to 10GB/sec)
        1.  Connects from HTTPS endpoint to Google Cloud (used to transfer TBs of data)
    3.  Transfer Appliance service (offline)
40. VertexAI
    1.   Vertex AI Model Registry
         1.   Can deploy models to endpoints
41. Workflows
    1. Connects a series of shorter tasks
    2. Use case
       1. API chaining
       2. Declarative YAML/JSON
       3. lower latency than Composer
       4. Retry from step not possible
       5. Google cloud console visualizations and integrated Cloud Logging


# References
1. well architected framework
   1. https://docs.cloud.google.com/architecture/framework?utm_source=youtube&utm_medium=unpaidsoc&utm_campaign=CDR_yur_gcp_hh_z8qewgfq_EngineeringForReliability_112921&utm_content=description#logging_monitoring_and_operations

# Use Cases
1. High throughput, low latency data lookup as well as analytical aggregations
   1. Cloud Bigtable for low latency lookup and export to Bigquery for analytical needs
2. Json file source files with frequent schema changes (schema drift)
   1. (preferred for performance) Load into bigquery with schema-auto-detection feature enables
   2. (preferred for flexibility and archival) Load into GCS and define a Bigquery external table
3. PC/Mobile application data handling 2 hour delays
   1. Dataflow with fixed window with allowedLateness = 2 hours
4. Uploading a large (100+ TB) amount of data
   1. Order a transfer appliance and ship to Google
   2. NOT through google cloud console