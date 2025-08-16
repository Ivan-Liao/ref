- [CAST](#cast)
- [CONCAT](#concat)
- [DATEDIFF](#datediff)
- [LAG](#lag)
- [LEFT / RIGHT](#left--right)
- [LENGTH](#length)
- [ROUND](#round)
- [ROW\_NUMBER](#row_number)
- [SUM](#sum)


# CAST
```
-- syntax
SELECT CAST(<column_name> as <data_type>)
-- example
SELECT CAST(order_id as string)
```


# CONCAT
```
-- syntax
SELECT CONCAT(<column_name>, <text_string>, <column_name_2>)
-- example
SELECT CONCAT(name, ' ', id)
```


# DATEDIFF
```
-- syntax
DATEDIFF(<date_column_a>, <date_column_b>)
-- example
select listing_id,
    sum(case when DATEDIFF(current_date(),date_check_in) < 90 then 1 else 0 end) as num_bookings_last90d,
    sum(case when DATEDIFF(current_date(),date_check_in) between 91 and 365 then 1 else 0 end) as num_bookings_last365d,
    count(date_check_in) as num_bookings_total
from testcases.bookings_309_tc_1
group by 1
```

# LAG
```
-- syntax
LAG(<column_name>,<num_offset>) OVER (PARTITION BY <col_a> ORDER by <col_b>)
-- example
SELECT name,
    DAY (whn) AS day,
    confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS newcases
FROM covid
WHERE name = 'Italy'
  AND MONTH (whn) = 3
ORDER BY whn;
```

# LEFT / RIGHT
```
-- syntax 
LEFT(<column_name>, <length>)

-- example
LEFT(name, 2)
-- jonathan would return jo
```

# LENGTH
```
-- syntax
LENGTH(<column_name>)
-- example
SELECT name, capital
FROM world
WHERE LENGTH(name) = LENGTH(capital)
;
```

# ROUND
```
-- syntax
ROUND(<column_name>, <num_decimal_places>)
-- example
ROUND(distance, 2)
ROUND(population, -3) -- population to the nearest thousand
```


# ROW_NUMBER
```
-- syntax
ROW_NUMBER() OVER (PARTITION BY <column_a>, <column_b>, <column_x> ORDER BY <column_c>, <column_d>, <column_x>)
-- example
WITH summary AS (
  SELECT a.genre, 
           a.author_name, 
           a.author_pay, 
           ROW_NUMBER() OVER(PARTITION BY a.genre
                                 ORDER BY a.author_pay DESC) AS rownum
  FROM authors as a
)
SELECT s.*
FROM summary as s
WHERE s.rownum = 1;
```

# SUM
```
-- syntax
SUM(<column_name>)
-- example
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;
```