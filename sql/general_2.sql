WITH RelevantRiders AS (
	SELECT EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day,
		trip_miles,
		trip_seconds
	FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
	WHERE trip_start_timestamp >= '2017-01-01' AND
	trip_start timestamp <= '2017-07-01' AND
	trip_seconds > 0 AND
	trip_miles > 0
)
SELECT hour_of_day,
	COUNT(1) AS num_trips,
	3600 * SUM(trip_miles) / SUM(trip_seconds) AS avg_mph
FROM RelavantRides
GROUP BY hour_of_day
ORDER BY hour_of_day