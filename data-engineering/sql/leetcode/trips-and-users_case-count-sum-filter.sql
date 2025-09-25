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