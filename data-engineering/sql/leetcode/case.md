- [immediate deliveries](#immediate-deliveries)
- [seat swap case and lag](#seat-swap-case-and-lag)
- [Treenode](#treenode)
- [Triangle](#triangle)

# immediate deliveries
with temp as (
    select customer_id,
        case when min(order_date) = min(customer_pref_delivery_date) then 1
            else 0 end as immediate_flag
    from Delivery
    group by customer_id
)
select ROUND((select sum(immediate_flag) from temp) / (select count(customer_id) from temp) * 100, 2) as immediate_percentage

-- postgres and mysql suitable using tuple matching
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MIN(order_date)
    FROM Delivery
    GROUP BY customer_id
);

# seat swap case and lag
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
select
    case when id % 2 = 0 then lag(id,1) over (order by id asc)
    when id % 2 = 1 and id <> (select max(id) from Seat) then lead(id,1) over (order by id asc)
    else id
    end as id,
    student
from Seat
order by id

# Treenode
SELECT id,

    CASE 
        WHEN p_id IS NULL THEN 'Root'
        WHEN id IN (SELECT p_id FROM Tree)THEN 'Inner'
        ELSE 'Leaf'
        END AS type
 FROM Tree

 # Triangle
 select x,
    y,
    z,
    case when x + y > z
            and x + z > y
            and y + z > x
        then 'Yes'
        else 'No' end
        as triangle
from Triangle