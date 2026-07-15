# Write your MySQL query statement below
with sums as (
    select sum(p.price) as total_amount,
        sum(u.units) as total_units
    from Prices p
    left join UnitsSold u
    group by p.product_id = u.product_id 
)