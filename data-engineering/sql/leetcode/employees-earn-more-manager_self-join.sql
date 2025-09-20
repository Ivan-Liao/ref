select e.name as Employee
from Employee e
join Employee em
    on e.managerID = em.id
where em.salary < e.salary
    and e.managerID is not null