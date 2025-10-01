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