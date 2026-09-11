- [Functions (built in)](#functions-built-in)
- [Functions](#functions)
- [Materialized view](#materialized-view)
- [Policy Updates](#policy-updates)
- [Profiling](#profiling)
- [Query Examples](#query-examples)

# Functions (built in)
1. format_datetime(ago(24h),'yyyy-mm-dd')
2. type conversions
   1. tostring()
   2. toint()
   3. todouble()
   4. tolong()
   5. unix epoch
      1. datetime(1970-01-01) + tolong(row_data.OrderDate) * 1d ... for days
      2. unixtime_milliseconds_todatetime() ... for milliseconds
      3. tolong(row_data.OrderTime) / 1000 * 1ms ... for microseconds

# Functions
1. parse raw string representation of JSON payload into a structured dynamic object
   1. extend adds a new computed column p
   2. todynamic() converts JSON formatted strings into dynamic data type, which allows dot notation
   3. `extend p = todynamic(payload)`
```
.create-or-alter function trips_by_min_passenger_count(num_passengers:long)
{
    TaxiTrips
    | where passenger_count >= num_passengers 
    | project trip_id, pickup_datetime
}
trips_by_min_passenger_count(3)
```
# Materialized view
```
.create materialized-view TripsByVendor on table TaxiTrips
{
    TaxiTrips
    | summarize trips = count(), avg_fare = avg(fare_amount), total_revenue = sum(fare_amount)
    by vendor_id, pickup_date = format_datetime(pickup_datetime, "yyyy-MM-dd")
}
```
# Policy Updates
```
.show table MyTargetTable policy update

.alter table stg_shipcontainer_flat policy update @'[{"IsEnabled": true, "Source": "raw_shipcontainer", "Query": "shipcontainer_flat_function()", "IsTransactional": false, "PropagateIngestionProperties": true}]';

.append stg_shipcontainer_flat <| shipcontainer_flat_function();
```

# Profiling
1. Table schema
   1. .show table Ordered_Flattened schema as json;
2. function code

# Query Examples
TripsByVendor
| project pickup_date, vendor_id, trips, ["Average Fare"] = avg_fare, total_revenue
| where pickup_date >= ago(7d)
| sort by pickup_date desc, total_revenue desc

// Good: Small vendor table first
VendorInfo        
| join kind=inner TaxiTrips on vendor_id

TaxiTrips
| where pickup_datetime > ago(1d)    // Time filter first - eliminates most data
| where vendor_id == "VTS"           // Specific vendor - eliminates some data  
| where fare_amount > 0              // Value filter - eliminates least data
| summarize trip_count = count()

