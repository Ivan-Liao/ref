-- percentage makeup
-- data: test_address-book-database.sql

select City
	,count(*) as total
    ,round(count(*) * 100.0 / sum(count(*)) over (), 2) as percentage
from Persons
group by City

-- postgres list stored procedures
SELECT  nspname, proname 
FROM    pg_catalog.pg_namespace  
JOIN    pg_catalog.pg_proc  
ON      pronamespace = pg_namespace.oid 
WHERE   nspname = '<schema>'
ORDER BY Proname 
