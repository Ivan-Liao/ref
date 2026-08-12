WITH
-- Reusable list of "actionable" reason codes, defined once instead of
-- repeated in two separate IN(...) clauses.
reason_codes AS (
    SELECT Code
    FROM (VALUES
        ('300'),('310'),('320'),('340'),('370'),
        ('220'),('230'),('240'),('250'),('270'),
        ('500'),('510'),('520')
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
        f.FilledTime,
        f.Order_Packed_Date,
        f.Order_Packed_Time,
        f.Order_Shipped_Date,
        f.Order_Shipped_Time,
        f.Order_Delivered_Date,
        f.Order_Delivered_Time,
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
        -- Case 1: calibrated yesterday with an actionable reason code
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
ORDER BY fo.Ordered_Id;