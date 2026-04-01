-- Standard SQL
SELECT * FROM ecommerce.sales_by_sku_20170801
UNION ALL
SELECT * FROM ecommerce.sales_by_sku_20170802

-- Bigquery
SELECT * FROM `ecommerce.sales_by_sku_2017*`;
SELECT * FROM `ecommerce.sales_by_sku_2017*`
WHERE _TABLE_SUFFIX = '0802';