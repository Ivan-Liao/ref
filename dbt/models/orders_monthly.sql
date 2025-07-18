{{ config(materialized = 'table' )}}

{% set statuses = 'placed','shipped','completed','return_pending','returned' %}

with orders_t1 as (
    select  
        order_id,
        status,
        date_trunc('month',order_date) as order_month
    from {{ref('stg_orders')}}
)
select
    order_month,
    count(order_id) as total_count,
    {% for status in statuses %}
        COUNT(
            CASE WHEN status = '{{ status }}'
            THEN order_id
            END
        ) AS {{ status }}_count {% if not loop.last %},{% endif %}
   {% endfor %}
from orders_t1 as orders_t1
group by 1
order by 1