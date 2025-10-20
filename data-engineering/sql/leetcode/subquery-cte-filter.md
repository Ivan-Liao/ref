# Product sales analysis earliest year sales
-- non ansi MySQL solution
select product_id,
    year as first_year, 
    quantity, 
    price
from Sales
where (product_id, year) in (select  product_id, min(year) from Sales group by product_id)

-- if tuple filtering not supported
with cte_earliest_year as (
    select product_id,
        min(year) as first_year
    from Sales
    group by product_id
)
select s.product_id,
    s.year as first_year,
    quantity,
    price
from Sales s
join cte_earliest_year cey
    on s.product_id = cey.product_id
    and s.year = cey.first_year

-- snowflake solution uses array_contains and array_constructs functions

# customers-all-products_subquery-filter
select customer_id
from Customer
group by customer_id
    having count(distinct product_key) = (select count(distinct product_key) from Product)

# same investments cte filter
with same_investment2015 as (
    select tiv_2015
    from Insurance
    group by tiv_2015
        having count(pid) > 1
), same_city as (
    select lat, lon
    from Insurance
    group by lat, lon
        having count(pid) = 1
)
select round(sum(tiv_2016),2) as tiv_2016
from Insurance
where tiv_2015 in (select tiv_2015 from same_investment2015)
    and (lat, lon) in (select lat, lon from same_city)

-- subqueries possibly faster
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
    SELECT tiv_2015
    FROM Insurance
    GROUP BY tiv_2015
    HAVING COUNT(*) > 1
)
AND (lat, lon) IN (
    SELECT lat, lon
    FROM Insurance
    GROUP BY lat, lon
    HAVING COUNT(*) = 1
)