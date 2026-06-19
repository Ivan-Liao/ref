# Total accessory sales by salesperson
EVALUATE
  SUMMARIZECOLUMNS(
    'Salesperson'[Salesperson],
    FILTER('Product', 'Product'[Category] == "Accessories"),
    FILTER(ALL('Date'),
        'Date'[Date] >= TODAY() - 30
            && 'Date'[Date] <= TODAY()),
    "Total Sales", [Total Sales]
  )
1. EVALUATE 
   1. Think of it as the SQL equivalent of SELECT
2. SUMMARIZECOLUMNS
   1. Similar to SQL GROUP BY
3. FILTER
   1. Similar to WHERE SQL clause
4. Calculated columns
   1. "<calculated column name>", [<measure name]


