# Write your MySQL query statement below
with ranking as (
select 
    salary,
    dense_rank() over (order by salary desc) as rnk
from Employee
)
select MAX(salary) as SecondHighestSalary
from ranking
where rnk = 2

