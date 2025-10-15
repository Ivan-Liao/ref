-- max in a query without group by returns null if empty query set
with single_nums as (
    select num
    from MyNumbers
    group by num
        having count(num) = 1
    order by num desc
    limit 1
)
select max(num) as num
from single_nums