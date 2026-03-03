<!-- 
    ROW_NUMBER(): Assigns a unique, consecutive number to each row (1, 2, 3, 4...).
Best for: Pagination, identifying the single top record, or when you just need a unique identifier.
    RANK(): Assigns the same rank to ties but skips the next ranking values (1, 2, 2, 4).
Best for: Competitive standings where you want to show that two people tied for 2nd place, but the next person is 4th.
    DENSE_RANK(): Assigns the same rank to ties but does not skip the next ranking value (1, 2, 2, 3).
Best for: Leaderboards or reporting where you need consecutive ranking, such as finding the top 3 highest-paid employees regardless of ties. 
-->
# dense rank
## Department Top Three Salaries
```
with rankings as (
select name,
    salary,
    departmentId,
    dense_rank() over (partition by departmentId order by salary desc) as d_rank
from Employee
)
select d.name as Department,
    r.name as Employee,
    r.salary
from rankings r
join department d
    on r.departmentId = d.id
where r.d_rank < 4 
```

# Department Highest Salary
```
with rankings as (
select departmentId,
    name,
    salary,
    dense_rank() OVER (partition by departmentId order by salary desc) as row_num
from Employee e
)
select d.name as Department,
    r.name as Employee,
    r.salary as Salary
from rankings r
join Department d
    on d.id = r.departmentId
where row_num = 1
```

## Second highest salary
```
with ranking as (
select 
    salary,
    dense_rank() over (order by salary desc) as rnk
from Employee
)
select MAX(salary) as SecondHighestSalary -- Max needed for null handling
from ranking
where rnk = 2
```


## Ranked scores
```
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

```
