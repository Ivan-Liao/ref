--#2 Where Filters
SELECT id, name, age 
FROM students
WHERE age >= 10
	AND name LIKE 'Sam%'
	OR id IN (1,25,29)
	AND dating IS NOT NULL
    AND age BETWEEN 12 AND 14
    AND mother_name BETWEEN "Mary" AND "Tamatha";