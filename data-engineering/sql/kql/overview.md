# Functions
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