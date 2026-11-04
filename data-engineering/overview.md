- [Column types](#column-types)
- [Data Modeling](#data-modeling)
- [Dataset types](#dataset-types)
  - [0. General](#0-general)
  - [1. Healthcare \& Medicine](#1-healthcare--medicine)
  - [2. Finance \& Banking](#2-finance--banking)
  - [3. Retail, Commerce \& E-commerce](#3-retail-commerce--e-commerce)
  - [4. Manufacturing \& Supply Chain](#4-manufacturing--supply-chain)
  - [5. Transportation \& Travel](#5-transportation--travel)
  - [6. Education \& Research](#6-education--research)
  - [7. Government, Utilities \& Environment](#7-government-utilities--environment)
  - [8. Technology, Telecommunications \& Digital Services](#8-technology-telecommunications--digital-services)
  - [9. Additional dataset categories worth considering](#9-additional-dataset-categories-worth-considering)
- [Table Field Types](#table-field-types)
  - [Field types and examples](#field-types-and-examples)
  - [Naming Conventions](#naming-conventions)
  - [Lists](#lists)
- [The 4 Vs](#the-4-vs)
- [Distributed Processing](#distributed-processing)
- [Monitoring and Reliability](#monitoring-and-reliability)
- [Optimization](#optimization)
- [Orchestration](#orchestration)
- [Project management](#project-management)
- [Sources](#sources)
- [Storage](#storage)
- [Streaming / Near Real Time](#streaming--near-real-time)
- [Transformation](#transformation)
- [Trends](#trends)
- [Validation](#validation)

# Column types
1. description
2. examples
3. flag / boolean
4. names
5. rule
6. timestamp
7. type

# Data Modeling

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
   3. Relationships
      1. one-to-one 
         1. use case for security, performance optimization, or organizing sparse data
         2. Example ... core users table with user_profiles table with optional, rarely used data like bios and avatars
      2. one-to-many
         1. Most common data model
         2. Example ... Customer table with customers that can place many orders in the Orders table, but every order is only associated with one customer
      3. many-to-many
         1. use case for junction tables
         2. Example ... Students can take many courses.  Courses contain many students.
   4. Star Schema
      1. The Star Schema is the most fundamental and widely used structure in dimensional modeling. It is named for its star-like appearance when visualized, with a central fact table connected to a number of dimension tables. 
   5. Snowflake Schema
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

# Dataset types
Below is a list of **50 different dataset categories** spanning industries such as healthcare, finance, commerce, manufacturing, transportation, education, government, technology, and scientific research.

The categories describe datasets based on the type of information they contain and the business purpose they serve. Each includes example tables or data entities and typical use cases.

## 0. General
| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 1 | Person Entity records | Identifying information (demographics, preferences, profiles, history) about people | `patients`, `customers`, `students`, `users` | Client management, demographics analysis |
| 2 | Account / Group Entity record | Customer bank accounts, organization profiles, group configurations | `accounts`, `security_groups` | account management |
| 3 | Coverage record | All valid combinations of two entities like students and exams or products and campaigns | `fact_exam_coverage`, `fact_campaign_coverage` | account management |

## 1. Healthcare & Medicine

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 2 | Medical history | Historical medical conditions, diagnoses, and procedures. | `medical_history`, `diagnoses`, `conditions` | Clinical decision support, patient history |
| 3 | Prescription & medication | Medication prescriptions, dosages, refills, and administration. | `prescriptions`, `medications`, `medication_history` | Medication tracking, prescription management |
| 4 | Laboratory results | Medical tests, measurements, and diagnostic results. | `lab_results`, `test_orders`, `specimens` | Clinical analysis, abnormal result detection |
| 5 | Medical imaging | Medical images and associated metadata. | `imaging_records`, `radiology_reports`, `image_metadata` | Radiology, diagnostic analysis |
| 6 | Clinical encounters | Patient visits, appointments, and treatment interactions. | `appointments`, `encounters`, `visit_notes` | Patient care management, scheduling |
| 7 | Healthcare billing & insurance | Medical charges, claims, reimbursements, and insurance coverage. | `medical_claims`, `insurance_policies`, `billing_transactions` | Revenue cycle management, insurance processing |
| 8 | Clinical research & trials | Research participants, trial enrollment, treatments, and outcomes. | `clinical_trials`, `trial_participants`, `study_results` | Drug development, clinical research |

## 2. Finance & Banking

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 9 | Financial transactions | Records of monetary transactions between accounts or entities. | `transactions`, `transfers`, `payments` | Transaction monitoring, financial reporting |
| 11 | Credit & lending | Loans, credit applications, repayment schedules, and credit history. | `loans`, `credit_applications`, `repayments` | Credit scoring, loan management |
| 12 | Investment & securities | Stocks, bonds, funds, portfolios, and investment transactions. | `securities`, `portfolios`, `holdings`, `market_prices` | Portfolio analysis, investment management |
| 13 | Accounting & general ledger | Financial records categorized by accounts and accounting periods. | `general_ledger`, `journal_entries`, `chart_of_accounts` | Financial statements, reconciliation |
| 14 | Fraud & risk | Suspicious transactions, fraud indicators, and risk assessments. | `fraud_alerts`, `risk_scores`, `investigation_cases` | Fraud detection, compliance |
| 15 | Foreign exchange & market data | Currency exchange rates and financial market observations. | `exchange_rates`, `market_quotes`, `historical_prices` | Currency conversion, market analysis |

## 3. Retail, Commerce & E-commerce

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 16 | Product catalog | Product information, descriptions, categories, and attributes. | `products`, `product_categories`, `product_attributes` | Product management, catalog search |
| 18 | Orders & transactions | Customer purchases, order details, and transaction history. | `orders`, `order_items`, `sales_transactions` | Sales reporting, order management |
| 19 | Inventory & stock | Available inventory, stock movements, and warehouse quantities. | `inventory`, `stock_movements`, `warehouse_stock` | Inventory management, replenishment |
| 20 | Pricing & promotions | Product prices, discounts, coupons, and promotional campaigns. | `product_prices`, `discounts`, `promotions`, `coupons` | Pricing optimization, promotion analysis |
| 21 | Shopping behavior | Website activity, product views, searches, and shopping cart interactions. | `page_views`, `search_events`, `cart_events` | Conversion analysis, customer behavior |
| 22 | Returns & refunds | Returned merchandise, refund requests, and return reasons. | `returns`, `refunds`, `return_reasons` | Returns management, product quality analysis |
| 23 | Customer reviews & feedback | Ratings, reviews, complaints, and customer satisfaction. | `product_reviews`, `ratings`, `customer_feedback` | Sentiment analysis, product improvement |

## 4. Manufacturing & Supply Chain

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 24 | Production & manufacturing | Production orders, manufacturing runs, and output quantities. | `production_orders`, `manufacturing_runs`, `production_output` | Production planning, efficiency analysis |
| 25 | Equipment & machinery | Equipment details, operational states, and machine utilization. | `equipment`, `machine_status`, `equipment_utilization` | Asset management, operational monitoring |
| 26 | Sensor & IoT telemetry | Continuous measurements from sensors and connected devices. | `sensor_readings`, `device_events`, `telemetry` | Predictive maintenance, anomaly detection |
| 27 | Quality control | Product inspections, defect records, and quality measurements. | `quality_inspections`, `defects`, `quality_tests` | Quality assurance, defect reduction |
| 28 | Procurement & purchasing | Supplier orders, purchase requests, and procurement transactions. | `purchase_orders`, `suppliers`, `purchase_order_items` | Procurement management, supplier analysis |
| 29 | Supply chain logistics | Movement of materials and products between locations. | `shipments`, `transport_orders`, `shipment_tracking` | Supply chain visibility, logistics optimization |
| 30 | Maintenance & repairs | Equipment maintenance schedules, work orders, and repair history. | `maintenance_orders`, `repair_logs`, `maintenance_schedules` | Preventive maintenance, downtime analysis |

## 5. Transportation & Travel

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 31 | Vehicle & fleet | Vehicle information, ownership, mileage, and fleet status. | `vehicles`, `fleet_assets`, `vehicle_assignments` | Fleet management, vehicle utilization |
| 32 | GPS & location tracking | Geographic positions and movement history. | `gps_locations`, `vehicle_routes`, `location_events` | Route optimization, tracking |
| 33 | Traffic & transportation | Traffic volume, congestion, road conditions, and travel times. | `traffic_counts`, `road_conditions`, `travel_times` | Traffic planning, congestion analysis |
| 34 | Travel reservations | Flight, hotel, rental car, and travel bookings. | `reservations`, `flight_bookings`, `hotel_bookings` | Reservation management, travel analytics |
| 35 | Public transportation | Transit schedules, passenger counts, and service operations. | `transit_routes`, `bus_schedules`, `ridership` | Transit planning, service optimization |

## 6. Education & Research

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 37 | Academic performance | Grades, assessments, attendance, and academic progress. | `grades`, `exam_results`, `attendance` | Performance analysis, student support |
| 38 | Course & curriculum | Courses, subjects, instructors, and curriculum structures. | `courses`, `course_sections`, `curriculum` | Course management, curriculum planning |
| 39 | Scientific research | Experimental observations, research measurements, and findings. | `experiments`, `observations`, `research_results` | Scientific analysis, research reproducibility |
| 40 | Surveys & questionnaires | Responses to structured surveys and questionnaires. | `surveys`, `survey_questions`, `survey_responses` | Market research, public opinion, research analysis |

## 7. Government, Utilities & Environment

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 41 | Population & demographics | Population counts, age distributions, household characteristics. | `population`, `demographics`, `households` | Population planning, demographic analysis |
| 42 | Tax & public revenue | Tax filings, tax payments, and government revenue. | `tax_returns`, `tax_payments`, `revenue_records` | Tax administration, revenue reporting |
| 43 | Property & real estate | Property ownership, valuations, sales, and rental information. | `properties`, `property_sales`, `property_assessments` | Real estate analysis, property taxation |
| 44 | Energy & utilities | Electricity, gas, and water consumption and distribution. | `utility_usage`, `energy_readings`, `meter_records` | Consumption forecasting, resource management |
| 45 | Weather & climate | Weather observations, forecasts, and historical climate measurements. | `weather_observations`, `forecasts`, `climate_records` | Weather forecasting, climate research |
| 46 | Environmental monitoring | Air quality, water quality, pollution, and environmental measurements. | `air_quality`, `water_samples`, `pollution_measurements` | Environmental compliance, sustainability |

## 8. Technology, Telecommunications & Digital Services

| # | Dataset category | Description | Example tables / entities | Common use cases |
|---:|---|---|---|---|
| 47 | Application logs & events | Records of application activity, errors, and system events. | `application_logs`, `error_events`, `system_events` | Troubleshooting, application monitoring |
| 48 | User activity & authentication | Login attempts, user sessions, and access history. | `login_events`, `user_sessions`, `authentication_logs` | Security monitoring, usage analytics |
| 49 | Network & infrastructure | Network traffic, server performance, and infrastructure metrics. | `network_metrics`, `server_metrics`, `infrastructure_events` | Infrastructure monitoring, capacity planning |
| 50 | API & integration activity | API requests, responses, integration events, and processing results. | `api_requests`, `api_responses`, `integration_logs` | API monitoring, integration troubleshooting |

---

## 9. Additional dataset categories worth considering

The 50 categories above cover major industries. The following are additional specialized datasets that are also common in enterprise environments.

| # | Dataset category | Industry / domain | Example tables / entities |
|---:|---|---|---|
| 51 | Legal & case management | Legal | `cases`, `court_filings`, `legal_documents` |
| 52 | Human resources & payroll | Human resources | `employees`, `payroll`, `compensation` |
| 53 | Recruitment & hiring | Human resources | `job_applications`, `candidates`, `interviews` |
| 54 | Insurance policies & underwriting | Insurance | `policies`, `underwriting_assessments`, `premiums` |
| 55 | Insurance claims | Insurance | `claims`, `claim_payments`, `claim_adjustments` |
| 56 | Marketing campaigns | Marketing | `campaigns`, `advertisements`, `campaign_performance` |
| 57 | Advertising impressions & clicks | Digital advertising | `impressions`, `click_events`, `ad_conversions` |
| 58 | Social media activity | Social media | `posts`, `comments`, `shares`, `followers` |
| 59 | Content & media management | Media | `articles`, `videos`, `media_assets` |
| 60 | Project & task management | Business operations | `projects`, `tasks`, `milestones` |
| 61 | Customer support & service | Customer service | `support_tickets`, `service_requests`, `ticket_messages` |
| 62 | Contracts & agreements | Business / legal | `contracts`, `contract_parties`, `contract_terms` |
| 63 | Food & agriculture | Agriculture | `crop_yields`, `farm_operations`, `soil_samples` |
| 64 | Hospitality & restaurant operations | Hospitality | `reservations`, `menus`, `restaurant_orders` |
| 65 | Construction & infrastructure | Construction | `construction_projects`, `work_orders`, `inspection_records` |

# Table Field Types
The following is a list of common database table field types commonly found in transactional databases, analytical data warehouses, APIs, and reporting systems.

There are **45 field categories** with descriptions, examples, and typical database data types. The examples use an order-management system as a reference, but most apply to any database.

## Field types and examples

| # | Field category | Description | Example field names | Typical data types |
|---:|---|---|---|---|
| 1 | **Primary key fields** | Unique identifiers for individual records. | `id`, `order_id`, `customer_id` | INT, BIGINT, UUID |
| 2 | **Foreign key fields** | References to records in another table. | `customer_id`, `product_id`, `location_id` | INT, BIGINT, UUID |
| 3 | **External key fields** | Identifiers originating from external systems. | `external_order_id`, `erp_id`, `legacy_id` | VARCHAR, UUID |
| 4 | **Composite key fields** | Multiple fields used together to uniquely identify a record. | `order_id + product_id`, `tenant_id + record_id` | Multiple types |
| 5 | **sequence fields** | Track sequential ordering. | `sequence_id` | INT, BIGINT |
| 6 | **Time Related Fields** | fields related to date, time, or duration | `created_at`, `created_datetime`, `insert_timestamp` | DATETIME, TIMESTAMP, DATE, INTERVAL, INT, BIGINT |
| 6.1 | **metadata timestamps** | Record when a database record was initially created, cdc extracted, ingested, updated, deleted. | `created_at`, `created_datetime`, `updated_at`, `last_modified`, `deleted_at`, `ingested_at`  | DATETIME, TIMESTAMP |
| 6.2 | **Event timestamps** | Record when a business event occurred. | `ordered_at`, `packed_at`, `shipped_at`, `delivered_at` | DATETIME, TIMESTAMP |
| 6.3 | **Event dates** | Store the calendar date of a business event without necessarily storing its time. | `order_date`, `invoice_date`, `delivery_date` | DATE |
| 6.4 | **Time fields** | Store a time of day independently of a date. | `opening_time`, `cutoff_time`, `scheduled_time` | TIME |
| 6.5 | **Duration fields** | Represent the amount of time between events or processes. | `processing_duration`, `delivery_duration`, `elapsed_seconds` | INT, BIGINT, INTERVAL |
| 6.6 | **Timezone fields** | Identify the timezone associated with a timestamp or schedule. | `timezone`, `timezone_name`, `utc_offset` | VARCHAR, INTERVAL |
| 7 | **Categorical label fields** | Store values from a predefined set of categories. | `order_status`, `priority`, `payment_method` | VARCHAR, ENUM |
| 7.1 | **Status fields** | Represent the current state of a record or process. | `order_status`, `shipment_status`, `approval_status` | VARCHAR, ENUM, INT |
| 7.2 | **Type / classification fields** | Identify what kind of record or transaction something represents. | `order_type`, `customer_type`, `transaction_type` | VARCHAR, ENUM |
| 8 | **Yes / No boolean flags** | Store binary true/false conditions. | `is_deleted`, `is_active`, `is_redirected`, `is_bulk`, `is_tracking_enabled`, `is_approval_required` | BOOLEAN, TINYINT |
| 9 | **Free-text fields** | Store descriptive text that does not follow a fixed format. | `notes`, `comments`, `description` | VARCHAR, TEXT |
| 10 | **Message / communication fields** | Store messages, notifications, or communication content. | `error_message`, `customer_message`, `notification_body` | VARCHAR, TEXT |
| 11 | **JSON object fields** | Store structured key-value data or nested objects. | `metadata`, `payload`, `shipping_details` | JSON, TEXT |
| 12 | **JSON array fields** | Store arrays of structured objects or values. | `order_items_list`, `attachments`, `event_history` | JSON, TEXT |
| 13 | **Comma-separated list fields** | Store multiple values in a single string separated by delimiters. | `tags`, `permissions`, `associated_ids` | VARCHAR, TEXT |
| 14 | **Numeric quantity fields** | Represent counts or quantities of items. | `quantity`, `units_ordered`, `package_count` | INT, BIGINT |
| 15 | **Integer measurement fields** | Store whole-number measurements. | `weight_grams`, `distance_meters`, `age_days` | INT, BIGINT |
| 16 | **Decimal measurement fields** | Store measurements requiring fractional precision. | `dose_amount`, `weight_kg`, `temperature` | DECIMAL, FLOAT |
| 17 | **Currency / cost fields** | Represent monetary values or expenses. | `order_total`, `unit_cost`, `shipping_cost` | DECIMAL |
| 18 | **Financial rate fields** | Store rates, percentages, or financial ratios. | `tax_rate`, `discount_percentage`, `commission_rate` | DECIMAL, FLOAT |
| 19 | **Calculated / derived fields** | Store values calculated from other fields. | `total_amount`, `profit_margin`, `days_since_order` | DECIMAL, INT |
| 20 | **Address fields** | Store physical or mailing address information. | `street_address`, `city`, `state`, `postal_code` | VARCHAR |
| 21 | **Contact information fields** | Store contact details for individuals or organizations. | `email`, `phone_number`, `fax_number` | VARCHAR |
| 22 | **Name / identity fields** | Store names of people, organizations, or entities. | `first_name`, `last_name`, `company_name` | VARCHAR |
| 23 | **URL / hyperlink fields** | Store web addresses or links to external resources. | `tracking_url`, `document_url`, `website` | VARCHAR, TEXT |
| 24 | **File path / storage reference fields** | Store file locations or object-storage references. | `file_path`, `blob_uri`, `attachment_location` | VARCHAR, TEXT |
| 25 | **Binary / file data fields** | Store actual binary file contents. | `document_data`, `image_data`, `attachment_blob` | BLOB, VARBINARY |
| 26 | **Geographic coordinate fields** | Store latitude, longitude, or spatial coordinates. | `latitude`, `longitude`, `coordinates` | DECIMAL, FLOAT, GEOMETRY |
| 27 | **Geospatial fields** | Store geographic shapes, points, boundaries, or routes. | `delivery_location`, `service_area`, `route_geometry` | GEOMETRY, GEOGRAPHY |
| 28 | **User / ownership fields** | Identify the user or system responsible for a record. | `created_by`, `updated_by`, `assigned_to` | INT, UUID, VARCHAR |
| 29 | **Audit / change tracking fields** | Track who changed a record and what operation occurred. | `changed_by`, `change_type`, `cdc_operation` | VARCHAR, ENUM |
| 30 | **Source system fields** | Identify where a record or event originated. | `source_system`, `source_database`, `source_table` | VARCHAR |
| 31 | **Import / ingestion metadata fields** | Track when and how data entered a database or data pipeline. | `ingested_at`, `batch_id`, `pipeline_run_id` | TIMESTAMP, UUID, VARCHAR |
| 32 | **Hash / checksum fields** | Store hashes used for comparison, integrity validation, or deduplication. | `record_hash`, `checksum`, `payload_hash` | CHAR, VARCHAR, BINARY |
| 33 | **Ranking / scoring fields** | Store priority scores, rankings, or calculated ratings. | `priority_score`, `customer_rating`, `risk_score` | INT, DECIMAL, FLOAT |
| 34 | **Version / schema metadata fields** | Identify the structure or format version of stored data. | `schema_version`, `payload_version`, `api_version` | INT, VARCHAR |

## Naming Conventions
Key standard terms
1. id
2. name
3. at / datetime / timestamp / time / date / duration / from / to
4. count / quantity
5. amount
6. cost
7. rate / percentage
8. seqeunce
9. seconds / minutes / hours / days
10. source / target
   
## Lists

| Feature | Comma-Separated String | JSON / Variant Type | Native Array / List Type |
| --- | --- | --- | --- |
| Query Performance | Poor (Full Table Scan) | Moderate to Good (with JSON indexes) | Excellent (Optimized storage & indexing) |
| Type Safety | None (All text) | Moderate | High |
| Portability | Universal | High (Most modern DBs) | "Low-Moderate (Vendor specific |  e.g. |  Postgres)" |
| Data Integrity | None | Low-Moderate | High |
| Human Readability | High | Moderate | Moderate |

# The 4 Vs

- [ ] Velocity
  - [ ] Orchestration (batch with what cadence or stream) 
- [ ] Variety
  - [ ] Data Format
- [ ] Volume
  - [ ] Limit scope of ingestion
- [ ] Validity/Veracity
  - [ ] Schema changes
  - [ ] Data types
    - [ ] Wrong data type
    - [ ] Leading zeros in number string
    - [ ] White space in string 
  - [ ] Null checks
  - [ ] Duplication 
  - [ ] Typos (can check distinct values)
  - [ ] Outliers
  - [ ] Missing data


# Distributed Processing
1. Data shuffle (a notorious bottleneck)
   1. Mitigation methods
      1. Broadcast joins
      2. pre-partitioning/bucketing
      3. filtering early

# Monitoring and Reliability
1. Routing
   1. DLQ (dead letter queue)
      1. industry standard paradigm that allows for uninterrupted processing while errors are rerouted
2. Logging
   1. Where, what, who, when, why, how often
   2. Structured logs allow for queryable logs and not just grepping or opening individual logs
3. Metrics
   1. Orchestration
      1. DAG run duration
      2. Task success/failure rate
      3. Task retry count
   2. Data health
      1. Data freshness from source system
      2. Processed record count
      3. DLQ count
   3. Performance
      1. Resource utilization (vCPU, memory, bq slot usage)
   4. Failure modes
      1. User code and data shape caused errors
      2. Outages
         1. Cloud zonal, regional (maybe regional backup streaming subscription)
4. References
   1. GCP log routing 
      1. https://docs.cloud.google.com/logging/docs/routing/overview?utm_source=youtube&utm_medium=unpaidsoc&utm_campaign=CDR_yur_gcp_hh_z8qewgfq_EngineeringForReliability_112921&utm_content=description#buckets 

# Optimization
1. Partitioning
   1. Like inserting dividers in a filing cabinet, typically by timestamp or integer id
   2. Expect 50%+ increase in efficiency
2. Clustering
   1. Ordering like by customer_id or name alphabetically
3. Metrics
   1. CPU usage
   2. Memory consumption
   3. I/O rates (read/writes)
   4. job completion times
   5. job profiling (bottlenecks)
   6. data skew detection
4. Preemptible / spot resources
   1. Can be interrupted, stopped, or reclaimed by the system at any time
   2. Industry standard 60-80% cheaper
5. Interleaved Tables physically store child rows on the exact same storage node (and often the same block) as the parent row.
6. Primary key / index
   1. Uniquely identifies row in each table
   2. Secondary indexes help find data faster based on non-primary-key columns

# Orchestration
1. Dependency Management
2. Scheduling
3. Error Handling and retries
4. Monitoring and Alerting
5. Idempotency

# Project management
1. The 4 Vs
- [ ] Velocity
  - [ ] Orchestration (batch with what cadence or stream) 
- [ ] Variety
  - [ ] Data Format
- [ ] Volume
  - [ ] Limit scope of ingestion
- [ ] Validity/Veracity


1. Redaction methods
   1. Manually filter or delete sensitive columns (columns name may not be specific, comments/notes columns may contain sensitive info)
   2. Regular expressions (tedious and less accurate)
   3. Fuzzy matching
   4. Services
      1. Google DLP API

# Sources
1. Federated queries
   1. queries connected to distinct external data sources
2. S3 path
3. https://raw.githubusercontent.com
4. Data Sharing
   1. Direct access to database > data warehouse
   2. Internal Sharepoint to Azure ecosystem > data warehouse
   3. Extract to Cloud storage to > data warehouse
   4. Extract to sFTP > data warehouse
   5. Access to APIs > data warehouse
   6. Application view extract > data warehouse
   7. Data scraping > data warehouse

# Storage
1. Cache / Real Time
2. Data Lake (schema on read)
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
   3. Pros 
      1. fast to ingest, flexible, scalable, cost effective
   4. Cons
      1. Risk of becoming data swamp, management complexity, time consuming analysis and query speeds, security risks
3. Data Lakehouse
   1. Metadata and governance layer on top of data lake
   2. Pros
      1. More flexibility and cost effectiveness than data warehouse
      2. schema on read or write 
      3. ACID tranasction support like data warehouse
   3. Iceberg
      1. Schema evolution
      2. Hidden partitioning
      3. Clustering
         1. Iceberg metadata contains file statistics like maxes and mins
         2. Efficiency from predicate pushdown (moving the predicate where filter from query engine to source file)
      4. Time travel
      5. Atomic transactions
      6. Certain systems like Biglake allow for Update, Insert, Delete operations on source files
4. Data Warehouse (schema on write)
   1. Tools
      1. Snowflake
      2. AWS Redshift
      3. Databricks
   2. Pros
      1. fast to query, high-quality data
   3. Cons
      1. inflexible, costly, limited data types, long development time
5. Document
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
6. Graph
   1. Tools
      1. neo4j
      2. Dgraph
   2. Uses
      1.   Fraud detection
      2.   Internal Knowledge Graph
      3.   Recommendation Engine
      4.   Reduces complex joins
7. Key-Value 
   1. Tools
      1. Redis
      2. Memcached
   2. Uses
      1. Caching
      2. Pub/Sub
      3. Leaderboards
8. Relational
   1. Tools
      1. MySQL
      2. Postgres
      3. SQL Server
   2. Uses
      1. Analytical
   3. ACID compliant
      1. atomicity, consistency,  isolation, durability
   4. Sharding when larger database is sharded into smaller, faster, manageable chunks by rows
9.  Search
   1. Tools
      1. Elasticsearch
      2. Algolia
      3. Meilisearch
   2. Uses
      1. Search
   3. Like document db but creates an index
10. Wide Column
   1. Tools
      1. Cassandra
      2. Apacha Hbase
   2. Uses
      1. Time-series
      2. Historical records
      3. high-write, low-read
   3. Rows with key and column family (columns do not have to be the same between rows
11. Vector
   1. Tools
      1. Pinecone
      2. pgvector (Postgres)
      3. Redis vector database (fastest)
   2. Uses

# Streaming / Near Real Time
1. Publisher, subscriber, topics
2. Straight through, fan out, fan in
3. Pull and push delivery methods

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
3. Batch processing
   1. Error reporting / Logging / Monitoring
      1. In parallel processing systems, the error can be tied to a subtask or specific worker node
      2. Skipping if permissible
      3. Human intervention / data curation
   2. Hyperparameters
      1. Optimal batch sizing
      2. Effective data partitioning
      3. I/O optimization (efficient file formats and techniques)

# Trends
1. 2025 - 2030 data migrations from legacy systems to modern data stacks

# Validation
1. Schema changes
   1. Additive (new field)
      1. CSV or JSON format typically have a Append to table or Overwrite table option
      2. Spark has --merge-schema=true run argument parameter
   2. Breaking changes (deletion, rename)
      1. Facade view pattern
         1. New pipeline that writes to a new versioned table
         2. Unified view is created with UNION ALL statement
         3. Consumers directed to the view
2. Data types
   1. Wrong data type
   2. Leading zeros in number string
   3. White space in string 
   4. Unexpected characters
3. Null checks
4. Duplication 
   1. exact
      1. Inflates row counts, skewing basic metrics like COUNT(*) and AVG().
      2. Dataflow solution use beam.Distinct()
   2. key-based (sometimes want to keep latest record)
      1. Problems of exact plus corrupts stateful analytics (e.g., a customer's final order status or current account balance).
      2. Dataflow Use CombinePerKey and CombineFn instead of GroupByKey
      3. Spark Window funcitons
   3. semantic (misspelling)
      1. Breakes entity view
      2. BQ ML ML.GENERATE_TEXT_EMBEDDING and ML.DISTANCE
5. Typos (can check distinct values)
6. Outliers
7. Missing data