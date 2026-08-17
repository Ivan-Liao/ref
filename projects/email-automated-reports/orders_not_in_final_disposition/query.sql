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
        ProductID
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
    o.CalibrationTime,
    sc.ShipContainerID AS sc_ShipContainerID,
    sc.LocationGUID AS sc_LocationGUID,
    o.ShipContainerID AS o_ShipContainerID,
    o.LocationGUID AS o_LocationGUID,
    s.ShipmentID AS s_ShipmentID,
    sc.ShipmentID AS sc_ShipmentID,
    s.LocationGUID AS s_LocationGUID,
    l.LocationGUID AS l_LocationGUID,
    p.Product AS p_Product,
    o.ProductID AS o_ProductID,
    c.ClientID AS c_ClientID,
    o.ClientID AS o_ClientID,
    r.ReasonOrderedID AS r_ReasonOrderedID,
    r.LocationGUID AS r_LocationGUID

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
WHERE 1=1                                          -- anchor; comment out filters below individually as needed
    AND s.ShipDate IS NULL                          -- not yet shipped (or no shipment record at all)
    AND r.Code IS NULL                              -- no current reason code found

