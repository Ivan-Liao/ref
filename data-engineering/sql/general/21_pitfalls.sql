-- null value summation
SUM(IFNULL(YOUR_COL, 0)) as total


-- safe divide, return 0 if denominator is 0...Bigquery SAFE_DIVIDE, custom queries