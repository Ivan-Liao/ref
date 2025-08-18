# Functions
1. Aggregate functions
   1. Average
   2. Count (numeric)
      1. COUNTA (alphanumeric)
      2. COUNTBLANK
         1. Can be used to remove partial or complete blank rows
      3. COUNTA - COUNT (alphabet)
      4. COUNTIF
   3. Max / Min
   4. Sum
2. Logical
   1. IF
   2. NOT
   3. OR
   4. AND
   5. IFS
      1. Useful for converting categorical values into numeric (e.g. agree, neutral, disagree to 1, 2, 3)
3. Lookups
   1. VLOOKUP
   2. HLOOKUP
   3. XLOOKUP (use this one if exists)
      1. For returning all results in one cell
         1. =TEXTJOIN(", ", TRUE, FILTER(column_to_return, REGEXMATCH(column_to_search, ".*"&lookup_value&".*")))
4. Mathematical
   1. ABS
   2. ROUND
      1. CEILING
      2. FLOOR
   3. SUMPRODUCT(Takes sum of product aka dot product)
5. Statistical Functions
   1. STDEV.S
   2. VAR.S
6. Text
   1. CONCAT
      1. CONCAT("C1"," ", "C2", " ","C3")
   2. LOWER
   3. PROPER (Pascal Case)
   4. TEXTJOIN()
      1. TEXTJOIN(" ",TRUE,C1:C3)
   5. TRIM
   6. UPPER
# References
1. Relative references
2. Absolute references
   1. $C$9
   2. Named ranged are considered absolute references