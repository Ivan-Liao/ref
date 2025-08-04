- [Storage](#storage)
- [Transformation](#transformation)
- [Misc Concepts](#misc-concepts)
  - [The 4 Vs](#the-4-vs)


# Storage
1. Tools
   1. AWS S3
   2. Azure Blob
   3. GCP GCS (Google Cloud Storage)
2. Formats
   1. csv
   2. json
   3. parquet

# Transformation
1. Tools
   1. DBT
   2. Matillion
   3. SSIS
   4. AWS Lambda
2. Orchestration Layer
   1. Airflow
   2. Dagster
   3. Tool native (Snowflake tasks, Databricks jobs/workflows)

# Misc Concepts 
## The 4 Vs

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
