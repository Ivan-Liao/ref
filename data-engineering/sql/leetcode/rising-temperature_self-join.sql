# Write your MySQL query statement below
select id
from Weather a
where temperature > (
    select temperature 
    from Weather b 
    where b.recordDate = date_add(a.recordDate, interval -1 day)
    )
SELECT w1.id
FROM Weather w1, Weather w2
WHERE DATEDIFF(w1.recordDate, w2.recordDate) = 1 
    AND w1.temperature > w2.temperature;