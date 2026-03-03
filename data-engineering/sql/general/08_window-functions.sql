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