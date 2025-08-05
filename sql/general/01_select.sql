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