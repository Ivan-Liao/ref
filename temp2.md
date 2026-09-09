# Completed
1. Change the collaboration branch to Master in synapse studio Dev  - Completed
2. Take the copy of master branch in Dev (name master_backup_03_09_2026) - Completed
3. Delete all the component in master branch and keep empty - Completed
4. Create new feature branch (name Prod_synch_master_03_09_2026) - Completed
5. copy all the components from prod live mode and save it in Prod_synch_master_03_09_2026 - Completed
6. Merge Prod_synch_master_03_09_2026 to master branch using pull request - Completed
7. publish changes in studio master branch (Fix if any Issues occur) – Completed

# New Devops process
1. (Thursday 2026-09-03) Test the CICD pipeline (Fix if any Issues) – In progress.  
   1. Make a test case branch for the devops process.  This tests parameters, linked service, dataset, pipeline, notebook, trigger.  Save these as json files for future tests.  Deploy this branch.
   2. use Deploy to Dev
   3. verify Dev Live mode should be exactly the same as master branch components create excel sheet and compare the result In progress
   4. use Depoy to Prod
   5. verify Prod Live mode should be exactly the same as master branch components create excel sheet and compare the result In progress
2. (Friday 2026-09-04) Deploy Ivan's new simple branch for automated email orders not fulfilled pipeline.
3. (Friday 2026-09-04) Create new way of working document step by step screen shot – Not started yet
4. (Monday 2026-09-07) buffer time
5. (Tuesday 2026-09-08) Developers Workshop - Not started yet
    1.  Revoke PROD Contributor Access for all the developers at the end of meeting - Not started yet
6.  (Tuesday 2026-09-08) Sync live mode production with master branch  
    1.  Take the copy of master branch in Dev (name master_backup_03_09_2026) - Not started yet
    2.  Delete all the component in master branch and keep empty - Not started yet
    3.  Create new feature branch (name Prod_synch_master_03_09_2026) - Not started yet
    4.  copy all the components from prod live mode and save it in Prod_synch_master_03_09_2026 - Not started yet
    5.  Merge Prod_synch_master_03_09_2026 to master branch using pull request - Not started yet
    6.  publish changes in studio master branch (Fix if any Issues occur) – Not started yet
7.  (Wednesday 2026-09-08) All developers are able to use new process.  Ivan and Ram to provide support.

# Linked service cleanup (after new devops process)
1. Send Email to Developers for removing unused Linked Services in Dev,PROD - In progress
   1. Include naming conventions for future linked services
   2. Include the recommended linked service for various use cases. Or find existing documentation.
      1. A default ADLS linked service for the default storage account and container
      2. A new Synapse Analytics Synapse Serverless SQL pool linked service needs to be created for every lake database.  Unless this is parameterized.
2. Delete Unused Linked service in Dev and Prod - Not started yet
