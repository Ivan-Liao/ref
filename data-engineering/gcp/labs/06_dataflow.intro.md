1. Create dataset and table
```
bq --location=us-west1 mk taxirides

bq --location=us-west1 mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t taxirides.realtime
```
2. Copy data into GCS bucket
```
gcloud storage cp gs://cloud-training/bdml/taxisrcdata/schema.json  gs://qwiklabs-gcp-03-4d7811be8f67-bucket/tmp/schema.json

{
    "BigQuery Schema": [
    {
        "name": "ride_id",
        "type": "STRING"
    }, {
        "name": "point_idx",
        "type": "INTEGER"
    }, {
        "name": "latitude",
        "type": "FLOAT"
    }, {
        "name": "longitude",
        "type": "FLOAT"
    }, {
        "name": "timestamp",
        "type": "TIMESTAMP"
    }, {
        "name": "meter_reading",
        "type": "FLOAT"
    }, {
        "name": "meter_increment",
        "type": "FLOAT"
    }, {
        "name": "ride_status",
        "type": "STRING"
    }, {
        "name": "passenger_count",
        "type": "INTEGER"
    }]
}

gcloud storage cp gs://cloud-training/bdml/taxisrcdata/transform.js  gs://qwiklabs-gcp-03-4d7811be8f67-bucket/tmp/transform.js

function transform(line) {
var values = line.split(',');
var custObj = new Object();
custObj.ride_id = values[0];
custObj.point_idx = values[1];
custObj.latitude = values[2];
custObj.longitude = values[3];
custObj.timestamp = values[4];
custObj.meter_reading = values[5];
custObj.meter_increment = values[6];
custObj.ride_status = values[7];
custObj.passenger_count = values[8];
var outJson = JSON.stringify(custObj);
return outJson;
}

gcloud storage cp gs://cloud-training/bdml/taxisrcdata/rt_taxidata.csv  gs://qwiklabs-gcp-03-4d7811be8f67-bucket/tmp/rt_taxidata.csv
```

3. Set up dataflow pipeline
   1. Create dataflow job from template
   2. template name: Cloud Storage Text to Bigquery
   3. dataset path
   4. JS UDF path
   5. JS UDF name
   6. dataset schema path
   7. Number of workers
   8. Machine type

4. Perform aggregations on stream for reporting
   1. check table SELECT * FROM taxirides.realtime LIMIT 10
   2. calculate aggregations
```
WITH streaming_data AS (

SELECT
  timestamp,
  TIMESTAMP_TRUNC(timestamp, HOUR, 'UTC') AS hour,
  TIMESTAMP_TRUNC(timestamp, MINUTE, 'UTC') AS minute,
  TIMESTAMP_TRUNC(timestamp, SECOND, 'UTC') AS second,
  ride_id,
  latitude,
  longitude,
  meter_reading,
  ride_status,
  passenger_count
FROM
  taxirides.realtime
ORDER BY timestamp DESC
LIMIT 1000

)

# calculate aggregations on stream for reporting:
SELECT
 ROW_NUMBER() OVER() AS dashboard_sort,
 minute,
 COUNT(DISTINCT ride_id) AS total_rides,
 SUM(meter_reading) AS total_revenue,
 SUM(passenger_count) AS total_passengers
FROM streaming_data
GROUP BY minute, timestamp
```

5. Dashboarding
   1. Minute aggregations
      1. In query results, click open in Looker Studio
      2. use dashboard sort (minutes) as dimension
      3. Use total_rides, total_revenue, and total_passengers as metrics
      4. Line plot for all metrics
   2. Time series dashboard
      1. New blank report >> Bigquery tile >> Custom SQL
```
SELECT
  *
FROM
  taxirides.realtime
WHERE
  ride_status='enroute'
```
      2. Add a calculated field >> change timestamp to Date Hour Minute
      3. Dimension: timestamp Date Hour Minute
