-- use case instead of redundant multiple ctes
-- case functions in unison with ids
select
    case when id % 2 = 0 then id - 1
    when id % 2 = 1 and id <> (select max(id) from Seat) then id + 1
    else id
    end as id,
    student
from Seat
order by id


-- case for swapping without guaranteed increment id
# Write your MySQL query statement below
select
    case when id % 2 = 0 then lag(id,1) over (order by id asc)
    when id % 2 = 1 and id <> (select max(id) from Seat) then lead(id,1) over (order by id asc)
    else id
    end as id,
    student
from Seat
order by id