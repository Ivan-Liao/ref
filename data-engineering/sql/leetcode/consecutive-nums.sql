-- Write your MySQL query statement below
With comparisons as (
    select 
        id,
        num,
        lead(num,1) over(order by id) as nextnum,
        lead(num,2) over(order by id) as next2num
    from Logs
), flags as (
    select id,
        num,
        case when num = nextnum and nextnum = next2num then 1 else 0 end as consec_flag
    from comparisons
)
select distinct num as ConsecutiveNums
from flags
where consec_flag = 1

-- Alternate solution, simpler code, worse performance
SELECT DISTINCT l1.num AS ConsecutiveNums
FROM Logs l1, Logs l2, Logs l3
WHERE l1.num = l2.num
  AND l2.num = l3.num
  AND l1.id = l2.id - 1
  AND l2.id = l3.id - 1;