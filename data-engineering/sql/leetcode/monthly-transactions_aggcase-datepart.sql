-- Write your PostgreSQL query statement below
-- Postgresql has FILTER operator but you can also use AGG_FUNCTION(CASE) pattern
select to_char(trans_date, 'YYYY-MM') as month,
    country,
    COUNT(*) as trans_count,
    COUNT(CASE WHEN state = 'approved' THEN state END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    COALESCE(SUM(amount) FILTER (WHERE state = 'approved'),0) AS approved_total_amount
from Transactions
group by to_char(trans_date, 'YYYY-MM'), country
;