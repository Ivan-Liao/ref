## 6.5 New Dashboard Workflow
1. **Developer**: Builds the new dashboard. When development is done, publishes it to the QA workspace.
   1. Create dashboard from Power BI semantic model PB_Order_Analytics
   2. Products sold month over month
      1. x-axis: Date Calendar > Month
      2. y-axis: f_ordered> Count of Ordered_ID
      3. Legend: dim_product > Name
   3. Save as QA_Order_Trends.pbix
2. **Developer**: Handles QA validation with stakeholders.
   1. Publish dashboard in Power BI (QA) Workspace
   2. If validation fails, the dashboard goes back to development.
3. **Admin**: Performs QA validation as gatekeeper.
   1. If validation fails, the dashboard goes back to development.
4. **Admin**: On validation success, performs Prod dashboard versioning.
   1. Notify the developer and verify all changes are published.  Then downloads the file from the QA workspace.
   2. Uploads the file to the SharePoint Prod folder with the correct file naming convention.
   3. Documents the changelog in the versioning spreadsheet.
5. **Prod Publisher**: Publishes to the Prod workspace.
   1. Downloads the file from SharePoint.
   2. Logs into publishing service account
   3. Publishes from Power BI Desktop.

## 6.6 New Feature Workflow
1. **Developer**: Builds the new feature on an existing dashboard. When development is done, publishes it to the QA workspace.
2. The remaining steps are the same as steps 2 to 5 of the New Dashboard Workflow (6.5). If validation fails, the feature goes back to development.

## 6.7 Revert Version Workflow
1. A revert version request is raised from the Developer and Stakeholders with approval from upper level management.
2. **Admin**: Finds the dated archived file that corresponds to the right version.
3. **Admin**: Performs Prod dashboard reversion.
   1. Takes the archived dashboard and renames it as the Prod dashboard.
   2. Archives the problematic dashboard.
4. **Prod Publisher**: Publishes to the Prod workspace.
   1. Downloads the file from SharePoint.
   2. Publishes from Power BI Desktop.