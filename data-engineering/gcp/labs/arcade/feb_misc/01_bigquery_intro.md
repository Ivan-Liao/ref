1. Create project
2. Create dataset nyctaxi
   1. Can be from the following
      1. GCS
      2. Upload
      3. Google Drive
      4. Bigtable
      5. S3
      6. Azure blob
      7. Existing table/view
   2. table name
   3. schema (can be autodetect)
   4. partitioning optional
   5. cluster settings
3. Create dataset with Cloud Shell
   1. ``` 
      bq load \
        --source_format=CSV \
        --autodetect \
        --noreplace  \
        nyctaxi.2018trips \
        gs://cloud-training/OCBL013/nyc_tlc_yellow_trips_2018_subset_2.csv
     ```
4. Analysis
```
SELECT
  *
FROM
  nyctaxi.2018trips
ORDER BY
  fare_amount DESC
LIMIT  5


CREATE TABLE
  nyctaxi.january_trips AS
SELECT
  *
FROM
  nyctaxi.2018trips
WHERE
  EXTRACT(Month
  FROM
    pickup_datetime)=1;


#standardSQL
SELECT
  *
FROM
  nyctaxi.january_trips
ORDER BY
  trip_distance DESC
LIMIT
  1


#standardSQL
with distance_buckets as (
  select CAST(pickup_datetime as string) || '-' || CAST(fare_amount as string) as ckey,
    CASE WHEN trip_distance BETWEEN 0 and 5 THEN '1_zero_five'
      WHEN trip_distance BETWEEN 5 and 10 THEN '2_five_ten'
      WHEN trip_distance BETWEEN 10 and 15 THEN '3_ten_fifteen'
      WHEN trip_distance BETWEEN 15 and 20 THEN '4_fifteen_twenty'
      WHEN trip_distance BETWEEN 20 and 25 THEN '5_twenty_twentyfive'
      WHEN trip_distance BETWEEN 25 and 30 THEN '6_twentyfive_thirty'
      WHEN trip_distance > 30 THEN '7_thirty'
      END as distance_bucket,
      fare_amount
  from `nyctaxi.2018trips`
)
select avg(fare_amount),
  distance_bucket
from distance_buckets
group by distance_bucket
order by distance_bucket
```
5. 