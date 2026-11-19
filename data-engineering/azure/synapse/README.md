- [Datasets](#datasets)
  - [ADLS (Azure Data Lake Service)](#adls-azure-data-lake-service)
  - [Azure Synapse Analytics](#azure-synapse-analytics)
- [Linked Services](#linked-services)
  - [Database (MariaDB)](#database-mariadb)

# Datasets

## ADLS (Azure Data Lake Service)

## Azure Synapse Analytics

# Linked Services

## Database (MariaDB)
```json
"Connect via integration runtime": "IR-AZRSVBioRXBI-Replica",
"Server name": "e.g. 127.0.0.1",
"Port": "",
"Database name": "",
"User name": "<handle with Synapse pipeline parameter>",
"Azure Key Vault": "",
"Linked Service Properties.KV_Name": "<handle with Synapse pipeline parameter>",
"Parameters": "<linked to Synapse pipeline parameters>"
```
1. Azure Integration Runtime can be used to connect to data stores and compute services in public network with public accessible endpoints.
2. Azure Key Vault config is preferred versus password
