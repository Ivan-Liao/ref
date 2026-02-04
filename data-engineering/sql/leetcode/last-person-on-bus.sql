-- intuitive window function
SELECT person_name
FROM (
    SELECT person_name, turn,
           SUM(weight) OVER (ORDER BY turn) AS total_weight FROM Queue
) AS subquery WHERE total_weight <= 1000
ORDER BY turn DESC 
LIMIT 1;

-- clever self join
select max(q1.person_name) as person_name
from queue q1 join queue q2 on q1.turn >= q2.turn
group by q1.turn
    having sum(q2.weight) <= 1000
order by sum(q2.weight) desc
limit 1