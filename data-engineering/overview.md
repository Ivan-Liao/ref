- [Data Modeling](#data-modeling)
- [Security](#security)
- [Sources](#sources)
- [Storage](#storage)
- [Streaming / Near Real Time](#streaming--near-real-time)
- [Transformation](#transformation)
- [Trends](#trends)

# Data Modeling
Here are the 20 most important concepts for data modeling in the context of data engineering, with detailed descriptions.

1. Data Vault Modeling is a hybrid data modeling methodology designed for enterprise data warehousing that combines aspects of both the normalized model (3NF) and the dimensional model (star schema). It was developed by Dan Linstedt to address the challenges of agility, flexibility, and scalability in traditional data warehousing. A Data Vault model is designed to be resilient to changes in source systems and business requirements, making it particularly well-suited for environments where the data landscape is complex and constantly evolving. The model is built on three core types of tables:
   1. Hubs: Hubs contain a distinct list of business keys for a single business entity (e.g., customer_id, product_sku). They represent the core business concepts and are designed to be extremely stable. A hub typically contains only the business key, a surrogate key (the Hub key), and metadata columns like a load timestamp and record source.
   2. Links: Links establish the relationships or transactions between two or more hubs. They are essentially many-to-many join tables that capture the associations between business entities. For example, a Link_Purchase table would connect a Hub_Customer and a Hub_Product, containing only the surrogate keys from each hub and metadata.
   3. Satellites: Satellites store all the descriptive, contextual attributes of a hub or a link. Unlike a dimension table in a star schema, a satellite holds attributes that change over time, and it captures this history. If a new source system provides more attributes about a customer, a new satellite table can be added without altering the existing structure. This makes the model highly extensible.
   4. The Data Vault architecture creates a raw, integrated data layer (the "Raw Vault") that is highly normalized and focused on auditability and historical tracking. This layer serves as a stable foundation. For business reporting and analytics, data is then loaded from the Raw Vault into downstream data marts, which are typically modeled as star schemas. This separation of concerns is a key advantage. The Data Vault provides a flexible, scalable, and auditable integration layer, while the star schema provides a user-friendly, high-performance query layer. For data engineers, Data Vault offers a robust framework for building an enterprise data warehouse that can easily adapt to new data sources and changing business rules without requiring massive re-engineering of the core model.
2. Dimensional Modeling
   1. Dimensions
      1. Dimension tables contain the descriptive, contextual attributes that define the facts. They answer the "who, what, where, when, why, and how" questions related to a business event. For example, dimensions for a sales fact could include Customer, Product, Date, and Store. These tables are typically shallow (fewer rows) but wide (many columns).
      2. dimensional models are intentionally denormalized to enhance read performance.
      3. For example, dimension tables could be Dim_Customer, Dim_Product, Dim_Date, and Dim_Store. Dim_Customer would contain attributes like customer_name, age_group, and city, while Dim_Product would have product_name, brand, and category.
      4. Slowly Changing Dimensions (SCDs)
         1. SCD Type 1
            1. Overwrite. This is the simplest approach. When an attribute changes, the old value in the dimension table is simply overwritten with the new value. For example, if a customer moves from New York to California, their city attribute is updated. This method is easy to implement but provides no historical tracking. All past facts associated with that customer will now appear as if they occurred in California, which erases the historical context. It's suitable for correcting errors or when historical tracking is not required.
         2. SCD Type 2
            1. Add New Row. This is the most common and powerful SCD technique for historical tracking. Instead of overwriting the existing record, a new row is added to the dimension table to represent the new state of the entity. The original row is preserved but marked as no longer current. To manage this, the dimension table typically includes additional columns like start_date, end_date, and a is_current flag. For example, when the customer moves, their original record's end_date is updated to the move date and its is_current flag is set to false. A new record is created with the new address, a start_date of the move date, and an is_current flag set to true. This allows historical queries to accurately link facts to the dimensional attributes that were valid at the time the fact occurred.
         3. SCD Type 3
            1. Add New Attribute. This approach tracks a limited amount of history by adding a new column to the dimension table. For instance, to track a customer's move, you might add previous_city and current_city columns. When the customer moves, the value in current_city is copied to previous_city, and the new city is placed in current_city. This method is simpler than Type 2 but can only track one historical change and is not easily scalable for tracking multiple changes.
   2. Facts
      1. Fact tables contain the quantitative measurements or metrics of a business process, such as sales amount, quantity sold, or profit margin. These tables tend to be deep (many rows) and narrow (few columns). The records in a fact table are called "facts" and are typically numeric and additive.
      2. selecting the business process
      3. declaring the grain
      4. Transactional Fact Tables: These are the most common type, where each row corresponds to a single event or transaction at a specific point in time. The grain is usually very fine.
         1.  For example, in a retail sales data model, the fact table might contain metrics like sales_amount, quantity_sold, and cost_of_goods. Each row in the fact table corresponds to a specific event or transaction and contains foreign keys that link to the surrounding dimension tables.
      5. Periodic Snapshot Fact Tables: These tables capture the state of things at predefined, regular intervals (e.g., daily, weekly, monthly). A common example is a daily inventory level or a monthly account balance.
      6. Accumulating Snapshot Fact Tables: These tables represent the lifecycle of a process with a well-defined beginning and end, such as order fulfillment or a claims process. The row for a given process is updated as it passes through various milestones.
   3. Star Schema
      1. The Star Schema is the most fundamental and widely used structure in dimensional modeling. It is named for its star-like appearance when visualized, with a central fact table connected to a number of dimension tables. 
   4. Snowflake Schema
      1. The defining characteristic of a snowflake schema is that its dimension tables are normalized. While a star schema features denormalized dimension tables, a snowflake schema breaks down these dimension tables into further, smaller tables. For example, in a star schema, a Dim_Product dimension table might contain columns for product_name, brand, category, and subcategory. In a snowflake schema, the product dimension would be normalized. There would be a main Dim_Product table with a foreign key to a separate Dim_Category table. The Dim_Category table might then have a foreign key to a Dim_Department table. This creates a chain of related dimension tables, radiating out from the main dimension table, which itself is connected to the central fact table. The primary motivation for using a snowflake schema is to reduce data redundancy and save storage space.
3. Denormalization
   1. Denormalization is the strategic process of introducing redundancy into a database by combining tables or adding duplicate data, with the primary goal of improving query performance. It is the inverse of normalization. While normalization is essential for write-intensive Online Transaction Processing (OLTP) systems to ensure data integrity and eliminate redundancy, it often results in a large number of tables. Querying such a database for analytical purposes can require complex and resource-intensive joins across many tables, leading to slow performance. This is where denormalization becomes critical, especially in the context of Online Analytical Processing (OLAP) and data warehousing. By deliberately violating some rules of normalization, data engineers can create a data model that is optimized for read operations. A common denormalization technique is pre-joining tables. For instance, instead of joining a Products table with a Categories table at query time to get the category name, a denormalized Products table might include a category_name column directly. This eliminates the need for a join, drastically speeding up queries that need this information. Other techniques include adding calculated values (e.g., storing total_price in an order items table instead of calculating it from quantity and unit_price every time) or creating summary tables that store pre-aggregated data. The trade-off is clear: read performance is gained at the expense of storage space and data consistency challenges. When the source data is updated, all redundant copies must also be updated, which introduces complexity into the data loading (ETL/ELT) process and increases the risk of data anomalies if not managed carefully. For data engineers, mastering denormalization is about striking a balance—understanding the query patterns of end-users and selectively denormalizing parts of the data model to meet performance requirements without excessively compromising data integrity
4. Entity-Relationship Diagram (ERD) 
   1. The Entity-Relationship (ER) Diagram is a conceptual framework used to design and visualize databases.  The model is built on three core components: entities, attributes, and relationships. An entity represents a real-world object or concept that is distinguishable from others, such as a Customer, Product, or Order. Each entity has attributes, which are the properties or characteristics that describe it, like a Customer's name, email, and address. A relationship defines how two or more entities are associated with each other, such as the "places" relationship between a Customer and an Order. These relationships have cardinality, which specifies the number of instances of one entity that can be related to instances of another entity (e.g., one-to-one, one-to-many, many-to-many). 
5. (Data) Governance and Master Data Management (MDM)
   1. Data Governance is a comprehensive framework of rules, processes, standards, and metrics that ensures the effective and efficient use of information in enabling an organization to achieve its goals. It establishes who is responsible for data, what can be done with it, and how it should be handled. In the context of data modeling, data governance provides the essential guardrails that ensure data models are built consistently, securely, and in alignment with business objectives. It addresses critical questions like: Who owns the Customer data? What is the official definition of "Active Customer"? What are the data quality standards for product information? A key component of data governance is Master Data Management (MDM). Master data is the critical, core data of an organization that describes its business entities, such as customers, products, suppliers, and locations. MDM is the discipline and technology-enabled practice of creating and maintaining a single, unified, and trusted source of this master data—often called the "single source of truth" or "golden record." For example, a customer's information might exist in a CRM system, a billing system, and a marketing platform, potentially with conflicting details. An MDM system consolidates these records, resolves conflicts through a set of rules, and creates a single master record for that customer. 
6. Granularity
   1. Granularity refers to the level of detail or precision captured in each record. For example, the grain of a retail sales fact table could be "one row per product line item on a customer's receipt." This means each record will represent a single product being sold in a single transaction. A different, "coarser" grain might be "one row per customer's total daily purchases at a store," which would aggregate all of a customer's transactions for that day into a single fact record. The major drawback is the loss of detail. With a daily summary grain, it would be impossible to analyze purchasing patterns within a single day or to see which products were bought together in the same basket. The best practice, as advocated by Ralph Kimball, is to always capture data at the lowest, most atomic grain possible. This provides maximum flexibility for future analysis. If performance for summary-level queries becomes an issue, aggregated summary tables (a form of denormalization) can be created from the fine-grained base data, providing the best of both worlds.
7. Idempotency is a crucial property of data processing operations, particularly within the context of data engineering pipelines (ETL/ELT). An operation is considered idempotent if running it multiple times with the same input produces the same result as running it just once. In other words, after the first successful execution, subsequent executions have no further effect on the state of the system. This concept is vital for building robust, reliable, and fault-tolerant data pipelines. Data pipelines are often complex and run in distributed environments where failures are inevitable. A network issue, a temporary node failure, or a bug could cause a pipeline job to fail midway through its execution. Without idempotency, re-running the failed job could lead to severe data corruption. For example, consider a simple pipeline that aggregates daily sales data and inserts the total into a summary table. If this pipeline is not idempotent, re-running it after a failure would insert a duplicate summary record, causing all downstream reports to be incorrect (e.g., double-counting sales). An idempotent design would instead use an "upsert" (update or insert) operation: it would check if a record for that day already exists. 
8. Normalization
   1. Normalization is the process of organizing the columns (attributes) and tables (entities) of a relational database to minimize data redundancy and improve data integrity. The primary goal is to isolate data so that additions, deletions, and modifications of a field can be made in just one table and then propagated through the rest of the database via defined relationships. This process involves dividing larger tables into smaller, well-structured tables and defining relationships between them. 
   2. The most common normal forms are:
      1. First Normal Form (1NF): Ensures that table cells hold single, atomic values and each record is unique, typically by having a primary key. It eliminates repeating groups within a single row.
         1. Address is divisible so Address column would need to be Street, City, State instead
         2. Multiple products purchased would be split into one row per product purchased associated with orderID
      2. Second Normal Form (2NF): Requires the table to be in 1NF and mandates that all non-key attributes must be fully functionally dependent on the entire primary key. This is relevant for tables with composite primary keys and aims to remove partial dependencies.
         1. Composite order key customerID and productID would be split into a customer table, product table, and order table with a unique identifier created for the order table
      3. Third Normal Form (3NF): Requires the table to be in 2NF and ensures that all attributes are dependent only on the primary key, not on other non-key attributes. This step eliminates transitive dependencies.  For most Online Transaction Processing (OLTP) systems, achieving 3NF is the standard goal. It creates a highly efficient and logical database design that prevents data anomalies. For example, without normalization, changing a customer's address might require updating multiple records in an order table, risking inconsistency if one record is missed. With a normalized design, the address is stored once in a Customers table and linked to orders via a customer ID, ensuring a single point of update.
         1. City may depend on ZipCode so a seperate Address table can be created
9.  NoSQL Data Models
   1. Document Model: Data is stored in semi-structured documents, most commonly in JSON or BSON format. Each document is a self-contained structure of key-value pairs and can be nested. This model is very intuitive for developers as it maps closely to objects in programming languages. It's highly flexible, as each document can have a different structure. Use cases: Content management systems, e-commerce platforms, user profiles. Examples: MongoDB, Couchbase.
   2. Key-Value Model: This is the simplest NoSQL model. Data is stored as a collection of key-value pairs. The key is a unique identifier, and the value can be anything from a simple string or number to a complex object (like a JSON document). The database does not inspect the value; it simply stores and retrieves it. This model offers extremely high performance for simple lookups. Use cases: Caching, session management, real-time bidding. Examples: Redis, Amazon DynamoDB.
   3. Column-Family (or Wide-Column) Model: Data is stored in tables with rows and columns, but with a twist. The names and format of the columns can vary from row to row within the same table. These databases are designed to store massive amounts of data distributed across many servers. They are optimized for queries over large datasets by storing data in column families rather than rows, which makes aggregations on a specific column very fast. Use cases: Big data analytics, logging, time-series data. Examples: Apache Cassandra, Google Bigtable, Apache HBase.
   4. Graph Model: This model is designed specifically to store and navigate relationships between entities. Data is represented as a network of nodes (entities), edges (relationships), and properties (attributes of nodes and edges). Graph databases excel at traversing complex, interconnected data and answering questions like "find all friends of my friends who live in my city" or "what is the shortest path between two points in a network?". Use cases: Social networks, recommendation engines, fraud detection. Examples: Neo4j, Amazon Neptune.
10. OLTP vs. OLAP
   1. OLTP (Online Transaction Processing) and OLAP (Online Analytical Processing) are two distinct types of data processing systems whose different purposes fundamentally drive data model design. OLTP systems are designed to manage and process a large number of short, atomic transactions in real-time. Think of the applications that run day-to-day business operations: ATM withdrawals, e-commerce order entry, flight reservations, or inventory management. The primary goals of OLTP systems are high throughput, fast response times for read/write operations, and maintaining data integrity and consistency. The data models for OLTP systems are highly normalized (typically to 3NF) and based on the Entity-Relationship (ER) model. Normalization minimizes data redundancy, which prevents data anomalies and makes write operations (inserts, updates, deletes) extremely efficient and reliable. Queries are typically simple, affecting only a few records at a time (e.g., "retrieve the status of order #123"). OLAP systems, on the other hand, are designed for complex analytical queries and business intelligence. These systems allow users to analyze large volumes of historical data from multiple perspectives. Think of a business analyst trying to understand sales trends across different regions, products, and time periods. The primary goals of OLAP systems are fast query performance for large aggregations and enabling multidimensional analysis (slicing, dicing, drilling down). The data models for OLAP systems are highly denormalized and are based on dimensional modeling (e.g., star or snowflake schemas).
   2. Vector database
11. Validation
   1. Referential Integrity (foreign key exists in associated entity table)
   2. Entity Integrity (no null primary key)

# Security
1. Redaction methods
   1. Manually filter or delete sensitive columns (columns name may not be specific, comments/notes columns may contain sensitive info)
   2. Regular expressions (tedious and less accurate)
   3. Fuzzy matching
   4. Services
      1. Google DLP API

# Sources
1. S3 path
2. https://raw.githubusercontent.com

# Storage
1. Cache / Real Time
2. Data Lake
   1. Tools
      1. AWS S3
      2. Azure Blob
      3. GCP GCS (Google Cloud Storage)
   2. Formats
      1. csv
      2. json
      3. parquet
      4. image (binary, .png, .jpg)
      5. audio (.wav, .mp3)
3. Document
   1. Tools
      1. MongoDB
      2. Firestore (Google)
      3. DynamoDB (AWS)
      4. CouchDB (Apache)
   2. Uses
      1. Apps
      2. Games
      3. IOT
   3. Documents grouped in collections and sub collections
   4. No joins
   5. Fast reads, slow writes
4. Graph
   1. Tools
      1. neo4j
      2. Dgraph
   2. Uses
      1.   Fraud detection
      2.   Internal Knowledge Graph
      3.   Recommendation Engine
      4.   Reduces complex joins
5. Key-Value 
   1. Tools
      1. Redis
      2. Memcached
   2. Uses
      1. Caching
      2. Pub/Sub
      3. Leaderboards
6. Relational
   1. Tools
      1. MySQL
      2. Postgres
      3. SQL Server
   2. Uses
      1. Analytical
   3. ACID compliant
      1. atomicity, consistency,  isolation, durability
   4. Sharding when larger database is sharded into smaller, faster, manageable chunks by rows
7. Search
   1. Tools
      1. Elasticsearch
      2. Algolia
      3. Meilisearch
   2. Uses
      1. Search
   3. Like document db but creates an index
8. Wide Column
   1. Tools
      1. Cassandra
      2. Apacha Hbase
   2. Uses
      1. Time-series
      2. Historical records
      3. high-write, low-read
   3. Rows with key and column family (columns do not have to be the same between rows
9. Vector
   1. Tools
      1. Pinecone
      2. pgvector (Postgres)
      3. Redis vector database (fastest)
   2. Uses

# Streaming / Near Real Time

# Transformation
1. Tools
   1. AWS Glue
   2. AWS Lambda
   3. DBT
   4. Matillion
   5. SSIS
2. Orchestration Layer
   1. Airflow
   2. Dagster
   3. Platform / Framework native tools (Snowflake tasks, Databricks jobs/workflows)

# Trends
1. 2025 - 2030 data migrations from legacy systems to modern data stacks