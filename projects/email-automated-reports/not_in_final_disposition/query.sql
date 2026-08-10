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
        ROW_NUMBER() OVER (PARTITION BY OrderedID,ClientID ORDER BY LastModified DESC) AS OrderRank
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
        ProductID
    FROM order_ranking
    WHERE OrderRank = 1
)
,
reason_ranking AS (
    -- Rank each order's reason rows newest-first (by DT) so we can later
    -- isolate just the most recent reason per order.
    SELECT
        r.RecordID  AS ReasonOrderedID,
        rc.Code,
        ROW_NUMBER() OVER (PARTITION BY r.RecordID ORDER BY r.DT DESC) AS ReasonRank
    FROM master.reason r
    LEFT JOIN master.reasoncode rc
        ON rc.ReasonCodeID = r.ReasonCodeID
    WHERE r.TableName = 'ordered'
),
current_reason AS (
    -- Keep only the most recent reason (rank 1) per order.
    SELECT
        ReasonOrderedID,
        Code
    FROM reason_ranking
    WHERE ReasonRank = 1
)

SELECT
    -- COUNT(*)
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
WHERE 1=1                                          -- anchor; comment out filters below individually as needed
    AND s.ShipDate IS NULL                          -- not yet shipped (or no shipment record at all)
    AND r.Code IS NULL                              -- no current reason code found