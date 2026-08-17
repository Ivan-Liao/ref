1. Duplicates can come from the original table (if you join on an ID that is not unique in the source table)
2. Duplicates can come from 1 to many joins between tables
   1. Debug by wrapping entire query and then pulling in joined columns and filter by one of the example duplicates