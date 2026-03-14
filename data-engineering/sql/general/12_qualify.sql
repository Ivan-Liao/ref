-- Find the top three items with the highest average prices for each size.
SELECT
  menu.item_size,
  menu.item_name,
  AVG(menu.item_price) AS average_price
FROM
  `qwiklabs-gcp-04-e6dbb323ed4c`.`coffee_on_wheels`.`menu` AS menu
GROUP BY
  menu.item_size,
  menu.item_name
QUALIFY
  ROW_NUMBER() OVER (PARTITION BY menu.item_size ORDER BY AVG(menu.item_price) DESC) <= 3
ORDER BY
  menu.item_size,
  AVG(menu.item_price) DESC;


-- top 3 and bottom 3 total revenues
with sums as (
  SELECT menu_id,
    SUM(item_total) as total_revenue
  FROM coffee_on_wheels.order_item
  GROUP BY menu_id
)
SELECT s.menu_id,
  total_revenue,
  item_name
from sums s
JOIN coffee_on_wheels.menu m
  ON s.menu_id = m.menu_id
QUALIFY
  ROW_NUMBER() OVER (ORDER BY total_revenue) <= 3 OR 
  ROW_NUMBER() OVER (ORDER BY total_revenue DESC) <= 3
  ;