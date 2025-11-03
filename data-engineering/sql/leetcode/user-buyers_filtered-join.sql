-- left join doesn't remove rows from Users
-- if where year filter was used, the rows from Users with no 2019 orders would be removed
select u.user_id as buyer_id,
    MIN(join_date) as join_date,
    COUNT(item_id) as orders_in_2019 -- ifnull not needed
from Users u
left join Orders o
    on o.buyer_id = u.user_id
    AND YEAR(order_date)='2019'
group by u.user_id