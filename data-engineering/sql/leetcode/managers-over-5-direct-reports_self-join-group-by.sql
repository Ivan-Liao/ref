-- most efficient?? using where in to filter
with managers as (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) > 4
)
SELECT name
FROM Employee 
WHERE id IN (
    SELECT managerId
    from managers
);

SELECT name
FROM Employee 
WHERE id IN (
    SELECT managerId
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) > 4
);

-- also works, more intuitive
select 
    m.name as name
from Employee e
inner join Employee m
    on e.managerId = m.id
group by e.managerId
    having count(e.id) > 4