# Create tables
```
.create table raw_shipcontainer(
    payload: dynamic,
    schema: dynamic
);

.create table stg_shipcontainer_flat (
    ship_container_id             : long,
    ordered_id                    : long,
    cdc_event_time                : datetime,
    source_event_time             : datetime,
    event_sequence_ns             : long,
    packed_by_id                  : long,
    packed_date                   : datetime,
    packed_time                   : timespan,
    delivered_time                : datetime,
    delivered_date                : timespan
)
```

# Flattening functions
```
.create-or-alter function shipcontainer_flat_function() {
    raw_shipcontainer
    | extend p = todynamic(payload)
    | where tostring(p.source.table) == "shipcontainer_demo"
    | where tostring(p.op) in ("r", "c", "u", "d")
    | extend row_data = coalesce(todynamic(p.after), todynamic(p.before))
    | project 
        ship_container_id = tolong(row_data.ShipContainerID),
        ordered_id = tolong(row_data.OrderedID),
        cdc_event_time = unixtime_milliseconds_todatetime(tolong(p.ts_ms)),
        source_event_time = unixtime_milliseconds_todatetime(tolong(p.source.ts_ms)),
        event_sequence_ns = coalesce(tolong(p.ts_ns), tolong(p.ts_ms) * 1000000),
        packed_by_id = tolong(row_data.PackedByID),
        packed_date = datetime(1970-01-01) + tolong(row_data.PackedDate) * 1d,
        packed_time = tolong(row_data.PackedTime) / 1000 * 1ms,
        delivered_date = datetime(1970-01-01) + tolong(row_data.DeliveredDate) * 1d,
        delivered_time = tolong(row_data.DeliveredTime) / 1000 * 1ms
};

.alter table stg_shipcontainer_flat policy update @'[{"IsEnabled": true, "Source": "raw_shipcontainer", "Query": "shipcontainer_flat_function()", "IsTransactional": false, "PropagateIngestionProperties": true}]';

.append stg_shipcontainer_flat <| shipcontainer_flat_function();
```

# Materialized View
```
.create materialized-view with (backfill=true) shipcontainer_mv on table stg_shipcontainer_flat {
    stg_shipcontainer_flat
    | summarize arg_max(event_sequence_ns, *) by ship_container_id
}
```

Ordered_MV 
| join kind=leftouter shipcontainer_mv on $left.OrderedID == $right.ordered_id
| project CalibrationDate, 
    IsDeleted,   
    OrderedID,
    Filled,
    packed_date,
    delivered_date
| where IsDeleted == 0
| where todatetime(CalibrationDate) == (format_datetime(ago(24h),'yyyy-MM-dd'))
| summarize total_orders = count(),
    total_filled = count(tobool(Filled)),
    total_packed = count(tobool(packed_date)),
    total_delivered = count(tobool(delivered_date))
;

Ordered_MV
| project CalibrationDate, 
    Deleted,   
    OrderedID,
    Filled,
    Packed,
    Delivered
| where todatetime(CalibrationDate) == (format_datetime(ago(48h),'yyyy-MM-dd'))
| where Deleted == 0
| summarize total_orders = count(),
    total_filled = count(tobool(Filled)),
    total_packed = count(tobool(Packed)),
    total_delivered = count(tobool(Delivered));

Ordered_MV\n| project CalibrationDate,\n    Deleted,\n    OrderedID,\n    Filled\n| where todatetime(CalibrationDate) between (ago(48h) .. ago(-24h))\n| where Deleted == 0\n| summarize total_orders = count(),\n    total_filled = count(tobool(Filled))\n;