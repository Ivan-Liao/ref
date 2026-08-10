SELECT Filter_Flag,
    orderedid,
    Redirected_Order,
    Reason_Code,
    Client_Name,
    LocationGuid,
    PharmacyName,
    Calibration_Date,
    Order_Filled_Date,
    Order_Filled_Time,
    Order_Packed_Date,
    Order_Packed_Time,
    Order_Shipped_Date,
    Order_Shipped_Time,
    Order_Delivered_Date,
    Order_Delivered_Time,
    Order_ShipContainer_ID,
    Ordered_Amount,
    Filled_Flag,
    Packed_Flag,
    Shipped_Flag,
    Delivered_Flag
FROM (
        SELECT CASE
                WHEN (
                    r.code IN (
                        125,
                        001,
                        002,
                        003,
                        004,
                        012,
                        018,
                        022,
                        032,
                        100,
                        120,
                        130,
                        200,
                        210,
                        220,
                        260
                    )
                    OR (
                        shpmnt.Order_Packed_Date IS NULL
                        AND r.code IS NULL
                        AND (
                            rd.Redirected_Order IS NULL
                            OR r.code = "240"
                        )
                    )
                ) THEN 'NO - Reject'
                ELSE 'YES '
            END AS Filter_Flag,
            od.deleted,
            od.orderedid,
            CASE
                WHEN Bulkod.Flag_Bulk_Order IS NOT NULL THEN 'Yes'
                ELSE 'No'
            END AS Flag_Bulk_Order,
            rd.Redirected_Order,
            od.clientID AS Client_ID,
            r.code AS Reason_Code,
            r.Description AS Reason_Desc,
            r.reasonid,
            cl.Name AS Client_Name,
            od.LocationGUID AS LocationGuid,
            site.LocationName AS PharmacyName,
            od.ProductID AS Product_ID,
            p.Name AS Product_Name,
            pr.Name AS Procedure_Name,
            od.RouteID AS RouteID,
            route.RouteTime AS Route_Time,
            CASE
                WHEN route.Description IS NOT NULL THEN route.Name
                ELSE CONCAT(route.Name, '-', route.Description)
            END AS Route_Name,
            CASE
                WHEN od.PONumber IS NOT NULL THEN 'NA'
                ELSE od.PONumber
            END AS PO_Number,
            od.orderDate AS Order_Date,
            od.OrderTime AS Order_Time,
            od.CalibrationDate AS Calibration_Date,
            CASE
                WHEN Bulkod.Flag_Bulk_Order IS NOT NULL THEN (Bulkod.CalibrationTime)
                ELSE od.CalibrationTime
            END AS Calibration_Time,
            od.FilledDate AS Order_Filled_Date,
            od.FilledTime AS Order_Filled_Time,
            shpmnt.Order_Packed_Date AS Order_Packed_Date,
            shpmnt.Order_Packed_Time AS Order_Packed_Time,
            shpmnt.Order_Shipped_Date AS Order_Shipped_Date,
            shpmnt.Order_Shipped_Time AS Order_Shipped_Time,
            shpmnt.Order_Delivered_Date AS Order_Delivered_Date,
            shpmnt.Order_Delivered_Time AS Order_Delivered_Time,
            od.ShipContainerID AS Order_ShipContainer_ID,
            od.Quantity AS Ordered_Quantity,
            od.Amount AS Ordered_Amount,
            CASE
                WHEN od.FilledDate IS NOT NULL THEN "Yes"
                ELSE "No"
            END AS Filled_Flag,
            CASE
                WHEN shpmnt.Order_Packed_Date IS NOT NULL THEN "Yes"
                ELSE "No"
            END AS Packed_Flag,
            CASE
                WHEN shpmnt.Order_Shipped_Date IS NOT NULL THEN "Yes"
                ELSE "No"
            END AS Shipped_Flag,
            CASE
                WHEN shpmnt.Order_Delivered_Date IS NOT NULL THEN "Yes"
                ELSE "No"
            END AS Delivered_Flag
        FROM (
                SELECT *
                FROM ordered od
                WHERE CalibrationDate >= DATE_SUB(CAST(sysdate() AS DATE), INTERVAL 14 DAY)
                    /* AND LocationGUID = 'B8E5FFE1-D87E-46DE-90C2-5C1262A301B0' 
                                                  -- orderedid = '70858'
                                                  -- AND productid = 17 */
            ) od
            LEFT OUTER JOIN (
                SELECT ob.orderedid,
                    ob.locationGuid,
                    AVG(ob.CalAmount) AS Amount,
                    MIN(ob.caltime) AS CalibrationTime,
                    'Yes' AS Flag_Bulk_Order
                FROM master.orderedbulk ob
                WHERE Deleted = 0
                GROUP BY ob.orderedid,
                    ob.locationGuid
            ) Bulkod ON (
                od.OrderedID = Bulkod.orderedid
                AND od.LocationGUID = Bulkod.locationGuid
            )
            LEFT OUTER JOIN (
                SELECT rd.orderedID AS Origin_Orderid,
                    rd.ExchangedID AS Delegated_Orderid,
                    l.LocationGUID AS Origin_Pharmacy,
                    rd.FacilityName AS Delegated_Pharmacy,
                    DATE(TransmissionDT) AS Transmission_Date,
                    'Yes' AS Redirected_Order
                FROM master.orderedredirect rd
                    INNER JOIN master.locations l ON (rd.LocationGUID = l.LocationGUID)
                    INNER JOIN (
                        SELECT rdf.LocationGUID,
                            rdf.OrderedID,
                            MAX(rdf.CreatedDT) AS MaxCreatedDT
                        FROM (
                                SELECT *
                                FROM orderedredirect
                                WHERE OrderedID IS NOT NULL
                                    AND ExchangedID IS NOT NULL
                                    AND Deleted = 0
                            ) rdf
                        WHERE rdf.orderedID IS NOT NULL
                            AND rdf.ExchangedID IS NOT NULL
                            AND rdf.Deleted = 0
                        GROUP BY rdf.LocationGUID,
                            rdf.OrderedID
                    ) rd_max ON (
                        rd.orderedID = rd_max.orderedID
                        AND rd.LocationGUID = rd_max.LocationGUID
                        AND rd.CreatedDT = rd_max.MaxCreatedDT
                    )
            ) rd ON (
                od.orderedid = rd.Origin_Orderid
                AND od.LocationGUID = rd.Origin_Pharmacy
            )
            LEFT OUTER JOIN master.locations site ON (od.LocationGUID = site.LocationGUID)
            LEFT OUTER JOIN master.client cl ON (od.clientid = cl.clientid)
            LEFT OUTER JOIN master.product p ON(od.ProductID = p.Product)
            LEFT OUTER JOIN master.procedures pr ON(od.ProcedureID = pr.ProcedureID)
            LEFT OUTER JOIN master.routes route ON(
                od.RouteID = route.RouteID
                AND od.LocationGUID = route.LocationGUID
            )
            LEFT OUTER JOIN (
                SELECT sc.shipcontainerid,
                    sc.PackedDate AS Order_Packed_Date,
                    sc.PackedTime AS Order_Packed_Time,
                    sh.ShipDate AS Order_Shipped_Date,
                    sh.ShipTime AS Order_Shipped_Time,
                    sc.DeliveredDate AS Order_Delivered_Date,
                    sc.DeliveredTime AS Order_Delivered_Time,
                    sc.LocationGUID
                FROM master.shipcontainer sc
                    LEFT OUTER JOIN master.shipment sh ON (
                        sh.ShipmentID = sc.DeliveredShipmentID
                        AND sc.LocationGUID = sh.LocationGUID
                    )
            ) shpmnt ON(
                od.shipcontainerid = shpmnt.shipcontainerid
                AND od.LocationGUID = shpmnt.LocationGUID
            )
            LEFT OUTER JOIN (
                SELECT r.reasonid,
                    r.LocationGUID,
                    r.recordid AS reason_Orderid,
                    r.REASONCODEID,
                    rc.code,
                    rc.Description
                FROM master.reason r
                    INNER JOIN (
                        SELECT r.LocationGUID,
                            recordid,
                            MAX(r.ReasonID) AS ReasonID,
                            MAX(r.DT) AS DT
                        FROM master.reason r
                        WHERE r.DELETED = 0
                            AND r.TableName = 'ordered'
                        GROUP BY r.LocationGUID,
                            r.recordid
                    ) r_max ON (
                        r.LocationGUID = r_max.LocationGUID
                        AND r.RecordID = r_max.recordid
                        AND r.DT = r_max.DT
                        AND r.ReasonID = r_max.ReasonID
                    )
                    INNER JOIN master.reasoncode rc ON(r.reasoncodeid = rc.reasoncodeid)
                WHERE r.Deleted = 0
                    AND r.TableName = 'ordered'
            ) r ON (
                r.reason_Orderid = od.OrderedID
                AND r.LocationGUID = od.LocationGUID
            )