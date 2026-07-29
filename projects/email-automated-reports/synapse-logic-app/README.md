# Azure Synapse Extract

1. Create new pipeline
2. Copy Data activity
   1. Source
      1. Connector: Azure Synapse Analytics
      2. Linked service: points at the workspace's **built-in serverless SQL endpoint** (this is what makes the lake database tables queryable via T-SQL even though they're written by the Spark pool)
         1. sofiesyndev1-ondemand.sql.azuresynapse.net
         2. biwarp_biorx_mart
      3. Use query (not table) — write the join and column selection directly in SQL, e.g.:
         ```sql
         SELECT
            f.Ordered_Id                                    AS "Rx ID",
            s.LocationName                                AS "Pharmacy",
            p.Name                             AS "Product",
            c.Name                              AS "Client",
            rc.Code                              AS "Reason Code",
            rc.Description                      AS "Reason",
            f.Lot_Number                               AS "Lot Number",
            f.Flag_Bulk_Order                     AS "Multidose Order Flag",
            f.Flag_Redirected_Order                    AS "Redirected Order Flag",
            f.Amount                                 AS "Dose Activity",
            f.CalibrationDate                       AS "Cal Date",
            f.CalibrationTime                       AS "Cal Time",
            f.Order_Date                        AS "Order Date",
            f.Order_Time                        AS "Order Time",
            f.FilledDate                   AS "Filled Date",
            f.FilledTime                   AS "Filled Time",
            f.Order_Packed_Date                  AS "Packed Date",
            f.Order_Packed_Time                  AS "Packed Time",
            f.Order_Shipped_Date                  AS "Shipped Date",
            f.Order_Shipped_Time                  AS "Shipped Time",
            f.Order_Delivered_Date                  AS "Delivery Date",
            f.Order_Delivered_Time                  AS "Delivery Time"
         FROM biwarp_biorx_mart.dbo.f_ordered f
         JOIN biwarp_biorx_mart.dbo.dim_client c
            ON f.Client_SID = c.Client_SID
         JOIN biwarp_biorx_mart.dbo.dim_product p
            ON f.Product_SID = p.Product_SID
         JOIN biwarp_biorx_mart.dbo.dim_site s
            ON f.Location_SID = s.Locations_SID
         LEFT JOIN biwarp_biorx_mart.dbo.dim_reasoncode rc
            ON f.ReasonCode_SID = rc.ReasonCode_SID
         WHERE f.CalibrationDate = CAST(DATEADD(day, -1, GETDATE()) AS DATE)
         ```
      4. Adjust the join type (INNER/LEFT/etc.) and WHERE clause as needed depending on whether unmatched rows should be dropped or kept
   2. Sink: Azure Blob Storage dataset, format DelimitedText (CSV)
      1. Simpler than an ADLS Gen2 sink when you don't need hierarchical namespace, directory-level ACLs, or POSIX permissions
      2. First row as header: checked
      3. Filename convention: `orders_not_fulfilled_<YYYY-MM-DD>.csv`
3. Test flow to see the final joined csv file land in the storage container
4. Web activity action linked to Success path
   1. URL: HTTP POST URL from Logic App trigger
   2. Method: POST
   3. Body: {"status": "run"}
      1. Required even if data inside is not used or parsed
5. Add Trigger
   1. Type Schedule
6. Publish All

## Note on alternative approaches
- **Mapping Data Flow** (Source × N → Join → Select → Sink, run via an Execute Data Flow activity): use this instead of a SQL query when joins/transformations involve very large tables where Spark's distributed processing outperforms serverless SQL, or when transformations need row-level logic (conditional handling, complex string manipulation, deduplication) that's awkward to express in a single SQL statement. Adds Spark cluster startup latency each run.
- **ForEach + Copy Data over a table list** (Set Variable array → ForEach → parameterized Copy Data): use this for extracting a dynamic list of tables independently, one CSV per table, with no relationship between them. Doesn't apply once a join is involved, since a join needs specific, named tables present together rather than an arbitrary looped list.

For a straightforward join across a handful of known tables, the SQL query + single Copy Data activity above is the simplest and fastest path — no visual transformation UI, no Spark spin-up, one read, one write.


# Logic App
1. Consumption-based Logic App
2. Trigger when an HTTP request is received
3. Save the app immediately to generate a unique HTTP POST URL
4. Azure Blob Storage connector
   1. Get blob content (V2) and point to the container/blob path used by the Copy Data sink
5. Send an email (V2)
   1. To:
   2. Subject:
   3. Body:
   4. Add new parameter and check attachments
      1. File content dynamic token

# References
1. Watch file size as Office 365 Outlook caps attachments at roughly 20 - 35 MB
   1. Use SAS URL to the file instead of attaching raw CSV
```
Add a new action
Search for Azure Blob Storage connector and select Create SAS URI by path

In the new SAS action block, define how secure you want this link to be:

Blob path: Click the folder icon to browse to your container, or use a dynamic token if your Synapse pipeline passes the file name dynamically.

Permissions: Set this strictly to Read. You only want the email recipient to view/download the file, not overwrite or delete it.

Expiry Time: This field requires an ISO 8601 timestamp. Instead of hardcoding a date, click into the field, select the Expression tab, and enter this formula to make it valid for exactly 24 hours from the moment it runs:

addHours(utcNow(), 24)

Type out a friendly message, like: "Your automated Synapse report is ready. Click the link below to download it. This link will expire in 24 hours."

Under the text, look at the Dynamic Content pop-up box on the right.

Look under the Create SAS URI by path section and select Web URL. This inserts a token that will dynamically turn into your secure, tokenized download link when the email fires.
```