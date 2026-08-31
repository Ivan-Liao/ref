# Integration Datasets
1. AzureSynapseAnalyticsBioRx


# Linked Services
| Type | Name | Purpose |
| --- | --- | --- |
| Azure Blob Storage | biorxAzureBlobStorage1 | General blob storage |
| ADLS Gen2 | sofiesynprd1-WorkspaceDefaultStorage | General ADLS storage |
| Azure Synapse Analytics | LS_pipeline_control | This linked service is for connection to pipeline control table in lake database |
| Azure Synapse Analytics | ls_dev_pipeline_control | leftover artifact from dev |
| Azure Synapse Analytics | ls_syn_workspace | Likely redundant to ls_dev_pipeline_control |
| Azure Synapse Analytics | sofiesynprd1-WorkspaceDefaultSqlServer | |


1. AzureDataLakeStorage1
2. biorxAzureBlobStorage1


# Misc Questions
1. Do I need the new linked services?
2. dataset naming conventions
3. Create on prod env too?
4. Where does this dynamic Fully qualified domain name for linked service LS_pipeline_control reference?
   1.  `@{concat(linkedService().Workspace_Name,'-ondemand.sql.azuresynapse.net')}`