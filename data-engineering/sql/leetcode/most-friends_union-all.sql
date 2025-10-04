-- Ideal version


with base as (
    select requester_id as id 
    from RequestAccepted
    union all
    select accepter_id as id 
    from RequestAccepted
)
select id, 
    count(*) num  
from base 
group by 1 
order by 2 desc 
limit 1

-- Redundant count, only one cte needed.
# Write your MySQL query statement below
with sums_requester as (
    select count(*) as num_friends,
        requester_id as id
    from RequestAccepted
    group by requester_id
), sums_accepter as (
    select count(*) as num_friends,
        accepter_id as id
    from RequestAccepted
    group by accepter_id
), unioned as (
    select *
    from sums_requester
    union all
    select *
    from sums_accepter
)
select id, 
    sum(num_friends) as num
from unioned
group by id
order by sum(num_friends) desc
limit 1
