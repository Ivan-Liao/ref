# join, group by, ROUND, AVG 
select project_id,
    ROUND(AVG(e.experience_years),2) as average_years
from Project p
join Employee e
    on p.employee_id = e.employee_id
group by project_id

# group by, where, count distinct
select activity_date as day, 
    count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date