with rankings as (
select name,
    salary,
    departmentId,
    dense_rank() over (partition by departmentId order by salary desc) as d_rank
from Employee
)
select d.name as Department,
    r.name as Employee,
    r.salary
from rankings r
join department d
    on r.departmentId = d.id
where r.d_rank < 4 


-- percentage makeup of order total
SELECT
  order_id,
  order_item_id,
  item_total,
  SUM(item_total) OVER (PARTITION BY order_id) AS order_total_value,
  (item_total / SUM(item_total) OVER (PARTITION BY order_id)) * 100 AS percentage_of_order_total
FROM
  `qwiklabs-gcp-04-e6dbb323ed4c.coffee_on_wheels.order_item`
ORDER BY
  order_id,
  order_item_id;


SELECT
  order_id,
  order_item_id,
  item_price,
  quantity,
  FIRST_VALUE(item_price) OVER (PARTITION BY order_id ORDER BY item_price DESC) AS highest_item_price_in_order,
  FIRST_VALUE(quantity) OVER (PARTITION BY order_id ORDER BY item_price DESC) AS quantity_of_highest_item,
  LAST_VALUE(item_price) OVER (PARTITION BY order_id ORDER BY item_price ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_item_price_in_order,
  LAST_VALUE(quantity) OVER (PARTITION BY order_id ORDER BY item_price ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS quantity_of_lowest_item
FROM
  `qwiklabs-gcp-04-e6dbb323ed4c.coffee_on_wheels.order_item`
ORDER BY
  order_id,
  item_price DESC;