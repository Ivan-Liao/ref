MERGE INTO `<project>.<dataset>.final_table` T
USING (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY id ORDER BY timestamp DESC) AS rn
  FROM `<project>.<dataset>.staging_table`
) S
ON T.id = S.id
WHEN NOT MATCHED BY TARGET AND S.rn = 1 THEN
  INSERT (id, value, timestamp) VALUES(S.id, S.value, S.timestamp)