# Activator
## Example Alerts
```
// Check between business hours if there are 0 events in a 30 minute window
let eastern_now = datetime_utc_to_local(now(), "America/New_York");
let is_business_hours = dayofweek(eastern_now) between (1d .. 5d)
    and hourofday(eastern_now) between (4 .. 16);
stg_ordered_flat
| where last_modified >= eastern_now - 0.5h
    and is_business_hours == 1
| summarize total_events = count()
| extend total_events = iff(is_business_hours == 0, 1, total_events)
```

# Capacity Monitoring
1. Apps > Fabric capacity usage monitoring

# Eventhouse
## Monitor operations (like async create mv commands)
```
.show operations
| where Operation == "MaterializedViewCreate"
| order by StartedOn desc
| project OperationId, StartedOn, LastUpdatedOn, Duration, State, Status
```

# Real Time Intelligence

## parameter query examples
```
// list of clients
materialized_view('mv_client_latest')
| where isnotempty(name)
| project client_name = name
| distinct client_name
| sort by client_name asc

// static list of parameter values
datatable(timeframe:string, sort_order:int, description:string)
[
    "Today",                    1, "Orders calibrated today",
    "Yesterday",                2, "Orders calibrated yesterday",
    "Tomorrow",                 3, "Orders calibrated tomorrow",
    "Current week",             4, "Monday through Sunday of this week",
    "Past orders (45 days)",    5, "45 days ago through yesterday",
    "Future orders (30 days)",  6, "Tomorrow through 30 days out"
]
| sort by sort_order asc
```