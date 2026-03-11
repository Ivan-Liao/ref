WITH
  order_item_stats AS (
  SELECT
    order_id,
    order_item_id,
    item_total,
    AVG(item_total) OVER (PARTITION BY order_id) AS avg_order_item_total,
    STDDEV(item_total) OVER (PARTITION BY order_id) AS stddev_order_item_total
  FROM
    `qwiklabs-gcp-04-e6dbb323ed4c.coffee_on_wheels.order_item` )
SELECT
  order_id,
  order_item_id,
  item_total,
  avg_order_item_total,
  stddev_order_item_total
FROM
  order_item_stats
WHERE
  ABS(item_total - avg_order_item_total) > 2 * stddev_order_item_total
ORDER BY
  order_id,
  item_total DESC;