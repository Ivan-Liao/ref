# Repo elements
1. synapse_cicd.yml
   1. $map for parameters
2. synapse_migration.yml
   1. previously had old workspace in a different RSG, had migrate to new dev workspace in same RSG as prod

# Deployment process
1. Create feature branch
2. Development on feature branch
3. PR to master branch (approval needed)
4. Merge to master branch
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
   1. Possible to automate step 5-6
<!-- TODO Power BI objects (DAX, dashboard objects) -->

# Migration from Git Flow to Github Flow
1. develop branch is merged to master branch one last time and then deprecated
2. master branch discrepancies are resolved
   1. Objects in master branch, not in live mode
      1. Find the original developer and verify if the object should exist or should be deleted
      2. Wait till the end and redeploy from master branch to live mode
   2. Object not in master branch, in live mode
      1. New feature branch with objects in live mode
      2. Merge to master branch
3. Deploy master branch to live mode
4. Future feature branches will be created from master, delete the develop branch at this point
5. Cleanup feature branches, check creator, send out document, delete non active branches.
6. Training session for all developers

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