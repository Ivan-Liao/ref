# Create database objects

1. Create all stg tables
2. Create all func_stg functions
3. Policy updates for all stg tables
```
.execute database script <|
.alter table stg_ordered_flat policy update @'[{"IsEnabled": true,"Source": "raw_ordered","Query": "func_stg_ordered_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_client_flat policy update @'[{"IsEnabled": true,"Source": "raw_client","Query": "func_stg_client_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_locations_flat policy update @'[{"IsEnabled": true,"Source": "raw_locations","Query": "func_stg_locations_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_product_flat policy update @'[{"IsEnabled": true,"Source": "raw_product","Query": "func_stg_product_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_reason_flat policy update @'[{"IsEnabled": true,"Source": "raw_reason","Query": "func_stg_reason_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_reasoncode_flat policy update @'[{"IsEnabled": true,"Source": "raw_reasoncode","Query": "func_stg_reasoncode_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_shipcontainer_flat policy update @'[{"IsEnabled": true,"Source": "raw_shipcontainer","Query": "func_stg_shipcontainer_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_shipment_flat policy update @'[{"IsEnabled": true,"Source": "raw_shipment","Query": "func_stg_shipment_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
.alter table stg_orderedredirect_flat policy update @'[{"IsEnabled": true,"Source": "raw_orderedredirect","Query": "func_stg_orderedredirect_flat()","IsTransactional": false,"PropagateIngestionProperties": true}]';
```
1. Backfill
```
.execute database script <|
.append stg_ordered_flat <| func_stg_ordered_flat();
.append stg_client_flat <| func_stg_client_flat();
.append stg_locations_flat <| func_stg_locations_flat();
.append stg_product_flat <| func_stg_product_flat();
.append stg_reasoncode_flat <| func_stg_reasoncode_flat();
.append stg_reason_flat <| func_stg_reason_flat();
.append stg_shipment_flat <| func_stg_shipment_flat();
.append stg_shipcontainer_flat <| func_stg_shipcontainer_flat();
.append stg_orderedredirect_flat <| func_stg_orderedredirect_flat();
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

Grant SELECT, RELOAD, SHOW DATABASES, LOCK TABLES, REPLICATION SLAVE, BINLOG MONITOR ON *.* TO `sfbiorxcdc`@`%` IDENTIFIED BY PASSWORD ...