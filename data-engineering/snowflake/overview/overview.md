<<<<<<< HEAD
# Admin

# API
Key Characteristics:
Client-Server Architecture: The client (e.g., web browser, mobile app) and server operate independently. 
Statelessness: Each request from the client to the server contains all the information needed to understand the request; the server does not store any client context between requests. 
Cacheability: Responses can be explicitly marked as cacheable or non-cacheable to improve performance. 
Uniform Interface: A consistent way of interacting with resources, including standardized HTTP methods and self-descriptive messages.
Layered System: Components can be organized in a hierarchy, invisible to the client, for scalability and security.

# Architecture

# DDL

# ETL-E

# ETL-L

# ETL-L

# Semi-structured

# Snowflake specific
1. Snowflake variables / parameters
```
set USER_NAME = '<YOUR_USER_NAME>';  -- e.g. ihl_test
set LOGIN_NAME = '<YOUR_LOGIN_NAME>'; -- e.g. ihl_test@xselltechnologies.com 
```
=======
- [Access Control](#access-control)
  - [Authentication](#authentication)
  - [Network Policies](#network-policies)
  - [Privileges](#privileges)
  - [Roles](#roles)
- [Billing](#billing)
- [Data Types](#data-types)
- [Export and Load](#export-and-load)
  - [File Formats](#file-formats)
  - [Load](#load)
    - [Non Snowpipe](#non-snowpipe)
    - [Snowpipe](#snowpipe)
    - [Stages](#stages)
- [Performance](#performance)
  - [Caching](#caching)
  - [Clustering](#clustering)
  - [History](#history)
  - [Search Optimization Service](#search-optimization-service)
  - [Tuning](#tuning)
- [Security](#security)
  - [Account Usage](#account-usage)
  - [Column level security (Governance)](#column-level-security-governance)
  - [Encryption](#encryption)
  - [Information Schema](#information-schema)
  - [Object Tagging (Governance)](#object-tagging-governance)
  - [Row Access Policies (Governance)](#row-access-policies-governance)
  - [Secure Views](#secure-views)
- [Sharing](#sharing)
  - [Exchange](#exchange)
  - [Marketplace](#marketplace)
  - [Secure Data Sharing](#secure-data-sharing)
- [Storage](#storage)
  - [Cloning](#cloning)
  - [Fail-safe](#fail-safe)
  - [Micropartition](#micropartition)
  - [Replication](#replication)
  - [Time Travel](#time-travel)
- [Transformations](#transformations)
- [Virtual Warehouse](#virtual-warehouse)
  - [Resource Monitors](#resource-monitors)
  - [Scaling](#scaling)





# Access Control
1. Privileges assigned to Roles assigned to Users (RBAC)
2. Discretionary Access Control (DAC)
   1. objects have an role owner
   2. owners can grant other roles access to that object 
3. Object hierarchy requires access to parent objects before child objects are accessible

## Authentication
1. Username and password
2. Multi-factor Authentication (MFA) via Duo Security
   1. Activated per user basis and only via the UI
   2. Recommended all ACCOUNTADMIN users use MFA
   3. Duo
      1. Approve push notification (default)
      2. Answer a call
   4. ALTER USER SET Parameters
      1. MIN_TO_BYPASS_MFA (temporarily disables MFA)
      2. DISABLE_MFA (must re-enroll to use MFA after disabling)
      3. ALLOW_CLIENT_MFA_CACHING
         1. reduces number of prompts for multiple logins
3. Federated Authentication ... Okta
   1.  Login options
       1.  Click SSO Button > Enter idP (identity provider) credentials 
       2.  Click on Snowflake application in idP App
   2.  CREATE SECURITY INTEGRATION
       1.  Properties
           1.  SAML2_x509_CERT
           2.  SAML2_SSO_URL
           3.  SAML2_PROVIDER
           4.  TYPE (like Okta, ADFS)
           5.  SAML2_ISSUER
           6.  ENABLED
4.  Key Pair Authentication
    1.  Generate Key-Pair using OpenSSL (like 2048-bit RSA key pair)
        1.  Minimum 2048-bit
    2.  Assign Public Key to user, user keeps private key safe on local machine
    3.  Configure Snowflake Client
        1.  SnowSQL
        2.  Python connector
        3.  Kafka connector
        4.  Others (Go, JDBC, ODBC, .NET, Node.js, SPark)
    4.  Optional Configure Key-Pair Rotation
        1.  Periodic rekeying default 12 months
5.  OAuth 2.0
6.  SCIM (system for cross-domain identity management), manages user and groups using RESTful APIs



## Network Policies
1. Additional layer of security, allows or denies acess to Snowflake account based on single IP or list of IPs
2. Steps
   1. Create Network Rules 
   2. Create Network Policies
      1. Can be in ALLOWED_NETWORK_RULE_LIST or BLOCKED_NETWORK_RULE_LIST
   3. Apply Network Policies
      1. ALTER ACCOUNT SET NETWORK_POLICY = <POLICY_HERE>
3. One network policy object per account or per user

## Privileges
1. Global privileges
   1. MANAGE GRANTS
2. Account Objects privileges
3. Schemas privileges
4. Schema Objects privileges ... Procedures, Tables, Tasks, Views, etc.
5. Verbs
   1. GRANT and REVOKE keywords
   2. MODIFY
   3. MONITOR
   4. OWNERSHIP
   5. SELECT
   6. USAGE
6. Future grants
   1. Examples
      1. grant select on future tables in database <DB_HERE>
      2. grant select on future view in schema <SCHEMA_HERE>
      3. grant usage on future schemas in database <DB_HERE>

## Roles
1. Definition ... entity to which privileges on securable objects can be granted or revoked
2. Role hierarchies are a common paradigm
3. Preset roles
   1. ORGADMIN 
      1. manage operations at organization level
      2. Can create account in an organization
      3. Can view all accounts in an organization
      4. Can view usage information across an organization
   2. ACCOUNTADMIN
      1. Top level role for an account
      2. encapsulates SYSADMIN and SECURITYADMIN
      3. Configure account-level parameters
      4. View and operate on all objects in account
      5. View and manage Snowflake billing and credit data
      6. Stop any running SQL statements
   3. SYSADMIN
      1. Create warhouses, databases, schemas, and other objects in an account
   4. SECURITYADMIN
      1. Create, monitor, and manage users and roles
   5. USERADMIN
      1. User and Role management via CREATE USER and CREATE ROLE privileges
   6. PUBLIC
      1. Granted to every user and other role by default
   7. CUSTOM ROLES
      1. Must be assigned to SYSADMIN or SYSADMIN will not be able to manage

# Billing
1. Storage
   1. Current Data Storage
   2. Time Travel Retention
   3. Fail-Safe
   4. Internal Stages
   5. Flat rate per TB
2. Virtual Warehouses
   1. SMALL - 2 
   2. MEDIUM - 4
   3. LARGE - 8
   4. XLARGE - 16
   5. XXLARGE - 32

# Data Types
1. Array
   1. 0 or more elements of data, each element accessed by its position
   2. ARRAY_CONSTRUCT('Writing','Tennis','Math')
2. OBJECT() ... collections of key-value pairs
   1. OBJECT_CONSTRUCT('postcode','TY5 7NN','first_line','67 Southway Road')
3. VARIANT ... universal semi-structured data type for arbitrary data structures
   1. 16 MB compressed per row limit
   2. dot notation ... double colon for first level element and then dot for all lower level elements
      1. src:employee.name
   3. Bracket notation 
      1. SRC['employee']['name']
   4. List elements 
      1. src:employee.skills[0]
   5. Casting semi-structured data
      1. shorthand double colon
         1. src:employee.joined_on::DATE
4. Formats
   1. CSV
   2. JSON
      1. ELT approach load into a single variant column
      2. ETL approach extract keys from json into different columns
      3. Automatic Schema Detection
         1. INFER_SCHEMA
         2. MATCH_BY_COLUMN_NAME
            1. Needs to match exactly with or without case sensitivity
      4. Copy Options
         1. STRIP_OUTER_BRACKETS ... flattens the outer list if there is one
   3. AVRO ... hadoop
   4. ORC ... hive
   5. PARQUET
   6. XLM
   7. Only 1,2,5 support unload
5. Functions
   1. PARSE_JSON ... parse json string into variant object
   2. LATERAL FLATTEN
      1. ```
            SELECT
            src:employee.name,
            src:employee._id,
            f.value
            FROM EMPLOYEE e,
            LATERAL FLATTEN(INPUT => e.src:skills) f;
         ```
   3. FLATTEN
    4.   Nested data structure and explodes / flatten
    5.   SEQ, KEY, PATH, INDEX, VALUE, THIS
    6.   1, NULL, 0, 0, 1, [1,45,34]
    7.   1, NULL, [1],1, 45, [1,45,34]
    8.   RECURSIVELY option for lower level elements or false flatten first level elements only 
   4. GET
   5. AS_VARCHAR

# Export and Load
1. Example code
```
COPY INTO @MY_STAGE/RESULT/DATA_
FROM (SELECT * FROM T1)
FILE_FORMAT = MY_CSV_FILE_FORMAT;

COPY INTO @%T1
FROM T1
PARTITION BY ('DATE=' || TO_VARCHAR(DT))
FILE_FORMAT=MY_CSV_FILE_FORMAT;
```

2. Copy options
   1. OVERWRITE default 'ABORT_STATEMENT' ... boolean whether or not COPY command overwrite existing files with matching names
   2. SINGLE default FALSE ... boolean generate single or multiple files
   3. MAX_FILE_SIZE default 16 MB
   4. INCLUDE_QUERY_ID ... boolean include UUID in filename or not

## File Formats
1. Can be applied to stages, copy into statement, or table, copy into takes precedent then table then stage
2. csv
   1. COMPRESSION
   2. FIELD_OPTIONALLY_ENCLOSED_BY default "NONE"
   3. REPLACE_INVALID_CHARACTERS default false
   4. SKIP_BLANK_LINES default false
   5. SKIP_HEADER default 0
   6. TYPE default "CSV"

## Load
```
COPY INTO 'S3://MYBUCKET/UNLOAD/'
FROM T1
STORAGE_INTEGRATION = MY_INT
FILE_FORMAT=MY_CSV_FILE_FORMAT;
```

### Non Snowpipe
1. Insert 
   1. Insert from select statement
   2. Insert values statement
2. UI file load
3. Copy INTO <table> / Bulk Loading
   1. Transformations
      1. Column reordering
      2. Column omission
      3. Casting
      4. Truncate, Enforce length
   2. Number of columns in select must match number of columns in table
   3. Copy options
      1. ON_ERROR
         1. Default ABORT_STATEMENT
         2. CONTINUE
         3. SKIP_FILE
         4. SKIP_FILE_<num>
         5. SKIP_FILE_<num>%
      2. PURGE ... boolean to remove data file from stage automatically after load
      3. SIZE_LIMIT default null
      4. ENFORCE_LENGTH default true
      5. FORCE default FALSE .. boolean to load duplicate filenames with same contents
   4. Copy validations
      1. VALIDATION_MODE dry run
         1. RETURN_ROWS
         2. RETURN_N_ROWS
         3. RETURN_ERRORS
         4. RETURN_ALL_ERRORS
      2. VALIDATE table function takes job id as parameter

### Snowpipe
1. Intended for many small files quickly and frequently
2. Serverless feature not requireing a VW
3. Can be paused and resumed using ALTER PIPE command
4. Snowpipe load history is stored for 14 days to prevent reloading
5. PIPE
   1. AUTOINGEST = TRUE ... Snowpipe with cloud messaging (e.g. AWS SQS)
   2. AUTOINGEST = FALSE ... Send API call to Snowflake yourself
6. Versus bulk loading
   1. Authentication ... requires JWT for REST endpoints (json web token) vs security options supported by client for user session
   2. Load history ... 14 days vs 64 days
   3. Compute resources ... Snowflake serverless vs VW
   4. Billing ... per-second/per-core granularity and overhead 0.06 credits per 1000 files vs VW active time
7. Best practices
   1. 100-250 MB compressed
   2. IF > 100 GB should be split
   3. Organize Data by path (date, other low to medium cardinality grouping)
   4. Seperate VW for Load, Transform, Analytics
   5. Pre-sort data
   6. Once per minute frequency at the fastest
   
### Stages
1. table stage for 1 table load only
2. Internal stages ... area to temporarily store data used in data loading process
   1. User stage
      1. PUT and GET command
      2. ls @~;
      3. Cannot be altered or dropped
      4. User specific and access cannot be granted
   2. Table stage
      1. PUT and GET command
      2. ls @%MY_TABLE
      3. Cannot be altered or dropped
      4. User must have ownership privileges on table
   3. Named stage
      1. User created database object
      2. PUT and GET command
      3. ls @MY_STAGE
      4. Securable object, privileges can be granted
   4. Automatically gzipped
3. External stages
   1. Named stages
      1. Cloud Utilities
      2. ls @MY_STAGE
      3. Storage location can be private or public
   2. Code Example
      1. 
        ```
        CREATE STAGE MY_EXT_STAGE
        URL='S3://MY_BUCKET/PATH/'
        STORAGE_INTEGRATION = MY_INT;

        CREATE STORAGE INTEGRATION MY_INT
        TYPE=EXTERNAL_STAGE
        STORAGE_PROVIDER=S3
        STORAGE_AWS_ROLE_ARN=‘ARN:AWS:IAM::98765:ROLE/MY_ROLE’
        ENABLED=TRUE
        STORAGE_ALLOWED_LOCATIONS=(‘S3://MY_BUCKET/PATH/’);
        ```
4. Stage Helper Commands
   1. LIST
      1. lists contents of stages
   2. SELECT
      1. metadata$filename, metadata$file_row_number
   3. SHOW
      1. lists stages
   4. REMOVE
5. PUT
   1. Cannot be executed within worksheets
   2. Duplicate files are ignored by default
   3. Uploaded files are automatically encrypted with 128-bit key
6. Directory tables
   1. Queryable dataset with file_url to staged files
   2. ALTER STAGE <stage_HERE> REFRESH is needed to make existing files available immediately
7. File Support REST API
   1. GET /api/files
      1. Either scoped url or file url, not presigned url

# Performance 

## Caching
1. Metadata Cache / Metadata Store
   1. SELECT COUNT(*) FROM MY_TABLE
   2. SELECT SYSTEM$WHITELIST() -- system functions
   3. SELECT CURRENT_DATABASE() -- context functions
   4. DESCRIBE TABLE MY_TABLE
   5. SHOW TABLES
2. Results Cache ...  Query result cache ... Result Cache
   1. Exact match to previous query
   2. Underlying table data is not changed
   3. Same role is used
   4. No time context function like CURRENT_TIME() are used
   5. no UDF is used
   6. no reclustering has been done
   7. Can be disabled in session parameter USE_CACHED_RESULT
3. Warehouse cache / SSD cache / Data Cache / Raw Data Cache
   1. Purged when VW is resized, suspended, or dropped
   2. Does not need exact query match

## Clustering
1. Default clustering by order of loading
2. Can be clustered on expression like date functions to reduce column cardinality
3. Clustering reorganizes micro partitions or rather updates metadata referencing micropartitions
4. Example clustering by alphabetical order
5. Clustering metadata
6. system$clustring_information Attributes
   1. total_partition_count ... Total number of micro partitions
   2. total_constant_partition_count ... number of micro-partitions for which value of specified column have reached a constant state, no more benefits from reclustering
      1. higher is better
   3. average_overlaps 
      1. lower is better
   4. average_depth
      1. lower is better (need to consider reclustering between 5 - 100 and size of table)
   5. Automatic clustering
      1. Not started immediately, only if it will benefit from operation
      2. alter table suspend OR resume recluster
   6. Once > 1TB
   7. Infrequent updates
   8.  The correct clustering key (max 3-4)
   9.  Lower cardinality first
   10. Shouldn't be too low cardinality or there are not much benefits like < 10 (binary values)
   11. Should be extreme high cardinality or not much benefits (like timstamps)

## History
1. History Tab
   1. Last 14 days only
   2. Can view others queries but not results
   3. Filters
      1. Long running queries
      2. Failed queries
      3. Query duration
      4. Bytes scanned
      5. Rows
   4. Query Details (shows results for owned queries)
      1. Execution Plan Tree. The Execution Plan Tree (or Execution Graph) in the Query Profile displays each step or operator in the query execution plan, along with metrics such as execution time and resource usage.
   5. Query Profile (EXPLAIN command)
2. Query History 
   1. Tables and Views
      1. ACCOUNT_USAGE.QUERY_HISTORY
   2. Query history pane
      1. Provides a high-level summary of query executions (such as start time, duration, and status) 
3. Query profile
4. Query Compilation Metrics
   1. Query Compilation Metrics focus solely on the time spent during the query compilation phase. They do not offer insights into the execution phase, where the operator-level details are crucial for identifying performance bottlenecks.

## Search Optimization Service
1. Turned on at table level
2. Requires ownership of table or ADD SEARCH OPTIMIZATION privilege on schema level
3. Serverless feature incurs additional compute and storage costs
4. Speed benefits on = or IN SQL operator filters
   1.  selective point lookups

## Tuning
1. Rows > Groups > Result
2. (FROM > JOIN > WHERE) > (GROUP BY > HAVING) > (SELECT > DISTINCT > ORDER BY > LIMIT)
3. Troubleshooting
   1. Join Explosion ... meant to be 1 to 1 but ends up being 1 to many ... Query profile operator tree will show the difference in rows returned
      1. When base table is joined to type 2 changing dimension table naively
         1. Join by a unique id
         2. Join by understanding table relationship and getting only the most up to date row
   2. Order by with no limit
      1. Limiting results will improve performance significantly
      2. Shows up in Profile Overview as Bytes spilled to local storage
   3. Order by in lower level selects
   4. Group by high cardinality
      1. Aggregate operator takes too much time
   5. Spilling from various causes
      1. In memory > local disk > remote disk 
      2. Solutions
         1. Process less data (where clause)
         2. Increase virtual warehouse size for in memory
         3. Larger local disk

# Security
1. hierarchical key model rooted in a hardware key

## Account Usage
1. Use cases
   1.  Credits use by warehouse
   2. How many queries executed in past hour
2. ~2 hour latency ... 45 -180 minutes
3. Retention period is 1 year

## Column level security (Governance)
1. Masking policies 
```
CREATE MASKING POLICY EMAIL_MASK AS (VAL STRING) RETURNS STRING ->
CASE
WHEN CURRENT_ROLE() IN (‘SUPPORT’) THEN VAL
WHEN CURRENT_ROLE() IN (‘ANALYST’) THEN REGEXP_REPLACE(VAL,'.+\@','*****@’)
WHEN CURRENT_ROLE() IN (‘HR’) THEN SHA2(VAL)
WHEN CURRENT_ROLE() IN (‘SALES’) THEN MASK_UDF(VAL)
WHEN CURRENT_ROLE() IN (‘FINANCE’) THEN OBJECT_INSERT(VAL, 'USER_EMAIL', '*', TRUE) -- value to replace, key, value, update boolean

ALTER TABLE IF EXISTS EMP_INFO MODIFY COLUMN USER_EMAIL SET MASKING POLICY EMAIL_MASK;
```
   1. Applied wherever column is reference in SQL statement
   2. Can be nested, existing in tables and views that reference source tables
   3. Masking policies are independent of object owners
2. External Tokenization
   1. Not even snowflake or cloud platform can read without external detokenization API

## Encryption
1. Tri-secret secure ... compositive encryption key made up of a user provider key and a snowflake key
2. Encryption at rest
   1. AES-256 strong encryption on Table data and internal stage data
3. Encryption in transit
   1. HTTPS TLS 1.2 via ODBC, JDBC, Web UI, SnowSQL
4. Hierarchical key model using AWS CloudHSM (hardware security module)
   1. Root > Account Master > Table Master > File Key
   2. Key rotation
   3. Periodic Re-Keying

## Information Schema
1. SQL-92 ANSI Information Schema
2. Meta data for all database objects
3. Versus Account Usage Schema
   1. Does not include dropped objects
   2. No latency vs 45 - 180 minutes
   3. retention of historical data 7 days - 6 months (most often 7-14 days) vs 1 year
4. Common tables and views
   1. TABLE_STORAGE_METRICS view
      1. table level storage utilization used to calculate storage billing
         1. contains information about deleted tables still viable for use in time travel or fail safe
      2. compression ratios 
      3. partitioning

## Object Tagging (Governance)
1. Use case
   1. Business Unit tags
      1. HR, Sales, Operations ... can be across different parts of object hierarchy
   2. PII Tags
2. TAG_ADMIN is recommended to create and use

## Row Access Policies (Governance)
1. Row Access Policy
```
CREATE OR REPLACE ROW ACCESS POLICY RAP_ID AS (ACC_ID VARCHAR) RETURNS BOOLEAN ->
CASE
WHEN 'ADMIN' = CURRENT_ROLE() THEN TRUE
ELSE FALSE
END;

ALTER TABLE ACCOUNTS ADD ROW ACCESS POLICY RAP_IT ON (ACC_ID);
```

## Secure Views
1. All view types can be secured
2. DDL is restricted to only the object owner, denies inference attacks

# Sharing

## Exchange
1. Not available to VPS uses secure data sharing under the hood
2. Snowflake request
3. Think of it as a private marketplace

## Marketplace
1. Standard listing
2. Personalized listing
   1. Providers can charge for data

## Secure Data Sharing
1. Data provider only pays for storage, Data consumer pays only for compute
2. Share supports
   1. objects
      1. Tables
      2. External tables
      3. Secure view
      4. Secure materialized views
      5. Secure UDFs
   2. 1 database per share
   3. no limits on number of shares
3. Share limitations
   1. No future privileges
   2. Share must be in same data region, else replication must be used
   3. No time travel or cloning
   4. No resharing to other consumers
   5. No object creation inside shared database
4. VPS does not support
5. Snowflake reader accounts
   1. cannot insert or copy data into account
   2. 1 provider account per reader account
   3. provider accounts take responsibility for read account costs

# Storage

## Cloning
1. Cloneable objects
   1. Databases (usage)
   2. Schemas (usage)
   3. Tables (select privs)
   4. Streams (ownership privs)
   5. Stages (usage)
      1. Cannot clone internal named stages individually, only as part of larger container object (in this case you need to enable directory table, refresh directory table, and include internal stages option in clone schema/database statement)
   6. File Formats (usage)
   7. Sequences (usage)
   8. Tasks (ownership privs)
   9.  Pipes (reference external stage only, ownership privs)
2.  Zero copy cloning
    1.  Metadata stored only referencing existing micro partitions
3.  Does not retain privileges of the source object with exception of tables
4.  Cloning is recursive for databases and schemas
5.  External tables and internal named stages are never cloned
6.  Cloned table does not contain the load history of the source table
7.  temporary and transient tables cannot be cloned as permanent tables
8.  CLONE with Time travel is useful for retrieving lost or uncorrupted data


## Fail-safe
1. Copy of data for 7 days and require Snowflake request to restore

## Micropartition
1. Immutable
2. 50-500 MB of uncompressed data
3. write once, read many
4. Pruning based on MIN, MAX from micropartition metadata
5. Insert statement can add micro-partitions without locking existing micro-partitions

## Replication
1. Between account
2. Data is physically copied and moved
3. Not replicated ... external tables, event tables, temporary stages, class instances
   1. Will result in error
4. Refresh can e automated by configuring a task
5. Privileges not replicated

## Time Travel
1. DATA_RETENTION_TIME_IN_DAYS -- ACCOUNT, DATABASE, SCHEMA, or TABLE level with child level taking precedence
2. Default 1, Enterprise or Higher editions up to 90 days
3. 0 or 1 for temporary or transient
4. AT keyword
   1. TIMESTAMP, OFFSET, STATEMENT
5. BEFORE
   1. STATEMENT
6. UNDROP 
   1. named object must not have been recreated before undrop


# Transformations

1. Returns one value per vcall
2. Categories of functions
   1. Aggregate
      1. AVG()
      2. COUNT()
      3. SUM()
      4. MAX()
      5. MIN()
   2. Data Generation
      1. UUID_STRING()
   3. Estimation
      1. HLL() -- hyperloglog, APPROX_COUNT_DISTINCT()
         1. Alternative to COUNT DISTINCT
      2. Similarity
         1. Run MINHASH(K, <col_1>) -- K max 1024
         2. Run APROXIMATE_SIMILARITY(MH) from MINHASH union between two tables
         3. Alternative to Jaccard Similarity Coefficient (Needs intersect and unions between 2 sets)
      3. Frequency
         1. APPROX_TOP_K
            1. APPROX_TOP_K(<input_col>, <num_values>, <max_distinct_parameter>>)
            2. Alternative to group by
      4. Percentile Estimation
         1. APPROX_PERCENTILE -- implemented t-digest algorithm
   4. ETL
      1. VALIDATE ... views all error encountered during a previous copy into execution
   5. File
      1. build_scoped_file_url( @<stage_name> , '<relative_file_path>') -- 24 hours only
      2. SELECT build_stage_file_url(@images_stage, 'prod_z1c.jpg');
      3. GET_PRESIGNED_URL
         1. Like others but manually set expiration on data access
         2. Use case presenting pdf links with metadata
      4. Troubleshooting
         1. All require privileges on associated stage
         2. Set server side encryption ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
   6. System
      1. system$cancel_query
      2. system$clustering_depth
      3. system$clustering_information
      4. system$json_explain_plan
      5. system$pipe_status
   7. Table 
      1. TABLE(GENERATOR(ROWCOUNT => 3))
   8. Table Sampling
      1. Fraction-based 
         1. SELECT * FROM LINEITEM TABLESAMPLE/SAMPLE [samplingMethod] (<probability>); 
         2. SELECT * FROM LINEITEM SAMPLE BERNOULLI/ROW (50);
      2. Block size less random, more efficient for large datasets since at micro partition level
         1. SELECT * FROM LINEITEM SAMPLE SYSTEM/BLOCK (50); 
      3. Deterministic sampling ... SELECT * FROM LINEITEM SAMPLE (50) REPEATABLE/SEED (765);  
      4. Fixed size
         1. SELECT * FROM LINEITEM TABLESAMPLE/SAMPLE (<num> ROWS);
         2. SELECT L_TAX, L_SHIPMODE FROM LINEITEM SAMPLE BERNOULLI/ROW (3 rows);
   9.  Window
      1. MAX(col<A>) OVER(PARTITION BY <colB> ORDER BY <colC>)


# Virtual Warehouse 
1. Named abstraction for MPP (Massively parallel processing) compute clusters
2. States
   1. Started ... default when VW is created
   2. Suspended
   3. Resizing
3. Properties
   1. auto_suspend
      1. 5 to 10 minute suggestion. Cons of cleared cache (makes future queries slower), also possibly multiple start and stops requiring at least 60 seconds each
   2. auto_resume
   3. initially_suspended
4. T shirt sizes XS - XXXXL

## Resource Monitors
```
CREATE RESOURCE MONITOR ANALYSIS_RM
WITH CREDIT_QUOTA=100
FREQUENCY=MONTHLY
START_TIMESTAMP=‘2023-01-04 00:00 GMT'
TRIGGERS ON 50 PERCENT DO NOTIFY
ON 75 PERCENT DO NOTIFY
ON 95 PERCENT DO SUSPEND
ON 100 PERCENT DO SUSPEND_IMMEDIATE;

ALTER ACCOUNT SET RESOURCE_MONITOR = ANALYSIS_RM; -- or single virtual warehouse 
```
1. Account admin only

## Scaling
1. Scaling up/down by increasing warehouse_size
   1. Current queries complete on current resources, thus are not affected by scaling up/down
2. Scaling out by adding clusters 
   1. MIN_CLUSTER_COUNT
   2. MAX_CLUSTER_COUNT
   3. Maximized mode when MIN and MAX are same
   4. Auto scale mode when MIN is < MAX
      1. Standard Scaling Policy
         1. If query is queued, new cluster is started
         2. Every minute if query can be moved to another cluster, current cluster will rebalance
         3. If additional cluster idle for > 2 consecutive 1 minute checks, it is shut down
      2. Economic Scaling Policy
         1. If busy enough for 6 minutes, new cluster will start
         2. If additional cluster idle for > 6 consecutive 1 minute checks, it is shut down
3. Query Acceleration Service (QAS)
   1. Eligibility
      1. Part of query plan can be run in parallel (scan with an aggregate)
      2. Number of partitions to be scanned
      3. QUERY_ACCELERATION_ELIGIBLE_VIEW or SYSTEM$ESTIMATE_QUERY_ACCELERATION (provide previous executed query id)
   2. Examples
      1. ```
        CREATE WAREHOUSE my_wh with ENABLE_QUERY_ACCELERATION = true;
        ALTER WAREHOUSE my_wh SET ENABLE_QUERY_ACCELERATION = true;
        CREATE OR REPLACE WAREHOUSE my_wh WITH 
            ENABLE_QUERY_ACCELERATION = true
            QUERY_ACCELERATION_MAX_SCALE_FACTOR = 3
            WAREHOUSE_SIZE = SMALL;
        ```
   3. Does not actually scale up the warehouse only temporarily leases
>>>>>>> f21ba349a9b90dc738db9ff09c3a91ae6f5b3a9f
