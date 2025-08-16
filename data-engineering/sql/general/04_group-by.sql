--#4 Group by Having
SELECT COUNT(*)
FROM (
	SELECT passenger_user_id
	FROM transactions
	GROUP BY passenger_user_id
	HAVING COUNT(DISTINCT DATE(created_at)) > 1
) as t