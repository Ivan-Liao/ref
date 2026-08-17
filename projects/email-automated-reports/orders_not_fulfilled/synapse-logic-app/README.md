# Azure Synapse csv Extract
Azure Synapse lake database > Synapse pipeline (ADLS read > ADLS sink)> Logic App > Email with csv attachment

# Synapse pipeline
1. Create new pipeline
2. Copy Data activity
   1. Source
      1. Connector: Azure Synapse Analytics
      2. Linked service: points at the workspace's **built-in serverless SQL endpoint** (this is what makes the lake database tables queryable via T-SQL even though they're written by the Spark pool)
         1. sofiesyndev1-ondemand.sql.azuresynapse.net
         2. biwarp_biorx_mart
      3. Use query (not table) — write the join and column selection directly in SQL, e.g.:
         ```sql
            WITH
            -- Reusable list of "actionable" reason codes, defined once instead of
            -- repeated in two separate IN(...) clauses later on.
            reason_codes AS (
               SELECT Code
               FROM (VALUES
                  ('300'),('310'),('320'),('340'),('370'),('220'),('230'),('240'),('250'),('270'),('500'),('510'),('520')
               ) AS rc(Code)
            ),
            -- Rank each order's reason rows newest-first (by DT) so we can later
            -- isolate just the most recent reason per order.
            reason_ranking AS (
               SELECT
                  r.RecordID      AS ReasonOrderedID,
                  r.ReasonCodeID,
                  r.DT            AS ReasonDT,
                  r.LocationGUID,
                  ROW_NUMBER() OVER (PARTITION BY r.RecordID, r.LocationGUID ORDER BY r.DT DESC) AS ReasonRank
               FROM biwarp_biorx_ods.dbo.reason r
               WHERE r.TableName = 'ordered'
                  -- DT is a datetime column and needs to be cast to date for the comparison
                  AND CAST(r.DT AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)
            ),
            current_reason AS (
               SELECT
                  ReasonOrderedID,
                  ReasonCodeID,
                  ReasonDT,
                  LocationGUID
               FROM reason_ranking
               WHERE ReasonRank = 1
            ),
            -- Filter + dedupe FIRST, joining only the tables needed to evaluate the
            -- WHERE clause (dim_site for LocationGUID, dim_reasoncode for Code,
            -- current_reason for ReasonDT). This keeps row counts small before we
            -- bring in the purely cosmetic dimension joins below.
            filtered_orders AS (
               SELECT
                  f.Ordered_Id,
                  f.Location_SID,
                  f.Client_SID,
                  f.Product_SID,
                  f.Procedure_SID,
                  f.ReasonCode_SID,
                  f.Lot_Number,
                  f.Flag_Bulk_Order,
                  f.Flag_Redirected_Order,
                  f.Amount,
                  f.CalibrationDate,
                  f.CalibrationTime,
                  f.Order_Date,
                  f.Order_Time,
                  f.FilledDate,
                  CAST(f.FilledTime AS TIME) AS  FilledTime,
                  f.Order_Packed_Date,
                  CAST(f.Order_Packed_Time AS TIME) AS Order_Packed_Time,
                  f.Order_Shipped_Date,
                  CAST(f.Order_Shipped_Time AS TIME) AS Order_Shipped_Time,
                  f.Order_Delivered_Date,
                  CAST(f.Order_Delivered_Time AS TIME) AS Order_Delivered_Time,
                  cr.ReasonDT,
                  ROW_NUMBER() OVER (
                        PARTITION BY f.Ordered_Id
                        ORDER BY f.LastModified DESC
                  ) AS OrderRank
               FROM biwarp_biorx_mart.dbo.f_ordered f
               LEFT JOIN biwarp_biorx_mart.dbo.dim_site s
                  ON f.Location_SID = s.Locations_SID
               LEFT JOIN biwarp_biorx_mart.dbo.dim_reasoncode rc
                  ON f.ReasonCode_SID = rc.ReasonCode_SID
               LEFT JOIN current_reason cr
                  ON f.Ordered_Id = cr.ReasonOrderedID
                  AND s.LocationGUID = cr.LocationGUID
               WHERE
                  -- Case 1: calibrated yesterday with a reason code
                  (
                        f.CalibrationDate = CAST(DATEADD(day, -1, GETDATE()) AS DATE)
                        AND rc.Code IN (SELECT Code FROM reason_codes)
                  )
                  -- Case 2: calibrated in the last 14 days, with a recent (non-null)
                  -- reason recorded, also carrying an actionable reason code
                  OR (
                        f.CalibrationDate BETWEEN
                           CAST(DATEADD(day, -14, GETDATE()) AS DATE)
                           AND CAST(DATEADD(day, -1, GETDATE()) AS DATE)
                        AND cr.ReasonDT IS NOT NULL
                        AND rc.Code IN (SELECT Code FROM reason_codes)
                  )
            )
            -- Attach the display-only dimensions and keep just the most recent
            -- version of each order.
            SELECT
               fo.Ordered_Id                      AS "RxID",
               s.LocationName                     AS "Pharmacy",
               p.Name                             AS "Product",
               procedures.Name                    AS "Procedure",
               c.Name                             AS "Client",
               rc.Code                            AS "Reason Code",
               rc.Description                     AS "Reason",
               fo.ReasonDT                        AS "ReasonDT",
               fo.Lot_Number                      AS "LotNumber",
               fo.Flag_Bulk_Order                 AS "MultidoseOrderFlag",
               fo.Flag_Redirected_Order           AS "RedirectedOrderFlag",
               fo.Amount                          AS "DoseActivity",
               fo.CalibrationDate                 AS "CalDate",
               fo.CalibrationTime                 AS "CalTime",
               fo.Order_Date                      AS "OrderDate",
               fo.Order_Time                      AS "OrderTime",
               fo.FilledDate                      AS "FilledDate",
               fo.FilledTime                      AS "FilledTime",
               fo.Order_Packed_Date               AS "PackedDate",
               fo.Order_Packed_Time               AS "PackedTime",
               fo.Order_Shipped_Date              AS "ShippedDate",
               fo.Order_Shipped_Time              AS "ShippedTime",
               fo.Order_Delivered_Date            AS "DeliveryDate",
               fo.Order_Delivered_Time            AS "DeliveryTime"
            FROM filtered_orders fo
            LEFT JOIN biwarp_biorx_mart.dbo.dim_client c
               ON fo.Client_SID = c.Client_SID
            LEFT JOIN biwarp_biorx_mart.dbo.dim_product p
               ON fo.Product_SID = p.Product_SID
            LEFT JOIN biwarp_biorx_mart.dbo.dim_site s
               ON fo.Location_SID = s.Locations_SID
            LEFT JOIN biwarp_biorx_mart.dbo.dim_reasoncode rc
               ON fo.ReasonCode_SID = rc.ReasonCode_SID
            LEFT JOIN biwarp_biorx_mart.dbo.dim_procedures procedures
               ON fo.Procedure_SID = procedures.Procedures_SID
            WHERE fo.OrderRank = 1
            ORDER BY s.LocationName,fo.CalibrationDate DESC;
         ;
         ```
   2. Sink: ADLS Gen2 sink
      1. Linked service: sofiesyndev1-WorkspaceDefaultStorage
      2. First row as header: checked
      3. Sink dataset name: SnapshotOrdersNotFulfilled
      4. Filename convention: `orders_not_fulfilled_<YYYY-MM-DD>.csv`
         1. @concat('filename_', formatDateTime(addDays(utcNow(), -1), 'yyyy-MM-dd'), '.csv')
3. Test flow to see the final joined csv file land in the storage container



# Logic App
1. Consumption-based Logic App
2. New trigger: "when an HTTP request is received"
   1. HTTP URL generated upon save
3. Save the app immediately to generate a unique HTTP POST URL
4. Azure Data Lake: Read File
   1. Storage account name
   2. File path with filename expression
      1. concat('orders_not_fulfilled_', formatDateTime(addDays(utcNow(), -1), 'yyyy-MM-dd'), '.csv')
   3. Get blob content (V2) and point to the container/blob path used by the Copy Data sink
5. Office 365 Outlook: Send an email (V2) 
   1. To:
   2. Subject:
   3. Body:
   4. Add new parameter and check attachments
      1. File content dynamic token

# Back to Synapse pipeline
1. Add Web activity action linked to Success path
   1. URL: HTTP POST URL from Logic App trigger
   2. Method: POST
   3. Body: {"status": "run"}
      1. Required even if data inside is not used or parsed
2. Add Trigger
   1. Type Schedule
3. Publish All

# Productionization
1. 

# References

## Note on alternative approaches
1. Watch file size as Office 365 Outlook caps attachments at roughly 20 - 35 MB
   1. Use SAS URL to the file instead of attaching raw CSV
```
# for creating a file URI
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