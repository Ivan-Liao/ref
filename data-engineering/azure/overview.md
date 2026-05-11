# AI and ML
1. Azure OpenAI
   1. Models
2. Azure Machine Learning
   1. Train, manage, deployment of models
3. Azure AI Services
   1. APIs
4. Azure AI Foundry
   1. AI apps and agents framework

# Compute and Containers
1. Azure Virtual Machine
2. Azure Functions
3. Kubernetes Service
4. Azure Container Apps
   1. Requires infrastructure management
5. Azure Container Instances
   1. single instances ideal
6. Azure app service
   1. Web apps, REST APIs
7. Azure Batch

# Devops and Automation
1. Azure Bicep (like terraform)
2. Terraform on Azure
3. Azure Event Hubs
4. Azure Logic Apps
5. Azure Container Registry

# Foundation and Security
1. Hierarchy
   1. Management Groups
   2. Subscriptions
      1. Billing and payment methods
      2. Best practices for seperating environments
   3. Resource Groups
      1. Group by lifecycle
   4. Resources
2. Microsoft Entra ID
   1. Identities
      1. Users
      2. Groups
      3. Service Principals
   2. Roles
      1. Owner 
      2. Contributor
      3. Reader
3. Azure Key Vault
   1. API keys
   2. Passwords
   3. Certificates
   4. Encryption keys

# Monitoring and Costs
1. Azure Monitor
2. Application Insights
3. Azure Sentinel
4. Microsoft Defender
5. Azure Cost Management

# Networking and Content Delivery
1. Virtual Network
2. Load Balancer
3. Application Gateway
4. Azure Front Door
5. Traffic Manager
6. 

# Storage and Databases
1. Azure Blob Storage
   1. Hot
   2. Cool
      1. 30 day retention policy
   3. Cold
      1. 90 day retention policy
   4. Archive
      1. Performance cost
2. Microsoft Fabric
   1. OneLake data lakehouse
   2. Spark based transformations
   3. PowerBI Integrations
3. Azure Managed Disks
4. Azure File
   1. On prem and cloud hybrid
5. Azure SQL database
6. Azure Database for Postgresql
7. Azure Database for MySQL
8. Azure Cosmos DB
   1. NoSQL
9.  Azure managed redis
10. Azure AI search
11. Azure Synapse Analytics

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