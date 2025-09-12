-- Access to dense rank
select  
    score,
    dense_rank() over (order by score desc) as "rank"
from Scores

-- Without window function
with rankings as (
SELECT s1.score, COUNT(DISTINCT s2.score) AS rnk
FROM Scores s1
LEFT JOIN Scores s2 ON s1.score <= s2.score
GROUP BY s1.score
)
select s3.score,
    rankings.rnk as "rank"
from Scores s3
join rankings 
    on s3.score = rankings.score
order by s3.score desc
