# current price of change tracking table
```
with num_list as (
    select row_number() over (partition by product_id order by change_date desc) as row_num,
        product_id,
        new_price
    from Products
    where change_date < '2019-08-17'
)
select product_id,
    new_price as price
from num_list
where row_num = 1
```

-- worst case senario where default case is not in initial data
```
with num_list as (
    select row_number() over (partition by product_id order by change_date desc) as row_num,
        product_id,
        new_price
    from Products
    where change_date < '2019-08-17'
)
select product_id,
    new_price as price
from num_list
where row_num = 1
UNION
select product_id, 10 as price
from Products 
where product_id not in (select distinct product_id from num_list)
```

# Product sales analysis earliest year sales
```
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
```

# customers-all-products_subquery-filter
```
select customer_id
from Customer
group by customer_id
    having count(distinct product_key) = (select count(distinct product_key) from Product)
```

# same investments cte filter
```
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
```

# trips and users case count with cte filters
-- important lesson here is that a cte can be used as a custom filter and is more efficient than the join approach.
-- At least in the case where there is a users table which corresponds to multiple columns in another table
-- e.g. user_id corresponds to client_id and driver_id

CREATE TABLE trips (
	id varchar(60),
	client_id varchar(70),
	driver_id varchar(60),
	city_id varchar(70),
  	status varchar(60),
	request_at varchar(70)
)
;

CREATE TABLE users (
	users_id varchar(60),
	banned varchar(70),
	role varchar(60)
)
;

insert into trips values ('1111','1','10','1','completed','2013-10-01')
;
insert into users values ('1','No','client'),('10','Yes','driver')
;

WITH not_banned as (
    SELECT users_id FROM users
    WHERE banned = 'No'
) 
SELECT
    request_at as Day,
    ROUND( SUM( CASE WHEN status LIKE 'cancelled%'
                     THEN 1.00
                     ELSE 0 END) / COUNT(*), 2)
    AS "Cancellation Rate"
FROM Trips
WHERE
    client_id IN (SELECT users_id FROM not_banned)
    AND driver_id IN (SELECT users_id FROM not_banned)
    AND request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY request_at


-- Less efficient, but with join instead of cte filter
SELECT 
    request_at as Day,
    ROUND(SUM(case when status LIKE 'cancelled%' then 1.00 else 0 end) / count(*), 2) as "Cancellation Rate"
from trips t 
inner join users u 
    on t.client_id = u.users_id
    and u.banned = 'No'
inner join users u2
    on t.driver_id = u2.users_id 
    and u2.banned = 'No'
where request_at between '2013-10-01' and '2013-10-03'
group by request_at
order by request_at
;