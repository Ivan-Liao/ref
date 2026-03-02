-- 1 Calculations for percentages
with stage_1 as (
    select 
        query_name,
        CAST(rating as decimal)/position as quality,
        case when rating < 3 then 1.00 else 0 end as poor_query_flag
    from Queries
)
select
    query_name,
    ROUND(SUM(quality) / COUNT(*), 2) as quality,
    ROUND(SUM(poor_query_flag) * 100 / COUNT(*), 2) as poor_query_percentage
from stage_1
group by query_name