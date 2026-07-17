# Create 

raw_shipcontainer.kql
stg_shipcontainer_flat.kql
shipcontainer_flat_function.kql

```
.alter table stg_shipcontainer_flat policy update @'[{"IsEnabled": true, "Source": "raw_shipcontainer", "Query": "shipcontainer_flat_function()", "IsTransactional": false, "PropagateIngestionProperties": true}]';

.append stg_shipcontainer_flat <| shipcontainer_flat_function();
```

# Materialized View
```
.create materialized-view with (backfill=true) shipcontainer_mv on table stg_shipcontainer_flat {
    stg_shipcontainer_flat
    | summarize arg_max(event_sequence_ns, *) by ship_container_id
}

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