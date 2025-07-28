with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select orders.*,
        stripe.amount
    from {{ ref('stg_orders') }} as orders
    left join {{ source('stripe','payment') }} as stripe
        on orders.order_id = stripe.orderid

),

-- Staging CTE with earliest order, latest order, and total number of orders grouped by customer_id
customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as total_amount

    from orders

    group by 1

),

-- Target table to display customer id, name, first order, most recent order, and total number of orders.
final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.total_amount,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date

    from customers

    left join customer_orders using (customer_id)

)

select * from final