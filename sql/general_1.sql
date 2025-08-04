--#1 Simple Selects
-- select multiple columns from a table
SELECT id,
	name,
	product_category,
	price,
	total_costs
FROM products;

-- select all columns from a table while removing duplicates
SELECT DISTINCT * 
FROM table1;

--#2 Where Filters
SELECT id, name, age 
FROM students
WHERE age >= 10
	AND name LIKE 'Sam%'
	OR id IN (1,25,29)
	AND dating IS NOT NULL;

--#3 Order of Operations
FROM / JOIN
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT / OFFSET:
-- FWGH SOL
-- Fred wears golden hats, Susan only lavender

--#4 Group by Having
SELECT COUNT(*)
FROM (
	SELECT passenger_user_id
	FROM transactions
	GROUP BY passenger_user_id
	HAVING COUNT(DISTINCT DATE(created_at)) > 1
) as t

--#5 Update
UPDATE table
SET column = value
-- OPTIONAL WHERE
;