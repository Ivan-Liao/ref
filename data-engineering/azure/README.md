- [Tags](#tags)
- [Services](#services)
  - [Azure Health Data and AI Services](#azure-health-data-and-ai-services)
  - [Deidentification, FHIR integration, etc.](#deidentification-fhir-integration-etc)
  - [App service (!compute)](#app-service-compute)
  - [Application Insights (!monitoring)](#application-insights-monitoring)
  - [Azure Cosmos DB](#azure-cosmos-db)
  - [Azure Database for Postgresql (!storage)](#azure-database-for-postgresql-storage)
  - [Azure Database for MySQL (!storage)](#azure-database-for-mysql-storage)
  - [Azure Databricks (!ai,!etl)](#azure-databricks-aietl)
  - [Azure Data Explorer Clusters (!etl,!reporting,!storage)](#azure-data-explorer-clusters-etlreportingstorage)
  - [Azure Machine Learning (!ai)](#azure-machine-learning-ai)
  - [Azure Managed Redis (!storage)](#azure-managed-redis-storage)
  - [Azure SQL Database (!storage)](#azure-sql-database-storage)
  - [Azure Synapse Analytics (!etl,!reporting,!storage)](#azure-synapse-analytics-etlreportingstorage)
  - [Batch accounts (!compute)](#batch-accounts-compute)
  - [Container Apps (!compute)](#container-apps-compute)
  - [Container Instances (!compute)](#container-instances-compute)
  - [Container Registry (!devops)](#container-registry-devops)
  - [Cost Management (!monitoring)](#cost-management-monitoring)
  - [Data Factories (!etl)](#data-factories-etl)
  - [Event Hubs (!etl)](#event-hubs-etl)
  - [Function App (!compute)](#function-app-compute)
  - [Key Vaults (!admin)](#key-vaults-admin)
  - [Kubernetes Services (!compute)](#kubernetes-services-compute)
  - [Load Balancing and Content Delivery (!networking)](#load-balancing-and-content-delivery-networking)
  - [Logic Apps (!compute)](#logic-apps-compute)
  - [Marketplace](#marketplace)
  - [Microsoft Defender (!monitoring)](#microsoft-defender-monitoring)
  - [Microsoft Entra ID (!admin)](#microsoft-entra-id-admin)
  - [Microsoft Fabric (!etl,!reporting,!storage)](#microsoft-fabric-etlreportingstorage)
  - [Microsoft Fabric Eventhouse (!etl,!storage)](#microsoft-fabric-eventhouse-etlstorage)
  - [Microsoft Foundry (!ai)](#microsoft-foundry-ai)
  - [Microsoft Sentinel (!monitoring)](#microsoft-sentinel-monitoring)
  - [Monitor (!monitoring)](#monitor-monitoring)
  - [Power BI](#power-bi)
  - [Resource Manager (!admin,!devops)](#resource-manager-admindevops)
  - [Storage (!storage)](#storage-storage)
  - [Stream Analytics (!etl)](#stream-analytics-etl)
  - [Subscriptions (!security)](#subscriptions-security)
  - [Traffic Manager (!networking)](#traffic-manager-networking)
  - [Virtual Machine (!compute)](#virtual-machine-compute)
  - [Virtual Network (!networking)](#virtual-network-networking)

# Tags 
1. admin
2. ai
3. compute
4. devops
5. etl
6. monitoring
7. networking
8. reporting
9. storage

# Services
## Azure Health Data and AI Services
## Deidentification, FHIR integration, etc.
## App service (!compute)
## Application Insights (!monitoring)
1. Web apps, REST APIs
## Azure Cosmos DB
1. NoSQL
## Azure Database for Postgresql (!storage)
## Azure Database for MySQL (!storage)
## Azure Databricks (!ai,!etl)
1. Lakeflow Pipelines (!etl)
2. Notebooks (!etl)
3. Auto Loader / COPY INTO (!etl)
4. Spark Structured Streaming (!etl)
5. Genie (!ai)
   1. Conversational AI agent
## Azure Data Explorer Clusters (!etl,!reporting,!storage)
 1.  Real-time, high-speed analytics for streaming and telemetry data (PaaS) build on Kusto like Fabric Eventhouse
##  Azure Machine Learning (!ai)
1.  Train, manage, deployment of models
##  Azure Managed Redis (!storage)
## Azure SQL Database (!storage)
1.  Best for .NET / Microsoft ecosystem
2.  Types
    1.  SQL database
    2.  Managed Instance
    3.  SQL on VM
## Azure Synapse Analytics (!etl,!reporting,!storage)
1. Data 
   1. Delta lake foundations
2. Develop
   1. Contains spark notebooks
3. Pipelines 
   1. ADF pipelines
4. Uses serverless SQL (!compute)
   1. Read only query engine
## Batch accounts (!compute)
## Container Apps (!compute)
1. Has ingress, load balancing, and internal service-to-service communication
## Container Instances (!compute)
1. Ideal for single instances, no scale-to-zero
## Container Registry (!devops)
1.  Build, store, secure, scan, replicate, and manage container images and artifacts
## Cost Management (!monitoring)
## Data Factories (!etl)
1.  cloud data integration service for building, scheduling, and orchestrating complex ETL
2.  Standalone, with Synapse, or with Fabric
## Event Hubs (!etl)
1.  Streaming broker service
## Function App (!compute)
## Key Vaults (!admin)
1.  API keys
2. Passwords
3. Certificates
4. Encryption keys
## Kubernetes Services (!compute)
## Load Balancing and Content Delivery (!networking)
 1.  Application Gateway 
     1.  Application-level routing and load balancing services
 2.  Load Balancer
 3.  Azure Front Door
     1.  Fast, reliable, and secure access between users and applications’ web content
## Logic Apps (!compute)
1.  Process Automation with more than 1400 prebuilt connectors for email, cloud storage, databases
## Marketplace
1.  Azure AI services (!ai)
2.  Terraform on Azure (!devops)
## Microsoft Defender (!monitoring)
## Microsoft Entra ID (!admin)
1.  Identities
    1.  Users are human identities
    2.  Service Principals are machine / app identities
    3.  Groups are collections of users and services
        1.  Azure resource groups
        2.  Microsoft 365 groups for teams, sharepoint, outlook
2.  Roles
    1.  Owner
    2.  Contributor
    3.  Reader
    4.  etc.
3.  Security Groups
    1.  Collective identity containers, allowing access management for multiple users at once.
    2.  RBAC role can be assigned to security groups
## Microsoft Fabric (!etl,!reporting,!storage)
1.  Admin Portal
2.  OneLake data lakehouse in delta lake format
3.  Spark Notebooks for custom solutions (!etl)
4.  PowerBI integrations
5.  Activator (automated action triggers)
6.  Other Ingestion (!etl)
    1.  Pipelines chaining & Dataflows Gen2 powerquery (!etl)
    2.  OneLake shortcuts (!storage)
        1.  data stays in original source like AWS S3
    3.  Mirroring SQL databases (!etl,!storage)
## Microsoft Fabric Eventhouse (!etl,!storage)
1.  For real time data
2.  Database shortcuts to existing KQL databases in other eventhouses or ADX databases
3.  Eventstream 
4.  Extract
    1.  OneLake availability
5.  KQL
    1.  Pipe character to funnel operations
    2. Optimization
       1. Reduce columns 
       2. Filter from wide to narrow
       3. Limit results for aggregations
       4. Join with smaller table first
6.  Load
    1.  Local files, Azure storage, Amazon S3
    2.  Azure Event hubs, Fabric Eventstream, Real-Time hub
    3.  Database shortcuts (in place copies of data, does not actually store data)
    4.  OneLake, Data Factory copy, Dataflows
    5.  Connectors to Kafka, Flink, MQTT, Amazon Kinesis, Google Pub/Sub
7.  Materialized view
    1.  Materialized precomputed aggregation results plus a delta
8.  Real-Time Dashboards
## Microsoft Foundry (!ai)
1.  AI apps and agents framework
2.  OpenAI (!ai)
    1.  Models
3.  AI Search 
    1.  RAG search over user-owned content
## Microsoft Sentinel (!monitoring)
## Monitor (!monitoring)
## Power BI
1.  Power Query
2.  Direct Query
3.  DAX
    1.  Measure vs column, measure is part of semantic model not table
    2.  Measure name, table column references table_name[col_name], measure references [measure_name]
    3.  CALCULATE() for overridden context (comparison of filtered category like salesperson to total amount)
     4.  Multiple filters / criteria possible
    4.  Conditionals if
    5.  Win + . to open emoji window
4.  Power Automate
    1.  
## Resource Manager (!admin,!devops)
1.  Bicep is microsoft developed Infrastructure as Code (IaC) tool that allow you to define and deploy cloud resources declaratively
2.  Deployment Templates and Template Specs
3.  Management Groups
4.  Subscriptions
    1.  Billing and payment methods
    2.  Best practices for seperating environments
5.  Resource Groups
    1.  Group by lifecycle
6.  Resources
## Storage (!storage)
1.  Blob / Object
    1.  Storage types
        1.  Hot
        2.  Cool
            1.  30 day retention policy
        3.  Cold
            1.  90 day retention policy
        4.  Archive
            1.  Performance cost
    2.  Files must be overwritten completely
2.  File
    1.  Hierarchical and files are editable
3.  Block
    1.  Disks
        1.  
## Stream Analytics (!etl)
1.  Deprecation on Oct. 31, 2027
## Subscriptions (!security)
1. IAM
2. Resource Groups
## Traffic Manager (!networking)
## Virtual Machine (!compute)
## Virtual Network (!networking)
 1.  logical isolation, subnetting, hybrid connectivity, VNet Peering
 2.  NSG, network security groups at subnet or VM level
 3.  Route Tables
 4.  Azure NAT Gateway


