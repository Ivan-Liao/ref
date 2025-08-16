- [Architecture](#architecture)
- [Setup](#setup)
- [Workspace (user and group management, catalog)](#workspace-user-and-group-management-catalog)
  - [Menu options](#menu-options)
  - [Notebooks (like Jupyter notebooks)](#notebooks-like-jupyter-notebooks)
- [Others](#others)


# Architecture
1. Apache Spark compute
2. Data Lakehouse
   1. open formats like parquet or csv
   2. managed Azure blobs
   3. S3 bucket to the Databricks File System (DBFS).
3. Unity Catalog governs
   1. Data Intelligence engine on top
   2. account (metastores [usually one per region and contains primarily multiple catalogs]), users, group, SP) > workspaces (dev, UAT, prod)
   3. users like account administrator (basically devops admin), metastore administrator (catalog, data objects, basically data architect), workspace administrator (users of that workspace, workspace assets), owner (tables, schemas)
   4. 3 level namespace (catalog, schema, name)
4. Control vs Data (Client side) Plane

# Setup
1. Azure
   1. Create resource group
      1. If managed,  a storage account and access connector is setup for databricks
      2. After spinning up clusters, virtual machine, disk, and network interfaces are setup for that cluster
      3. Create virtual network and public/private subnets (256 addresses in example)
   2. Create databricks workspace

# Workspace (user and group management, catalog)
## Menu options
1. Analyst
   1. SQL editor
   2. Queries
   3. Dashboards
   4. Alerts
   5. Query History
   6. SQL warehouses
2. Data Engineering
   1. Job Runs
   2. Data Ingestion
   3. Delta Live Tables
3. ML Engineer
   1. Playground
   2. Experiments
## Notebooks (like Jupyter notebooks)
1. connect to compute
   1. single node
   2. terminate after (like 5-10 minutes)
   3. general Standard DS3_v2
2. shortcuts 
   1. shift + enter to save and exit cell
3. Data Engineering
   1. DDL
   2. Create Schema
   3. Create Table
   4.  ```
        create table bronze.emp(
        emp_id int,
        emp_name string,
        dept_code string
        )
        ```

# Others

Git
CI/CD
CLI
ETL
E
Spark Connector (from snowflake, sql server, etc.)
Apache Spark Structured Streaming near real time
T
L
Hive Metastore (Azure)
Delta Live Tables
Scheduling
Workflows
Autoloader
Data Science
Modeling training and deployment
AI agents
can be customized to specific industry
Prepare data 
data ingestion
ML features
Vector index
Build agents
Model tuning
Tool catalog
Function calling
Evaluate Agents
LLM judges
Peer labeling
Deploy Agents
Cost optimization
