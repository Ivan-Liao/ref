1. Make dataset
   1. `bq mk ecommerce`
2. Star a project by name in Add data, useful for adding public datasets not shown by default
3. Analysis of distinct combinations. Validation of many to many relationship.
   1. Many to many can cause inaccurate sums or multiple rows in more complex queries
```
SELECT
  v2ProductName,
  COUNT(DISTINCT productSKU) AS SKU_count,
  STRING_AGG(DISTINCT productSKU LIMIT 5) AS SKU
FROM `data-to-insights.ecommerce.all_sessions_raw`
  WHERE productSKU IS NOT NULL
  GROUP BY v2ProductName
  HAVING SKU_count > 1
  ORDER BY SKU_count DESC


SELECT
  productSKU,
  COUNT(DISTINCT v2ProductName) AS product_count,
  STRING_AGG(DISTINCT v2ProductName LIMIT 5) AS product_name
FROM `data-to-insights.ecommerce.all_sessions_raw`
  WHERE v2ProductName IS NOT NULL
  GROUP BY productSKU
  HAVING product_count > 1
  ORDER BY product_count DESC
```
4. Inner join filtering unintentionally
5. Full join use case to get both left and right join null cases
6. 
