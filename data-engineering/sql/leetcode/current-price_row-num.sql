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

-- worst case senario where default case is not in initial data
# Write your MySQL query statement below
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