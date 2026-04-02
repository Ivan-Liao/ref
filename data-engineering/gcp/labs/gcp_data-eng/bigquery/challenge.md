1. Create table partitioned by date
```
bq mk covid

-- ctas statement with date partitioning
create or replace table 
  covid.oxford_policy_tracker
PARTITION BY
  date -- Replace with your actual DATE or TIMESTAMP column
OPTIONS (
  partition_expiration_days = 2175, -- Partitions automatically expire after 3 days
  description = "A new partitioned table with 2175-day partition expiration",
  require_partition_filter = TRUE -- Optional: forces all queries to use a partition filter
) as (

SELECT *  FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
where alpha_3_code not in ('GBR','BRA','CAN','USA')
)


-- Update with transformed data from another table
UPDATE covid_data.consolidate_covid_tracker_data cctd
SET cctd.mobility.avg_retail = a.avg_retail,
  cctd.mobility.avg_grocery = a.avg_grocery,
  cctd.mobility.avg_parks = a.avg_parks,
  cctd.mobility.avg_transit = a.avg_transit,
  cctd.mobility.avg_workplace = a.avg_workplace,
  cctd.mobility.avg_residential = a.avg_residential
FROM (
  SELECT country_region, date,
  AVG(retail_and_recreation_percent_change_from_baseline) as avg_retail,
  AVG(grocery_and_pharmacy_percent_change_from_baseline) as avg_grocery,
  AVG(parks_percent_change_from_baseline) as avg_parks,
  AVG(transit_stations_percent_change_from_baseline) as avg_transit,
  AVG( workplaces_percent_change_from_baseline ) as avg_workplace,
  AVG( residential_percent_change_from_baseline) as avg_residential
  FROM `bigquery-public-data.covid19_google_mobility.mobility_report`
  GROUP BY country_region, date
) as a
WHERE cctd.country_name = a.country_region
  and cctd.date = a.date


-- filter analysis
SELECT distinct country_name FROM `qwiklabs-gcp-03-776e40bb4574.covid_data.oxford_policy_tracker_worldwide` 
where population is null
UNION ALL
SELECT distinct country_name FROM `qwiklabs-gcp-03-776e40bb4574.covid_data.oxford_policy_tracker_worldwide` 
where country_area is null
order by country_name



```