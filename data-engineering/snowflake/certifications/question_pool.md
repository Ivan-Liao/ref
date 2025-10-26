# Billing
1. Which of the following locations is data storage calculated based on the on-disk bytes? ... Which contribute to storage billing?
   1. Internal Stages, Databases tables including time travel & fail-safe, materialized views
   2. External stages are not included
2. Resource monitors
   1. The administrator sets the monitor action to SUSPEND at 100% of the quota and SUSPEND_IMMEDIATE at 110% of the quota.
   2. CURRENT queries finish with SUSPEND, they are terminated immedietely with SUSPEND_IMMEDIATE

# Compute
1. VW min billing
   1. What is the minimum number of seconds a virtual warehouse is billed for?
   2. 60 seconds

# Objects
1. Materialized views
   1. Why would a materialized view be used?
   2. Make complex queries readily available, and created on top of external tables to improve query performance
2. Materialized views
   1. what limitations apply
   2. self joins not allowed
   3. Only one table is allowed
3. External function
   1. Which object does an external function make use of to hold security related information? Choose one correct value.
   2. API integration
4. External Function
   1. External Functions are designed to integrate Snowflake with external services and execute code outside of Snowflake. They allow users to leverage third-party APIs, external data sources, and additional programming languages beyond what is available internally.
5. External table
   1. Which of the following statements is true about enabling an external table in Snowflake?
   2. It requires a manual refresh of metadata after enabling to ensure that the table is aware of any new or updated data files in the external stage. This is typically done using the ALTER EXTERNAL TABLE <table_name> REFRESH; command.
6. Transient table
   1. Which of the following best describes a transient table in Snowflake?
      1. A table that is persistent across sessions, supports Time Travel, but does not maintain Fail-safe storage.
7. Procedures
   1. What is the default execution context for Stored Procedures in Snowflake if the execution context (caller or owner) is not explicitly specified?
   2. Owner

# Performance
1. Where can users find the query profile for a completed query in Snowflake?
2. Directly from the Worksheet for the last executed query and In the Query History under the Activity section in Snowflake

# Security
1. secure objects
   1. Every securable object is owned by a single role. True or false?
   2. True

# Services
1. Snowflake Partner Connect
   1. Which is the most accurate description of the Snowflake Partner Connect
   2. The Snowflake Partner Connect allows you to easily create trial account with selected Snowflake business partners and integrate these accounts with Snowflake.

# Sharing
1. Shared data setup
   1. Once a data provider creates a share object, what two operations must they perform next to ensure a data consumer can read the shared data
   2. Grant privileges on database objects to share & add consumer account(s) to share.

# Export and Load 
1. Which properties are not available to a file format object of type CSV?
   1. TYPE, SKIP_HEADER, FIELD_DELIMITER, RECORD_DELIMITER
   2. STRIP_OUTER_ARRAY, STRIP_NULL_VALUES 
      1. both json specific
      2. STRIP_NULL_VALUES equivalent is SKIP_BLANK_LINES
2. What happens if data is loaded using the COPY command from a stage located in a different cloud region or provider than the Snowflake account?
   1. Data transfer costs may apply, depending on the region or cloud provider.