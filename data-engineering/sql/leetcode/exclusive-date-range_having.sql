-- best solution using having
SELECT Product.product_id, Product.product_name FROM Product 
JOIN Sales 
ON Product.product_id = Sales.product_id 
GROUP BY Sales.product_id 
HAVING MIN(Sales.sale_date) >= "2019-01-01" AND MAX(Sales.sale_date) <= "2019-03-31";


-- general solution with exclusive cte
# Write your MySQL query statement below
with outside_range as (
    select product_id
    from sales
    where sale_date not between '2019-01-01' and '2019-03-31'
)
select distinct p.product_id,
    p.product_name
from Sales s
join Product p
    on s.product_id = p.product_id
where s.sale_date between '2019-01-01' and '2019-03-31'
    and p.product_id not in (select product_id from outside_range)