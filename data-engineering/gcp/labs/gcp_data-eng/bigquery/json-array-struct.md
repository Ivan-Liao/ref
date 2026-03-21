1. Arrays (REPEATED bq type)
```
#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array


SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date
-- can also order by or limi inside of ARRAY_AGG()
```
2. JSON data
   1. Loading JSON data
```
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,\
point_idx:integer,\
latitude:float,\
timestamp:timestamp\
 -t YOUR_DATASET_NAME.YOUR_TABLE_NAME


bq load \
--source_format=NEWLINE_DELIMITED_JSON \
--autodetect \
fruit_store.fruit_details \
gs://spls/gsp416/data-insights-course/labs/optimizing-for-performance/shopping_cart.json
```
   2. Querying JSON data
```
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10
```
3. Structs
```
#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner


-- edit schema as JSON
[
    {
        "name": "race",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "participants",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
            {
                "name": "name",
                "type": "STRING",
                "mode": "NULLABLE"
            },
            {
                "name": "splits",
                "type": "FLOAT",
                "mode": "REPEATED"
            }
        ]
    }
]


#standardSQL
SELECT race, p.name FROM racing.race_results,
UNNEST(participants) AS p
#standardSQL, correlated cross join
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
race_results.participants # full STRUCT name
#standardSQL, simplified correlated cross join
SELECT race, participants.name
FROM racing.race_results AS r, r.participants


# get list of names
SELECT race, COUNT(p.name) FROM racing.race_results,
UNNEST(participants) AS p
GROUP BY race


# get total times for participants with name starting with R
select p.name,
  SUM(s).ROUND(2) as total_seconds
from `qwiklabs-gcp-01-e591e23bb33b.racing.race_results`,
UNNEST(participants) as p,
UNNEST(p.splits) as s
where p.name LIKE 'R%'
GROUP BY p.name


# Return the participant's name who's split time is of 23.2
SELECT
  p.name,
  split_time
FROM racing.race_results AS r,
UNNEST(r.participants) AS p,
UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
```
