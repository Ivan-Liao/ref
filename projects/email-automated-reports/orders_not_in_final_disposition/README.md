## Solution
```sql
-- Note that due to latency the 1k + orders of the current day will come through
WITH order_ranking AS (
    SELECT
        OrderedID,
        CalibrationDate,
        CalibrationTime,
        ShipContainerID,
        LocationGUID,
        ClientID,
        ProductID,
        Deleted,
        Processed,
        Filled,
        ROW_NUMBER() OVER (PARTITION BY OrderedID, LocationGUID ORDER BY LastModified DESC) AS OrderRank
    FROM biwarp_biorx_ods.dbo.ordered
    WHERE CalibrationDate >= DATEADD(day, -14, CAST(GETDATE() AS DATE)) -- calibration date range testing
        AND CalibrationDate <= CAST(GETDATE() AS DATE) -- only orders calibrated today
),current_order AS (
    -- Keep only the most recent order (rank 1) per order.
    SELECT
        OrderedID,
        CalibrationDate,
        CalibrationTime,
        ShipContainerID,
        LocationGUID,
        ClientID,
        ProductID,
        Deleted,
        Processed,
        Filled
    FROM order_ranking
    WHERE OrderRank = 1
),reason_ranking AS (
    -- Rank each order's reason rows newest-first (by DT) so we can later
    -- isolate just the most recent reason per order.
    SELECT
        r.RecordID  AS ReasonOrderedID,
        r.LocationGUID,
        rc.Code,
        ROW_NUMBER() OVER (PARTITION BY r.RecordID,r.LocationGUID ORDER BY r.DT DESC) AS ReasonRank
    FROM biwarp_biorx_ods.dbo.reason r
    LEFT JOIN biwarp_biorx_ods.dbo.reasoncode rc
        ON rc.ReasonCodeID = r.ReasonCodeID
    WHERE r.TableName = 'ordered'
),current_reason AS (
    -- Keep only the most recent reason (rank 1) per order.
    SELECT
        ReasonOrderedID,
        Code,
        LocationGUID
    FROM reason_ranking
    WHERE ReasonRank = 1
)
SELECT
    o.OrderedID     AS RxID,
    l.LocationName  AS Pharmacy,
    p.Name          AS Product,
    c.Name          AS Client,
    o.CalibrationDate,
    o.CalibrationTime
FROM current_order o
    -- Shipment chain: used only to check whether the order has shipped.
    LEFT JOIN biwarp_biorx_ods.dbo.shipcontainer sc
        ON sc.ShipContainerID = o.ShipContainerID
        AND sc.LocationGUID = o.LocationGUID
    LEFT JOIN biwarp_biorx_ods.dbo.shipment s
        ON s.ShipmentID = sc.ShipmentID
        AND s.LocationGUID = o.LocationGUID
    LEFT JOIN biwarp_biorx_ods.dbo.locations l
        ON l.LocationGUID = o.LocationGUID
    LEFT JOIN biwarp_biorx_ods.dbo.product p
        ON p.Product = o.ProductID
        AND p.RECORD_ACTIVE_FLAG = 'Y'
    LEFT JOIN biwarp_biorx_ods.dbo.client c
        ON c.ClientID = o.ClientID
        AND c.RECORD_ACTIVE_FLAG = 'Y'
    -- Most recent 'ordered' reason per order, if any.
    LEFT JOIN current_reason r
        ON r.ReasonOrderedID = o.OrderedID
        AND r.LocationGUID = l.LocationGUID
    LEFT JOIN biwarp_biorx_ods.dbo.orderedredirect ore
        ON ore.OrderedID = o.OrderedID
        AND ore.LocationGUID = o.LocationGUID
WHERE 1=1                                          -- anchor; comment out filters below individually as needed
    AND s.ShipDate IS NULL                          -- not yet shipped (or no shipment record at all)
    AND r.Code IS NULL                              -- no current reason code found
    AND o.Deleted = 0
    AND o.Processed not in (1, -2)
    AND o.Filled <> 1
    AND ore.ExchangedID IS NULL
```

## Solution on replication server
```sql
-- =========================================================================
-- Orders calibrated today, that have not been shipped, with no current reason code
-- =========================================================================
-- Gets most recent ordered row
WITH order_ranking AS (
    SELECT
        OrderedID,
        CalibrationDate,
        CalibrationTime,
        ShipContainerID,
        LocationGUID,
        ClientID,
        ProductID,
        Deleted,
        Processed,
        Filled,
        ROW_NUMBER() OVER (PARTITION BY OrderedID,LocationGUID ORDER BY LastModified DESC) AS OrderRank
    FROM master.ordered
    WHERE CalibrationDate >= DATE_ADD(CAST(NOW() AS DATE), INTERVAL -14 DAY) -- calibration date range testing
        AND CalibrationDate <= CAST(NOW() AS DATE) -- only orders calibrated today
),current_order AS (
    -- Keep only the most recent order (rank 1) per order.
    SELECT
        OrderedID,
        CalibrationDate,
        CalibrationTime,
        ShipContainerID,
        LocationGUID,
        ClientID,
        ProductID,
        Deleted,
        Processed,
        Filled
    FROM order_ranking
    WHERE OrderRank = 1
)
,
reason_ranking AS (
    -- Rank each order's reason rows newest-first (by DT) so we can later
    -- isolate just the most recent reason per order.
    SELECT
        r.RecordID  AS ReasonOrderedID,
        r.LocationGUID AS LocationGUID,
        rc.Code,
        ROW_NUMBER() OVER (PARTITION BY r.RecordID,r.LocationGUID ORDER BY r.DT DESC) AS ReasonRank
    FROM master.reason r
    LEFT JOIN master.reasoncode rc
        ON rc.ReasonCodeID = r.ReasonCodeID
    WHERE r.TableName = 'ordered'
),
current_reason AS (
    -- Keep only the most recent reason (rank 1) per order.
    SELECT
        ReasonOrderedID,
        Code,
        LocationGUID
    FROM reason_ranking
    WHERE ReasonRank = 1
)
SELECT
    o.OrderedID     AS RxID,
    l.LocationName  AS Pharmacy,
    p.Name          AS Product,
    c.Name          AS Client,
    o.CalibrationDate,
    o.CalibrationTime
FROM current_order o
    -- Shipment chain: used only to check whether the order has shipped.
    LEFT JOIN master.shipcontainer sc
        ON sc.ShipContainerID = o.ShipContainerID
        AND sc.LocationGUID = o.LocationGUID
    LEFT JOIN master.shipment s
        ON s.ShipmentID = sc.ShipmentID
        AND s.LocationGUID = o.LocationGUID
    LEFT JOIN master.locations l
        ON l.LocationGUID = o.LocationGUID
    LEFT JOIN master.product p
        ON p.Product = o.ProductID
    LEFT JOIN master.client c
        ON c.ClientID = o.ClientID
    -- Most recent 'ordered' reason per order, if any.
    LEFT JOIN current_reason r
        ON r.ReasonOrderedID = o.OrderedID
        AND r.LocationGUID = l.LocationGUID
    LEFT JOIN master.orderedredirect ore
    	ON ore.OrderedID = o.OrderedID
    	AND ore.LocationGUID = o.LocationGUID
WHERE 1=1                                          -- anchor; comment out filters below individually as needed
    AND s.ShipDate IS NULL                          -- not yet shipped (or no shipment record at all)
    AND r.Code IS NULL                              -- no current reason code found
    AND o.Deleted = 0
    AND ore.ExchangedID IS null
    AND o.Processed not in (1, -2)
```