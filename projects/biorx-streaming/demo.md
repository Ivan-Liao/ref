- [Commands](#commands)
  - [Database](#database)
- [MariaDB setup](#mariadb-setup)
  - [ordered\_demo table](#ordered_demo-table)
  - [shipcontainer\_demo table](#shipcontainer_demo-table)
- [Ordered](#ordered)
- [Flatten function](#flatten-function)
- [Ordered\_Flattened](#ordered_flattened)
- [Materialized view](#materialized-view)
- [Questions](#questions)

# Commands
## Database
```
INSERT INTO ordered_demo (
    OrderedID,
    LocationGUID,
    PatientName,
    Filled,
    FilledByID,
    FilledDate,
    FilledTime,
    CalibrationDate,
    CalibrationTime,
    ShipContainerID
)
VALUES (
    99999998,
    '550e8400-e29b-41d4-a716-446655440000',
    'Jerry Doe',
    0,
    0,
    null,
    '00:00:00',
    '2026-07-16',
    '14:00:00',
    99999998
);

UPDATE ordered_demo
set Filled = 1
where OrderedID = 99999998
;

INSERT INTO shipcontainer_demo (
    ShipContainerID,
    LocationGUID,
    ContainerNumber,
    DeliveryDate,
    DeliveryTime,
    PackedDate,
    PackedTime
)
VALUES (
    99999998,
    '550e8400-e29b-41d4-a716-446655440000',
    0,
    null,
    null,
    '2026-07-16',
    '12:00:00'
);

UPDATE shipcontainer_demo
set PackedDate = '2026-07-16',
    PackedTime = '12:00:00'
where ShipContainerID = 99999998
;

UPDATE shipcontainer_demo
set DeliveredDate = '2026-07-16',
    DeliveredTime = '14:00:00'
where ShipContainerID = 99999998
;

```

# MariaDB setup
## ordered_demo table
## shipcontainer_demo table
create table ordered_demo as (
    select * 
    from ordered
    where DATE(DeliveryDate) > DATE_SUB(CURDATE(), INTERVAL 3 DAY)
);

create table shipcontainer_demo as (
    select * 
    from shipcontainer
    where DATE(DeliveryDate) > DATE_SUB(CURDATE(), INTERVAL 3 DAY)
);

# Ordered
```
{
    "before": null,
    "after": {
        "OrderedID": 149407,
        "ClientID": 1064,
        "ClientBillID": -1,
        "OrderClientID": 1064,
        "ProductID": 18,
        "AllowedID": 1893,
        "ProcedureID": 4,
        "Amount": 9,
        "Units": "mCi",
        "CalibrationTime": 41400000000,
        "PatientName": "Jose Cruz",
        "PONumber": "",
        "PhysicianID": 2789,
        "ReferringPhysicianID": 1759,
        "OrderedByID": 2872,
        "OrderDate": 20465,
        "OrderTime": 13495000000,
        "OrderTakenByID": 1459,
        "Filled": 1,
        "FilledByID": 895,
        "FilledDate": 20465,
        "FilledTime": 25086000000,
        "Quantity": 1,
        "ActualActivity": 9.9,
        "ActualActivityUnits": "mCi",
        "ActualVolume": 1.039,
        "ActualVolumeUnits": "ml",
        "ActualSalineAdded": 0,
        "ActualTotalVolume": 0.945,
        "ActualQuantity": 1,
        "ShipContainerID": 42306,
        "Returned": 0,
        "BioDoseScheduleID": null,
        "ReturnedByID": null,
        "ReturnedQuantity": null,
        "ReturnedDate": null,
        "ReturnedTime": null,
        "Processed": 1,
        "ProcessedByID": 895,
        "ProcessedDate": 20465,
        "ProcessedTime": 25086000000,
        "Billed": null,
        "BilledByID": null,
        "BilledDate": null,
        "BilledTime": null,
        "PriceID": 0,
        "PriceOverriden": 0,
        "Price": null,
        "StatementID": null,
        "AmountBilled": null,
        "AmountCredit": null,
        "Paid": null,
        "DatePaid": null,
        "AmountPaid": null,
        "Adjustment": null,
        "Deleted": 0,
        "DeliveryDate": 20465,
        "DeliveryTime": 26100000000,
        "DeliverByTime": 27000000000,
        "DeliveryTypeID": 0,
        "RouteID": 8,
        "CalibrationDate": 20465,
        "ContainerID": 1,
        "Tax": null,
        "Tax2": null,
        "Tax3": null,
        "Notes": "",
        "PrepFee": null,
        "PharmacistID": 1459,
        "Synced": 1,
        "LocationGUID": "f92ab1da-3631-4ba8-bb0f-e8cc0ee16b7f",
        "SalineInventoryID": 0,
        "Weight": 0,
        "WeightUnits": "lbs",
        "ExpirationDate": 20465,
        "ExpirationTime": 60240000000,
        "ProposedInventoryID": 3153,
        "LastModified": 1768214059000
    },
    "ts_ms": 1784100357565,
    "ts_us": 1784100357565573,
    "ts_ns": "1784100357565573663",
    "source": {
        "version": "3.4.0.Final",
        "connector": "mysql",
        "name": "cdc.mysql",
        "ts_ms": 1784097136000,
        "snapshot": "true",
        "db": "master",
        "sequence": null,
        "ts_us": 1784097136000000,
        "ts_ns": "1784097136000000000",
        "table": "ordered_demo",
        "server_id": 0,
        "gtid": null,
        "file": "mariadb-bin.000006",
        "pos": 463933262,
        "row": 0,
        "thread": null,
        "query": null
    },
    "transaction": null,
    "op": "r"
}
```

# Flatten function
```
{
    Ordered
    | extend p = todynamic(payload)
    | where tostring(p.source.table) == "ordered_demo"
    | where tostring(p.op) in ("r", "c", "u", "d")
    | extend row_data = coalesce(
        todynamic(p.after),
        todynamic(p.before)
    )
    | project
        CDCOperation = tostring(p.op),

        CDCOperationDescription = case(
            tostring(p.op) == "r", "Snapshot",
            tostring(p.op) == "c", "Insert",
            tostring(p.op) == "u", "Update",
            tostring(p.op) == "d", "Delete",
            "Unknown"
        ),

        CDCEventTime =
            unixtime_milliseconds_todatetime(
                tolong(p.ts_ms)
            ),

        SourceEventTime =
            unixtime_milliseconds_todatetime(
                tolong(p.source.ts_ms)
            ),

        EventSequenceNs = coalesce(
            tolong(p.ts_ns),
            tolong(p.ts_ms) * 1000000
        ),

        SourceDatabase = tostring(p.source.db),
        SourceTable = tostring(p.source.table),
        IsSnapshot = tostring(p.source.snapshot),
        BinlogFile = tostring(p.source.file),
        BinlogPosition = tolong(p.source.pos),
        BinlogRow = toint(p.source.row),
        CDCServerId = tolong(p.source.server_id),

        IsDeleted =
            tostring(p.op) == "d"
            or toint(row_data.Deleted) == 1,

        OrderedID = tolong(row_data.OrderedID),
        ClientID = tolong(row_data.ClientID),
        ClientBillID = tolong(row_data.ClientBillID),
        OrderClientID = tolong(row_data.OrderClientID),
        ProductID = tolong(row_data.ProductID),
        AllowedID = tolong(row_data.AllowedID),
        ProcedureID = tolong(row_data.ProcedureID),
        Amount = todouble(row_data.Amount),
        Units = tostring(row_data.Units),

        CalibrationTime =
            tolong(row_data.CalibrationTime) / 1000 * 1ms,

        PatientName = tostring(row_data.PatientName),
        PONumber = tostring(row_data.PONumber),
        PhysicianID = tolong(row_data.PhysicianID),

        ReferringPhysicianID =
            tolong(row_data.ReferringPhysicianID),

        OrderedByID = tolong(row_data.OrderedByID),

        OrderDate =
            datetime(1970-01-01)
            + tolong(row_data.OrderDate) * 1d,

        OrderTime =
            tolong(row_data.OrderTime) / 1000 * 1ms,

        OrderTakenByID =
            tolong(row_data.OrderTakenByID),

        Filled = toint(row_data.Filled),
        FilledByID = tolong(row_data.FilledByID),

        FilledDate =
            datetime(1970-01-01)
            + tolong(row_data.FilledDate) * 1d,

        FilledTime =
            tolong(row_data.FilledTime) / 1000 * 1ms,

        Quantity = toint(row_data.Quantity),

        ActualActivity =
            todouble(row_data.ActualActivity),

        ActualActivityUnits =
            tostring(row_data.ActualActivityUnits),

        ActualVolume =
            todouble(row_data.ActualVolume),

        ActualVolumeUnits =
            tostring(row_data.ActualVolumeUnits),

        ActualSalineAdded =
            todouble(row_data.ActualSalineAdded),

        ActualTotalVolume =
            todouble(row_data.ActualTotalVolume),

        ActualQuantity =
            toint(row_data.ActualQuantity),

        ShipContainerID =
            tolong(row_data.ShipContainerID),

        Returned = toint(row_data.Returned),

        BioDoseScheduleID =
            tolong(row_data.BioDoseScheduleID),

        ReturnedByID =
            tolong(row_data.ReturnedByID),

        ReturnedQuantity =
            toint(row_data.ReturnedQuantity),

        ReturnedDate =
            datetime(1970-01-01)
            + tolong(row_data.ReturnedDate) * 1d,

        ReturnedTime =
            tolong(row_data.ReturnedTime) / 1000 * 1ms,

        Processed = toint(row_data.Processed),

        ProcessedByID =
            tolong(row_data.ProcessedByID),

        ProcessedDate =
            datetime(1970-01-01)
            + tolong(row_data.ProcessedDate) * 1d,

        ProcessedTime =
            tolong(row_data.ProcessedTime) / 1000 * 1ms,

        Billed = toint(row_data.Billed),
        BilledByID = tolong(row_data.BilledByID),

        BilledDate =
            datetime(1970-01-01)
            + tolong(row_data.BilledDate) * 1d,

        BilledTime =
            tolong(row_data.BilledTime) / 1000 * 1ms,

        PriceID = tolong(row_data.PriceID),
        PriceOverriden = toint(row_data.PriceOverriden),
        Price = todouble(row_data.Price),
        StatementID = tolong(row_data.StatementID),
        AmountBilled = todouble(row_data.AmountBilled),
        AmountCredit = todouble(row_data.AmountCredit),
        Paid = toint(row_data.Paid),

        DatePaid =
            datetime(1970-01-01)
            + tolong(row_data.DatePaid) * 1d,

        AmountPaid = todouble(row_data.AmountPaid),
        Adjustment = todouble(row_data.Adjustment),
        Deleted = toint(row_data.Deleted),

        DeliveryDate =
            datetime(1970-01-01)
            + tolong(row_data.DeliveryDate) * 1d,

        DeliveryTime =
            tolong(row_data.DeliveryTime) / 1000 * 1ms,

        DeliverByTime =
            tolong(row_data.DeliverByTime) / 1000 * 1ms,

        DeliveryTypeID =
            tolong(row_data.DeliveryTypeID),

        RouteID = tolong(row_data.RouteID),

        CalibrationDate =
            datetime(1970-01-01)
            + tolong(row_data.CalibrationDate) * 1d,

        ContainerID = tolong(row_data.ContainerID),

        Tax = todouble(row_data.Tax),
        Tax2 = todouble(row_data.Tax2),
        Tax3 = todouble(row_data.Tax3),
        Notes = tostring(row_data.Notes),
        PrepFee = todouble(row_data.PrepFee),
        PharmacistID = tolong(row_data.PharmacistID),
        Synced = toint(row_data.Synced),

        LocationGUID =
            tostring(row_data.LocationGUID),

        SalineInventoryID =
            tolong(row_data.SalineInventoryID),

        Weight = todouble(row_data.Weight),
        WeightUnits = tostring(row_data.WeightUnits),

        ExpirationDate =
            datetime(1970-01-01)
            + tolong(row_data.ExpirationDate) * 1d,

        ExpirationTime =
            tolong(row_data.ExpirationTime) / 1000 * 1ms,

        ProposedInventoryID =
            tolong(row_data.ProposedInventoryID),

        LastModified =
            unixtime_milliseconds_todatetime(
                tolong(row_data.LastModified)
            )
}
```

# Ordered_Flattened
```
# This is the flattened table
{
    "Name": "Ordered_Flattened",
    "OrderedColumns": [
        {
            "Name": "CDCOperation",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "CDCOperationDescription",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "CDCEventTime",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "SourceEventTime",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "EventSequenceNs",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "SourceDatabase",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "SourceTable",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "IsSnapshot",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "BinlogFile",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "BinlogPosition",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "BinlogRow",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "CDCServerId",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "IsDeleted",
            "Type": "System.SByte",
            "CslType": "bool"
        },
        {
            "Name": "OrderedID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ClientID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ClientBillID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "OrderClientID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ProductID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "AllowedID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ProcedureID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Amount",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Units",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "CalibrationTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "PatientName",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "PONumber",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "PhysicianID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ReferringPhysicianID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "OrderedByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "OrderDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "OrderTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "OrderTakenByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Filled",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "FilledByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "FilledDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "FilledTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "Quantity",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "ActualActivity",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "ActualActivityUnits",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "ActualVolume",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "ActualVolumeUnits",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "ActualSalineAdded",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "ActualTotalVolume",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "ActualQuantity",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "ShipContainerID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Returned",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "BioDoseScheduleID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ReturnedByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ReturnedQuantity",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "ReturnedDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "ReturnedTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "Processed",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "ProcessedByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "ProcessedDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "ProcessedTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "Billed",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "BilledByID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "BilledDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "BilledTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "PriceID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "PriceOverriden",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "Price",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "StatementID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "AmountBilled",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "AmountCredit",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Paid",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "DatePaid",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "AmountPaid",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Adjustment",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Deleted",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "DeliveryDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "DeliveryTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "DeliverByTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "DeliveryTypeID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "RouteID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "CalibrationDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "ContainerID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Tax",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Tax2",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Tax3",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "Notes",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "PrepFee",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "PharmacistID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Synced",
            "Type": "System.Int32",
            "CslType": "int"
        },
        {
            "Name": "LocationGUID",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "SalineInventoryID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "Weight",
            "Type": "System.Double",
            "CslType": "real"
        },
        {
            "Name": "WeightUnits",
            "Type": "System.String",
            "CslType": "string"
        },
        {
            "Name": "ExpirationDate",
            "Type": "System.DateTime",
            "CslType": "datetime"
        },
        {
            "Name": "ExpirationTime",
            "Type": "System.TimeSpan",
            "CslType": "timespan"
        },
        {
            "Name": "ProposedInventoryID",
            "Type": "System.Int64",
            "CslType": "long"
        },
        {
            "Name": "LastModified",
            "Type": "System.DateTime",
            "CslType": "datetime"
        }
    ]
}
```


# Materialized view
```
.create materialized-view mv_orders {
    Ordered_Flattened
    | summarize arg_max(EventSequenceNs, *) by OrderedID
};

Ordered_Flattened
    | join kind=left stg_shipcontainer_flat on OrderedID
    | summarize arg_max(EventSequenceNs, *) by OrderedID

    
Orders_CDC_Flat
    | summarize arg_max(CDCEventTime, *) by OrderID
```

# Questions
1. Which statuses need to be trapped.
   1. total orders
      1. ordered table
   2. total filled
      1. ordered.Filled table
   3. total packed
      1. shipcontainer.PackedDate
   4. total shipped
      1. shipment.ShipDate
   5. total delivered
      1. shipcontainer.DeliveredDate