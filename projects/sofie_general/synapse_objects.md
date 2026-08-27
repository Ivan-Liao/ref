# CICD

## Repo elements
1. synapse_cicd.yml
   1. $map for parameters
2. synapse_migration.yml
   1. previously had old workspace in a different RSG, had migrate to new dev workspace in same RSG as prod

## Deployment process
1. Create feature branch
2. Development on feature branch
3. PR to master branch (approval needed)
4. Merge to master branch 
5. Publish in Synapse develop workspace
   1. Switch to master branch
   2. Publish button
      1. Need to wait for success notifications
6. Run CI/CD pipeline Synapse_cicd with deployDev (what exactly does this code do?, isn't Dev workspace live mode already updated?)
   1. Consumes ARM templates generated in workspace_publish branch
   2. parameter deployDev
   3. Pipeline does not need approval
   4. Verify in live mode
   5. Takes around 5-10 minutes
7. Run CI/CD pipeline Synapse_cicd with deployProd (workspace_publish to prod live mode updates)
   1. Consumes ARM templates generated in workspace_publish branch
   2. parameter deployProd
   3. Pipeline needs not approval
   4. Verify in live mode

## Migration from Git Flow to Github Flow
1. master branch discrepancies are resolved
2. develop branch is merged to master branch one last time and then deleted
3. Future feature branches will be created from master

## Deployment process (deprecated)
1. Create feature branch
2. Development on feature branch
3. PR to develop branch (approval needed)
4. Merge to develop
   1. May want to uncheck delete feature branch
5. Validate in develop workspace
   1. switch to develop branch
   2. Publish in Synapse dev workspace
      1. Need to wait for notifications
   3. Verify in live mode
6. Run CI/CD pipeline Synapse_cicd with deployDev
   1. parameter deployDev
   2. Pipeline needs approval
   3. Can test in develop branch
   4. Takes around 5-10 minutes
7. PR from develop to master
8.  Run CI/CD pipeline Synapse_cicd with deployProd
   1. parameter deployDev
   2. Verify in live mode

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