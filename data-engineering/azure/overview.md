- [Tags](#tags)
- [Services](#services)
- [Storage and Databases](#storage-and-databases)
- [Visualization](#visualization)

# Tags 
1. admin
2. ai
3. compute
4. devops
5. etl
6. monitoring
7. networking
8. reporting
9.  storage

# Services
1. Azure Health Data and AI Services
   1. Deidentification, FHIR integration, etc.
2. Application Insights (!monitoring)
3. App service (!compute)
   1. Web apps, REST APIs
4. Azure Cosmos DB
   1. NoSQL
5. Azure Database for Postgresql (!storage)
6. Azure Database for MySQL (!storage)
7. Azure Databricks (!ai,!etl)
   1. Lakeflow Pipelines (!etl)
   2. Notebooks (!etl)
   3. Auto Loader / COPY INTO (!etl)
   4. Spark Structured Streaming (!etl)
   5. Genie (!ai)
      1. Conversational AI agent
8. Azure Data Explorer Clusters (!etl,!reporting,!storage)
    1.  Real-time, high-speed analytics for streaming and telemetry data (PaaS) build on Kusto like Fabric Eventhouse
9.  Azure Machine Learning (!ai)
    1.  Train, manage, deployment of models
10. Azure Managed Redis (!storage)
11. Azure SQL Database (!storage)
    1.  Best for .NET / Microsoft ecosystem
    2.  Types
        1.  SQL database
        2.  Managed Instance
        3.  SQL on VM
12. Azure Synapse Analytics (!etl,!reporting,!storage)
    1. Data 
       1. Delta lake foundations
    2. Develop
       1. Contains spark notebooks
    3. Pipelines 
       1. ADF pipelines
    4. Uses serverless SQL (!compute)
       1. Read only query engine
13. Batch accounts (!compute)
14. Container Apps (!compute)
   1. Has ingress, load balancing, and internal service-to-service communication
15. Container Instances (!compute)
   1. Ideal for single instances, no scale-to-zero
16. Container Registry (!devops)
   1.  Build, store, secure, scan, replicate, and manage container images and artifacts
17. Cost Management (!monitoring)
18. Data Factories (!etl)
    1.  cloud data integration service for building, scheduling, and orchestrating complex ETL
    2.  Standalone, with Synapse, or with Fabric
19. Event Hubs (!etl)
    1.  Streaming broker service
20. Function App (!compute)
21. Key Vaults (!admin)
    1.  API keys
    2. Passwords
    3. Certificates
    4. Encryption keys
22. Kubernetes Services (!compute)
23. Load Balancing and Content Delivery (!networking)
    1.  Application Gateway 
        1.  Application-level routing and load balancing services
    2.  Load Balancer
    3.  Azure Front Door
        1.  Fast, reliable, and secure access between users and applications’ web content
24. Logic Apps (!compute)
    1.  Process Automation with more than 1400 prebuilt connectors for email, cloud storage, databases
25. Marketplace
    1.  Azure AI services (!ai)
    2.  Terraform on Azure (!devops)
26. Microsoft Defender (!monitoring)
27. Microsoft Entra ID (!admin)
    1.  Identities
        1.  Users are human identities
        2.  Service Principals are machine / app identities
        3.  Groups are collections of users and services
    2.  Roles
        1.  Owner
        2.  Contributor
        3.  Reader
28. Microsoft Fabric (!etl,!reporting,!storage)
    1.  Admin Portal
    2.  OneLake data lakehouse in delta lake format
    3.  Eventhouse for real time data
        1.  Eventstream (!etl)
    4.  Spark Notebooks for custom solutions (!etl)
    5.  PowerBI integrations
    6.  Activator (automated action triggers)
    7.  Other Ingestion (!etl)
        1.  Pipelines chaining & Dataflows Gen2 powerquery (!etl)
        2.  OneLake shortcuts (!storage)
            1.  data stays in original source like AWS S3
        3.  Mirroring SQL databases (!etl,!storage)
29. Microsoft Foundry (!ai)
    1.  AI apps and agents framework
    2.  OpenAI (!ai)
        1.  Models
    3.  AI Search 
        1.  RAG search over user-owned content
30. Microsoft Sentinel (!monitoring)
31. Monitor (!monitoring)
32. Power BI
    1.  Power Query
    2.  Direct Query
    3.  DAX
33. Resource Manager (!admin,!devops)
    1.  Bicep is microsoft developed Infrastructure as Code (IaC) tool that allow you to define and deploy cloud resources declaratively
    2.  Deployment Templates and Template Specs
    3.  Management Groups
    4.  Subscriptions
        1.  Billing and payment methods
        2.  Best practices for seperating environments
    5.  Resource Groups
        1.  Group by lifecycle
    6.  Resources
34. Storage (!storage)
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
35. Stream Analytics (!etl)
    1.  Deprecation on Oct. 31, 2027
36. Traffic Manager (!networking)
37. Virtual Machine (!compute)
38. Virtual Network (!networking)

# Storage and Databases
1.  Microsoft Fabric
   1. Features
      1. Admin Portal
      2. OneLake data lakehouse
         1. OneLake catalog to analyze, monitor, and maintain data governance
      3. Spark based transformations
      4. PowerBI Integrations
      5. Real-TIme Dashboards
      6. Activator (automated action triggers)
      7. Eventhouse (database for time-series and event data with KQL)

# Visualization
1. PowerBI
   1. Power Query
   2. DAX
      1. Measure vs column, measure is part of semantic model not table
      2. Measure name, table column references table_name[col_name], measure references [measure_name]
      3. CALCULATE() for overridden context (comparison of filtered category like salesperson to total amount)
         1. Multiple filters / criteria possible
      4. Conditionals if
      5. Win + . to open emoji window