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