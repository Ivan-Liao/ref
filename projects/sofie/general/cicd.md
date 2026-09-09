- [Repo elements](#repo-elements)
- [Naming conventions](#naming-conventions)
- [Deployment process](#deployment-process)
- [Migration from Git Flow to Github Flow Sept 2026](#migration-from-git-flow-to-github-flow-sept-2026)
  - [Migration steps](#migration-steps)
  - [Linked service cleanup (after new devops process)](#linked-service-cleanup-after-new-devops-process)
- [Deployment process (deprecated)](#deployment-process-deprecated)
- [Changelog](#changelog)
  - [2026-09-04](#2026-09-04)
  - [2026-09-02](#2026-09-02)


# Repo elements
1. synapse_cicd.yml
   1. $map for parameters
2. synapse_migration.yml
   1. previously had old workspace in a different RSG, had migrate to new dev workspace in same RSG as prod

# Naming conventions
1. Triggers
   1. Syntax: TR_<Pascal_Snake_Case>
   2. Example: TR_Master
2. Linked Service
   1. Syntax: LS_<Pascal_Snake_Case>
   2. Example: LS_Pipeline_Control
3. Dataset
   1. Syntax: <Pascal_Snake_Case>
   2. Example: Azure_Synapse_Analytics_BioRx
4. Pipeline
   1. Syntax: <optional_order_of_execution>_<optional_pipeline_type>_<Pascal_Snake_Case>_<Database_layer>
   2. Example: Alert_Pipeline
   3. Example: Master_Pipeline_LIMS
   4. Example: Power_BI_Refresh
   5. Example: 00_Parent_BioRx_Load
   6. Example: 01_Child_BioRx_Bronze_RAW
   7. Example: 02_Child_Salesforce_Silver_ODS
   8. Example: 03_Child_Salesforce_Gold_DIM
   9.  Example: 04_Child_BioRx_Shipment_Gold_FACT
5. Notebook
   1. Syntax: <Pascal_Snake_Case>
   2. Example: Build_Fact_BioRx_Dose


# Deployment process
1. Create a feature branch based on master
2. Development on feature branch
3. PR to master branch (approval needed)
4. Merged to master branch
5. Publish in Synapse develop workspace
   1. Switch to master branch
   2. Publish button
      1. Need to wait for success notifications
6. Run CI/CD pipeline Synapse_cicd with deployDev
   1. parameter deployDev
   2. Pipeline does not need approval
   3. Takes around 5-10 minutes
7. Run CI/CD pipeline Synapse_cicd with deployProd (workspace_publish to prod live mode updates)
   1. Consumes ARM templates generated in workspace_publish branch
   2. parameter deployProd
   3. Pipeline needs not approval
8. Additional Considerations
   1. If process is stable enough we can automate step 5-7
      1. What can go wrong when deploying to production
         1. Someone directly commits to master branch.  These changes will be caught by manual validation.
         2. Multiple people merge into master without deploying first.  There will confusion on when things are actually deployed.
<!-- TODO Power BI objects (DAX, dashboard objects) -->

# Migration from Git Flow to Github Flow Sept 2026

## Migration steps
1. - [x] (Wednesday 2026-09-02) develop branch is merged to master branch one last time and then deprecated
2. (Thursday 2026-09-03) Test the CICD pipeline (Fix if any Issues) – In progress.  
   1. - [x] Make a test case branch for the devops process.  This tests parameters, linked service, dataset, pipeline, notebook, trigger.  Save these as json files for future tests.  Deploy this branch.
      1. - [ ] Create retrieve_live_mode_json_objects.sh
   2. - [x] use Deploy to Dev
   3. - [x] verify Dev Live mode should be exactly the same as master branch components create excel sheet and compare the result In progress
   4. - [x] use Depoy to Prod
   5. - [x] verify Prod Live mode should be exactly the same as master branch components create excel sheet and compare the result In progress
3. - [x] (Friday 2026-09-04) Deploy Ivan's new simple branch for automated email orders not fulfilled pipeline.
4. - [ ] (Monday 2026-09-07) Create new way of working document step by step screen shot – Not started yet
5. - [ ] (Tuesday 2026-09-08) buffer time
6. - [ ] (Wednesday 2026-09-09) Developers Workshop - Not started yet
    1.  - [ ] Revoke PROD Contributor Access for all the developers at the end of meeting - Not started yet
7. - [ ] (Wednesday 2026-09-09) Sync live mode production with master branch  
    1. - [ ] Take the copy of master branch in Dev (name master_backup_03_09_2026) - Not started yet
    2. - [ ] Delete all the component in master branch and keep empty - Not started yet
    3. - [ ] Create new feature branch (name Prod_synch_master_03_09_2026) - Not started yet
    4. - [ ] copy all the components from prod live mode and save it in Prod_synch_master_03_09_2026 - Not started yet
    5. - [ ] Merge Prod_synch_master_03_09_2026 to master branch using pull request - Not started yet
    6. - [ ] publish changes in studio master branch (Fix if any Issues occur) – Not started yet
    7. - [ ] Delete develop branch
    8. - [ ] Cleanup feature branches and delete non active branches.
8. - [ ] (Thursday 2026-09-10) All developers are able to use new process.  Ivan and Ram to provide support.

## Linked service cleanup (after new devops process)
1. Send Email to Developers for removing unused Linked Services in Dev,PROD - In progress
   1. Include naming conventions for future linked services
   2. Include the recommended linked service for various use cases. Or find existing documentation.
      1. A default ADLS linked service for the default storage account and container
      2. A new Synapse Analytics Synapse Serverless SQL pool linked service needs to be created for every lake database.  Unless this is parameterized.
2. Delete Unused Linked service in Dev and Prod - Not started yet

# Deployment process (deprecated)
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
   2. Pipeline does not need approval
   3. Takes around 5-10 minutes
7. PR from develop to master (approval needed)
8. Run CI/CD pipeline Synapse_cicd with deployProd
   1. parameter deployDev
   2. Verify in live mode

# Changelog

## 2026-09-04
1. Synapse object naming conventions
2. Revised migration plans

## 2026-09-02
1. TODO sync with Elango
   1. Delete unused parameters
2. Collaboration branch will be changed to master
3. Checked parameters
   1. In review by Ram
   2. Some may need to be created anew to have the same shared name between dev and prod
   3. Existing pipelines can stay
4. Check Dataset 
5. First time sync for master from live mode