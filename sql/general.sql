
-- tags: ["CASE", "DATE_DIFF", "CURRENT_DATE", "COUNT", "GROUP BY", "SUM", date difference]
-- gets the count of bookings in certain time windows
select listing_id,
    sum(case when DATEDIFF(current_date(),date_check_in) < 90 then 1 else 0 end) as num_bookings_last90d,
    sum(case when DATEDIFF(current_date(),date_check_in) between 91 and 365 then 1 else 0 end) as num_bookings_last365d,
    count(date_check_in) as num_bookings_total
from testcases.bookings_309_tc_1
group by 1


-- tags: ["CTE", "EXTRACT", "HOUR", "COUNT", "SUM", "GROUP BY", "ORDER BY"]
-- get ride share data, total number of trips and average mph segmented by hour of day between January 1 and July 1
WITH RelevantRiders AS (
	SELECT EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day,
		trip_miles,
		trip_seconds
	FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
	WHERE trip_start_timestamp >= '2017-01-01' AND
	trip_start timestamp <= '2017-07-01' AND
	trip_seconds > 0 AND
	trip_miles > 0
)
SELECT hour_of_day,
	COUNT(1) AS num_trips,
	3600 * SUM(trip_miles) / SUM(trip_seconds) AS avg_mph
FROM RelavantRides
GROUP BY hour_of_day
ORDER BY hour_of_day


-- tags: [dateadd(), GETDATE(), time ago, minutes ago, hours ago, days ago, weeks ago, years ago]
-- function: credit card transactions from more than 3 minutes ago
SELECT * 
FROM   TRANSACTION 
WHERE  transactionType ='CreditCard' 
AND    transactionDate < dateadd(minute, -3, GETDATE())


-- tags: ["ALTER TABLE", "CHANGE", "RENAME COLUMN"]
-- change column, change field, rename column, rename field
ALTER TABLE "table_name" Change "column 1" "column 2" ["Data Type"];
ALTER TABLE "table_name" RENAME COLUMN "column 1" TO "column 2";


-- tags: ["CREATE TABLE", "INSERT INTO", "CONSTRAINT", "ALTER TABLE", "UNIQUE", "CHECK", "COMPOSITE KEY", "PRIMARY KEY", "REFERENCES", ]
-- creating constraints
CREATE TABLE licenses (
    license_id varchar(10),
    first_name varchar(50),
    last_name varchar(50),
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);
CREATE TABLE registrations (
    registration_id varchar(10),
    registration_date date,
    license_id varchar(10) REFERENCES licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);
INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');
INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES 
('A203391', '3/17/2017', 'T229901'),
('A75772', '3/17/2017', 'T000001');


-- tags: ["CREATE INDEX", "EXPLAIN", "ANALYZE"]
-- create index, up to 50x speed improvements, benchmarking through explain analyze
CREATE INDEX street_idx ON new_york_addresses (street);
EXPLAIN ANALYZE SELECT * FROM new_york_addresses WHERE street = 'BROADWAY';


-- tags: ["SUM", "JOIN", "INNER JOIN", "CAST", "GROUP BY", "ORDER BY", "HAVING"]
-- state % changes above 50000000 threshold
SELECT pls14.stabr,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.stabr
HAVING sum(pls14.visits) > 50000000
ORDER BY pct_change DESC;
-- CAST prevents rounding to 0


-- tags: ["ALTER TABLE", "ADD COLUMN", "DROP COLUMN", "ALTER COLUMN", "RENAME COLUMN", "RENAME", "SET", "NOT NULL", "DROP", not null constraint]
ALTER TABLE table_name ADD COLUMN column data_type;
ALTER TABLE table_name DROP COLUMN column;
ALTER TABLE table_name ALTER COLUMN column SET DATA TYPE data_type;
ALTER TABLE table_name ALTER COLUMN column SET NOT NULL;
ALTER TABLE table_name ALTER COLUMN column DROP NOT NULL;
ALTER TABLE your_table_name RENAME COLUMN original_column_name TO new_column_name;
ALTER TABLE table_name RENAME new_table_name


-- tags: ["CREATE TABLE"]
-- making backups
CREATE TABLE meat_poultry_egg_inspect_backup AS 
SELECT * FROM meat_poultry_egg_inspect;


-- tags: ["UPDATE", "SET", "WHERE EXISTS"]
-- update table in a function like method, change all column values, set default column value
UPDATE table
SET column = value;

update items
set name='frog paste',
	bids=66
WHERE id=106


-- tags: ["UPDATE", "SET", "WHERE"]
-- updates st column
UPDATE meat_poultry_egg_inspect 
SET st = 'MN'  
WHERE est_number = 'V18677A'; 

UPDATE meat_poultry_egg_inspect 
SET st = 'AL' 
WHERE est_number = 'M45319+P45319'; 

UPDATE meat_poultry_egg_inspect 
SET st = 'WI' 
WHERE est_number = 'M263A+P263A+V263A';


-- tags: ["UPDATE", "WHERE", "SET", "LIKE"]
UPDATE meat_poultry_egg_inspec
SET company_standard = 'Armour-Eckrich Meats'  
WHERE company LIKE 'Armour%'; 

SELECT company, company_standard 
FROM meat_poultry_egg_inspect 
WHERE company LIKE 'Armour%';


-- tags: ["ALTER TABLE", "ADD COLUMN", "UPDATE", "SET", "WHERE", "length()", "IN"]
-- copy existing column to copy column
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN zip_copy varchar(5); 
UPDATE meat_poultry_egg_inspect 
SET zip_copy = zip;

UPDATE meat_poultry_egg_inspect  
SET zip = '00' || zip  
WHERE st IN('PR','VI') AND length(zip) = 3;

UPDATE meat_poultry_egg_inspect SET zip = '0' || zip WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;
-- may have to use concat() instead, || is not compatible across all sql dialects


-- tags: ["create view", "view"]
create view mostbids as
select id, name, bids 
from items
order by bids desc
limit 10

SELECT (SELECT COUNT(*) as num_encounters FROM CTE1) as num_encounters,
	(SELECT COUNT(*) FROM (SELECT DISTINCT patient_name FROM CTE1)) as distinct_patient_names_count,
	MAX(encounter_date) as most_recent_encounter_date,
	MIN(encounter_date) as oldest_encounter_date,
	(SELECT COUNT(*) FROM (SELECT DISTINCT visit_providers FROM CTE1)) as distinct_visit_providers_count,
FROM CTE1


-- tags: [clarity_loc!, ea_location!, oracle!]
SELECT * 
FROM clarity.clarity_loc
WHERE LOC_NAME LIKE '%FARGO%'


-- tags: [mssql!, ea_transfer!]
select top(5) * 
from TransferCenterRequestFact tcrf 


-- LEVEL3 QUESTIONS


-- tags: [rank!]
with ranks as (
	select LOG_ID
	, rank() over (order by count(*) desc) as rn
	, count(*) as counts
	from V_LOG_STAFF
	group by LOG_ID
)
select LOG_ID
	, rn
	, counts
from ranks
where ranks.rn = 1


-- tags: ["CREATE TABLE", "date", "date type", "STR_TO_DATE", "MySQL"]
-- insert subquery into existing table, insert query into table
CREATE TABLE song_plays (
  	id int,
	date_listen date,
  	user_id int,
  	song_id int
);


CREATE TABLE lifetime_plays (
  	date_listen date,
  	user_id int,
  	song_id int,
  	count_plays int
);


INSERT INTO song_plays (id, date_listen, user_id, song_id)
VALUES (1, STR_TO_DATE('2021-03-01', '%Y-%m-%d'), 1, 1),
(2, STR_TO_DATE('2021-03-01', '%Y-%m-%d'), 1, 1),
(3, STR_TO_DATE('2021-03-01', '%Y-%m-%d'), 1, 2),
(4, STR_TO_DATE('2021-02-28', '%Y-%m-%d'), 1, 2),
(5, STR_TO_DATE('2021-03-01', '%Y-%m-%d'), 2, 1);


INSERT INTO lifetime_plays (date_listen, user_id, song_id, count_plays)
SELECT date_listen
	, user_id
	, song_id
	, COUNT(*) as count
FROM song_plays
WHERE date_listen =  STR_TO_DATE('2021-03-01', '%Y-%m-%d')
GROUP BY 1, 2, 3


-- tags: ["moving average", "avg over", "rows between"]
-- gets moving average of current day and 2 precending days (standard 3 day moving average)
select *,
  avg(Price) OVER(ORDER BY Date
     ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) 
     as moving_average 
from stock_price;


-- EA
WITH CTE1 AS (
	SELECT patient_name,
		patient_address,
		patient_id
		patient_birth_date
		patient_current_age
		patient_encounter_age,
		encounter_csn,
		encounter type,
		appointment_status,
		PCP_name_specialty_encounter,
		visit_provider_name_specialty_encounter,
		visit_department_name_specialty,
		contact_date_encounter,
		PCP_name_specialty_recent
	FROM patient_table 
	WHERE contact_date_encounter > dateadd(m, -14, dateadd(d, -DATE_PART(GETDATE()) - 1, GETDATE())) AND
		contact_date_encounter < dateadd(d, -DATE_PART(GETDATE()), GETDATE())
)
UPDATE CTE1
SET PCP_name_specialty_encounter = NULL
WHERE visits_department_name_specialty != 'Internal Medicine'



WITH CTE1 AS (
	SELECT patient_name,
		patient_address,
		patient_id
		patient_birth_date
		patient_current_age
		patient_encounter_age,
		encounter_csn,
		encounter type,
		appointment_status,
		PCP_name_specialty_encounter,
		visit_provider_name_specialty_encounter,
		visit_department_name_specialty,
		contact_date_encounter,
		PCP_name_specialty_recent
	FROM patient_table 
	WHERE contact_date_encounter > dateadd(m, -14, dateadd(d, -DATE_PART(GETDATE()) - 1, GETDATE())) AND
		contact_date_encounter < dateadd(d, -DATE_PART(GETDATE()), GETDATE())
)
SELECT (SELECT COUNT(*) as num_encounters FROM CTE1) as num_encounters,
	(SELECT COUNT(*) FROM (SELECT DISTINCT patient_name FROM CTE1)) as distinct_patient_names_count,
	MAX(encounter_date) as most_recent_encounter_date,
	MIN(encounter_date) as oldest_encounter_date,
	(SELECT COUNT(*) FROM (SELECT DISTINCT visit_providers FROM CTE1)) as distinct_visit_providers_count,
FROM CTE1



-- tags: ["MIN", "MAX", "WINDOW", "JOIN", "ALL", "WHERE", "PARTITION BY"]
-- get students who did not score highest or lowest on exams
create table student (
  student_id int primary key,
  student_name varchar(20)
);

insert into student (student_name, student_id)
values ('Daniel' ,1),
	('Jade', 2),
    ('Stella', 3),
    ('Jonathan', 4),
    ('Will', 5);

create table exam (
  exam_id int,
  student_id int references student (student_id),
  score int
);

insert into exam (exam_id, student_id, score)
values (10, 1, 70),
	(10, 2, 80),
    (10, 3, 90),
    (20, 1, 80),
    (30, 1, 70),
    (30, 3, 80),
    (40, 1, 60),
    (40, 2, 70),
    (40, 4, 80);


WITH t1 AS (
              SELECT student_id
              FROM (
                       SELECT *,
                              MIN(score) OVER main_window as least,
                              MAX(score) OVER main_window as most
                       FROM exam
                       WINDOW main_window AS (PARTITION BY exam_id)
                    ) as a
              -- can't simply use group by because score isn't part of the group by exam_id or an aggregate function
              where least = score or most = score
            )

SELECT DISTINCT student_id, 
                student_name
FROM exam JOIN student
USING (student_id)
WHERE student_id != ALL(SELECT student_id FROM t1)
ORDER BY 1


-- tags: ["AVG", "OVER", "PARTITION BY", "JOIN", "INNER JOIN", "USING", "CASE", "DISTINCT", "TO_CHAR"]
-- compares department average salary versus company average salary by month
WITH t1 as (
	SELECT TO_CHAR(pay_date,'YYYY-MM') as pay_month, departmenet_id,
	AVG(amount) OVER(PARTITION BY DATE_PART('month', pay_date), department_id) as dept_avg,
	AVG(amount) OVER(PARTITION BY DATE_PART('month', pay_date)) as comp_avg,
	FROM salary as s JOIN employee as employee
	USING (employee_id)
)
SELECT DISTINCT pay_month,
	department_id,
	CASE WHEN dept_avg > comp_avg THEN 'higher'
		WHEN dept_avg = comp_avg THEN 'same'
		ELSE 'lower'
	END AS comparison
FROM t1
ORDER BY 1 DESC


-- tags: [time ago, minutes ago, hours ago, weeks ago, years ago]
-- function: max for each group in past 10 minutes
SELECT COUNT(DISTINCT user_id) AS num_users_gave_like
FROM events
WHERE DATE(created_at) = DATE("2020-06-06") AND action = "like"

-- LEVEL4 QUESTIONS


-- tags: ["SUM", "COUNT", "DISTINCT", "MAX", "INNER JOIN", "GROUP BY", "iquery", "content surfacing", "composite join", "multiple joins"]
-- Surfacing correct solutions
SELECT question_id
, q.title
, q.level
, CASE WHEN q.answer = "" THEN false 
	ELSE true 
	END AS has_solution
, SUM(accepted)/COUNT(DISTINCT user_id) AS acceptance_rate
, COUNT(DISTINCT user_id) AS distinct_tries
FROM (
	SELECT user_id
		, question_id
		, MAX(is_accepted) AS accepted
	FROM user_code_runs
	GROUP BY 1,2
) AS t
INNER JOIN questions AS q
	ON t.question_id = q.id
		AND q.type = 'sql'
GROUP BY 1 DESC
ORDER BY has_solution ASC, acceptance_rate DESC, distinct_tries DESC

-- find accepted solutions
SELECT *
FROM user_code_runs
WHERE question_id = 262
	AND is_accepted = 1

-- comment karma
SELECT email
, username
, title
, type
, has_solution
, points / num_views AS points_per_view
, points, num_views
, comment_body
FROM (
SELECT u.email
	, u.username
	, q.id
	, q.title
	, q.type
	, SUM(cu.vote) AS points
	, c.body AS comment_body
	, case when 
		q.answer = "" 
 	 then false else true end as has_solution
FROM users AS u 
INNER JOIN comments AS c 
	ON c.uid = u.id
		AND is_deleted = 0
INNER JOIN questions AS q
	ON q.id = c.qid
LEFT JOIN comment_upvotes AS cu 
	ON cu.comment_id = c.id
		AND cu.uid != u.id
WHERE c.created_at > '2020-05-20'
GROUP BY 1,2,3
) AS t
LEFT JOIN (
	SELECT qu.question_id, COUNT(DISTINCT qu.user_id) AS num_views
	FROM question_upvotes AS qu
	GROUP BY 1
) AS qu
	ON t.id = qu.question_id
WHERE points > 2
ORDER BY has_solution ASC, points DESC


-- tags: ["left join", "sum", "group by"]
-- total distance per person in ride sharing database with 2 tables users and rides
SELECT name
    , SUM(distance) AS distance_traveled
FROM users
LEFT JOIN rides
    ON users.id = rides.passenger_user_id
GROUP BY name
ORDER BY SUM(distance) DESC, name ASC


-- tags: ["cross join variation", "inner join", "join", "compare differences"]
-- comparing differences between scores from the same table, compare differences same table, same table compare differences
SELECT 
    s1.student AS one_student
    , s2.student AS other_student
    , ABS(s1.score - s2.score) AS score_diff
FROM scores AS s1
INNER JOIN scores AS s2
    ON s1.id != s2.id
        AND s1.id > s2.id
ORDER BY 3 ASC, 1 ASC
LIMIT 1


-- tags: ["cte", "multiple cte", "datediff"]
WITH daily_impressions as (
	SELECT
		dt,
		campaign_id,
		COUNT(DISTINCT impression_id) num_impressions
	FROM impressions i
), total_impressions as (
	SELECT
		campaign_id,
		COUNT(DISTINCT impression_id) as total_impressions
		FROM impressions i
		WHERE dt < current_date
		GROUP BY 1
)

-- tags: ["join", "inner join", "most recent", "max", "group by"]
-- gets the max id (most updated salary) after grouping by first and last name (would need some edge case analysis for same first and last name)
-- gets the salary associated with the max id (most updated salary)
SELECT e.first_name, e.last_name, e.salary
FROM employees AS e
INNER JOIN (
    SELECT first_name, last_name, MAX(id) AS max_id
    FROM employees
    GROUP BY 1,2
) AS m
    ON e.id = m.max_id


`job_postings` table

column	type
id	integer
job_id	integer
user_id	integer
date_posted	datetime
 

Given a table of job postings, write a query to breakdown the number of users that have posted their jobs once versus the number of users that have posted at least one job multiple times.

Output:

column	type
posted_jobs_once	int
posted_at_least_one_job_multiple_times	int

WITH user_job AS (
    SELECT user_id, job_id, COUNT(DISTINCT date_posted) AS num_posted
    FROM job_postings
    GROUP BY user_id, job_id
)

SELECT
    SUM(CASE WHEN avg_num_posted = 1 THEN 1 END) AS posted_jobs_once
    , SUM(CASE WHEN avg_num_posted > 1 THEN 1 END) AS posted_at_least_one_job_multiple_times
FROM (
    SELECT 
        user_id
        , AVG(num_posted) AS avg_num_posted
    FROM user_job
    GROUP BY user_id
) AS t 

WITH user_job AS (
    SELECT user_id, job_id, COUNT(DISTINCT date_posted) AS num_posted
    FROM job_postings
    GROUP BY user_id, job_id
)

SELECT
        SUM(CASE WHEN n_jobs = n_posts THEN 1 ELSE 0 END) AS posted_jobs_once
        , SUM(CASE WHEN n_jobs != n_posts THEN 1 ELSE 0 END) AS posted_at_least_one_job_multiple_times
FROM (
        SELECT user_id
                   , COUNT(DISTINCT job_id) AS n_jobs
                   , COUNT(DISTINCT id) AS n_posts
        FROM job_postings
        GROUP BY 1
) AS t

SELECT A.ID,A.AGE,B.SALARY
FROM A
LEFT JOIN B
ON A.ID = B.ID
WHERE B.SALARY > 50000

SELECT A.ID,A.AGE,B.SALARY
FROM A
LEFT JOIN B
ON A.ID = B.ID
WHERE B.SALARY > 50000

SELECT A.ID,A.AGE,B.SALARY
FROM A
LEFT JOIN B
ON A.ID = B.ID

--
`big_table`

column	type
id	int
name	varchar
 

Let's say we have a table with an id and name field. The table holds over 100 million rows and we want to sample a random row in the table without throttling the database.

Write a query to randomly sample a row from this table.

In most SQL databases there exists a RAND() function in which normally we can call:

SELECT * FROM big_table
ORDER BY RAND()
and the function will randomly sort the rows in the table. This function works fine and is fast if you only have let's say around 1000 rows. It might take a few seconds to run at 10K. And then at 100K maybe you have to go to the bathroom or cook a meal before it finishes.

What happens at 100 million rows? Someone in DevOps is probably screaming at you.

Random sampling is important in SQL with scale. We don't want to use the pre-built function because it wasn't meant for performance. But maybe we can re-purpose it for our own use case. 

We know that the RAND() function actually returns a floating-point between 0 and 1. So if we were to instead call:

SELECT RAND()
we would get a random decimal point to some Nth degree of precision. RAND() essentially allows us to seed a random value. How can we use this to select a random row quickly?

Let's try to grab a random number using RAND() from our table that can be mapped to an id. Given we have 100 million rows, we probably want a random number from 1 to 100 million. We can do this by multiplying our random seed from RAND() by the max number of rows in our table.

 

SELECT CEIL(RAND() * (
    SELECT MAX(id) FROM big_table)
)
We use the CEIL function to round the random value to an integer. Now we have to join back to our existing table to get the value.

What happens if we have missing or skipped id values though? We can solve for this by running the join on all the ids which are greater or equal than our random value and selects only the direct neighbor if a direct match is not possible.

As soon as one row is found, we stop (LIMIT 1). And we read the rows according to the index (ORDER BY id ASC). Now our performance is optimal.

SELECT r1.id, r1.name
FROM big_table AS r1 
INNER JOIN (
    SELECT CEIL(RAND() * (
        SELECT MAX(id)
        FROM big_table)
    ) AS id
) AS r2
    ON r1.id >= r2.id
ORDER BY r1.id ASC
LIMIT 1

--
`likes` table

column	type
user_id	int
created_at	datetime
liker_id	int
 

A dating websites schema is represented by a table of people that like other people. The table has three columns. One column is the user_id, another column is the liker_id which is the user_id of the user doing the liking, and the last column is the date time that the like occured.

Write a query to count the number of liker's likers (the users that like the likers) if the liker has one.

Example:

Input:

user	liker
A	B
B	C
B	D
D	E
 

Output:

user	count
B	2
D	1

The solution prompt in itself is a bit confusing and it helps to look at the examples to understand the exact link between the users and likers.

Each user has a specified liker but since the likers can also be users, they can also show up in the left most column as we see with values B and D. B and D happen to be the only ones that are both users and likers, which means that they would be only values that could be specified as the liker's likers.

Given we've figured out this relationship, let's solve the SQL question.

Since we want to join on the condition where a value can be a user and liker, we need to run an INNER JOIN between the table's liker column to the user column and then group by the liker column.

 

SELECT *
FROM likes AS l1
INNER JOIN likes AS l2
    ON l1.liker_id = l2.user_id
 

SQL output example from join

user_l1	liker_l1	user_l2	liker_l2
A	B	B	C
A	B	B	D
B	D	D	E
 

Looking at the output of our join, we can see that the second degree likers are represented in the  column and the first degree likers are represented in the  column. Now all we have to do is group by the `liker_l1` column and count the distinct values of the  column.

 

SELECT 
    l1.liker_id
    , COUNT(DISTINCT l2.liker_id) AS second_likers
FROM likes AS l1 
INNER JOIN likes AS l2 
    ON l1.liker_id = l2.user_id
GROUP BY 1
ORDER BY 1

--
users table

columns	type
id	integer
name	string
created_at	datetime
neighborhood_id	integer
mail	string
comments table

columns	type
user_id	integer
body	text
created_at	datetime
Write a SQL query to create a histogram of number of comments per user in the month of January 2020. Assume bin buckets class intervals of one.

Output:

column	type
comment_count	int
frequency	int

Let's break down the solution. Here are the things we have to note.

A histogram with bin buckets of one means that we can avoid the logical overhead of grouping frequencies into specific intervals when we run a GROUP BY in SQL.

Since a histogram is just a display of frequencies of each user, all we need to do is get the total count of user comments in the month of January 2020 for each user, and then group by that count.

At first look it seems like we don't need to do a join between the two tables. The user_id column exists in both tables. But if we ran a GROUP BY on just user_id on the comments table it would return the number of commments for each user right?

But what happens when a user does not make a comment?

Because we still need to account for users that did not make any comments in January 2020, we need to do a left join on users to comments, and then take the COUNT of a field in the comments table.

That way we can get a 0 value for any users that did not end up commenting in January 2020.

 

SELECT users.id, COUNT(comments.user_id) AS comment_count
FROM users
LEFT JOIN comments
    ON users.id = comments.user_id
        AND comments.created_at 
        BETWEEN '2020-01-01' AND '2020-01-31'
GROUP BY 1
 

The above CTE gives us a table with each user id and their corresponding comment count for the month of January 2020.

Now that we have the comment count for each user, all we need to do is to group by the comment count to get a histogram.

WITH hist AS (
	SELECT users.id, COUNT(comments.user_id) AS comment_count
	FROM users
	LEFT JOIN comments
	    ON users.id = comments.user_id
	        AND comments.created_at 
	        BETWEEN '2020-01-01' AND '2020-01-31'
	GROUP BY 1
)

SELECT comment_count, COUNT(*) AS frequency
FROM hist
GROUP BY 1


Try this on the SQL Editor:

SELECT comment_count, COUNT(*) AS frequency
FROM (
	SELECT users.id, COUNT(comments.user_id) AS comment_count
	FROM users
	LEFT JOIN comments
	    ON users.id = comments.user_id
	        AND comments.created_at 
	        BETWEEN '2020-01-01' AND '2020-01-31'
	GROUP BY 1
) AS t
GROUP BY 1

--
projects
    +---------------+---------+
 +->| id            | int     |
 |  | title         | varchar |
 |  | start_date    | date    |
 |  | end_date      | date    |
 |  | budget        | int     |
 |  +---------------+---------+
 |
 |  employees_projects
 |  +---------------+---------+
 +--| project_id    | int     |
    | employee_id   | int     |
    +---------------+---------+
 

We're given two tables. One is named `projects` and the other maps employees to the projects they're working on.

Write a query to get the top five most expensive projects by budget to employee count ratio.

Note: Exclude projects with 0 employees. Assume each employee works on only one project.

 

Output:

column	type
title	varchar
budget_per_employee	int

We're given two tables, one which has the budget of each project and the other with all employees associated with each project.

Since the question specifies one employee per project and excludes projects with 0 employees, we know we can apply an INNER JOIN between the two tables and not have to worry about duplicates or leaving out non-staffed projects.

 

SELECT project_id, COUNT(*) AS num_employees
FROM employees_projects
GROUP BY 1
The query above grabs the total number of employees per project. Now all we have to do is join it to the projects table to get the budget for each project and divide it by the number of employees.

SELECT 
    p.title, 
    budget/num_employees AS budget_per_employee
FROM projects AS p
INNER JOIN (
    SELECT project_id, COUNT(*) AS num_employees
    FROM employees_projects
    GROUP BY 1
) AS ep
    ON p.id = ep.project_id
ORDER BY 2 DESC
LIMIT 5;

--
employees table

column	type
id	integer
first_name	string
last_name	string
salary	integer
department_id	integer
Let’s say we have a table representing a company payroll schema.

Due to an ETL error, the employees table instead of updating the salaries every year when doing compensation adjustments, did an insert instead. The head of HR still needs the current salary of each employee.

Write a query to get the current salary for each employee.

Assume no duplicate combination of first and last names. (I.E. No two John Smiths)

Output

column	types
first_name	string
last_name	string
salary	integer

The first step we need to do would be to remove duplicates and retain the current salary for each user. 

Given we know there aren't any duplicate first and last name combinations, we can remove duplicates from the employees table by running a GROUP BY on two fields, the first and last name. This allows us to then get a unique combinational value between the two fields. 

This is great, but at the same time, we're now stuck with trying to find the most recent salary from the user. How would we be able to tell which was the most recent salary without a datetime column?

Notice that in the question it states that instead of updating the salaries every year when doing compensation adjustments, did an insert instead. This means that the current salary could then be evaluated by looking at the most recent row inserted into table. We can assume that an insert will autoincrement the id field in the table, which means that the row we want would be the maximum id for the row for each given user. 

 

SELECT first_name, last_name, MAX(id) AS max_id
FROM employees
GROUP BY 1,2
 

Now that we have the corresponding maximum id, we can re-join it to the original table in a subquery to then get the correct salary associated with the id in the sub-query. 

 

SELECT e.first_name, e.last_name, e.salary
FROM employees AS e
INNER JOIN (
    SELECT first_name, last_name, MAX(id) AS max_id
    FROM employees
    GROUP BY 1,2
) AS m
    ON e.id = m.max_id

--
`users` table

columns	type
id	integer
name	string
created_at	datetime
neighborhood_id	integer
sex	string
`comments` table

columns	type
user_id	integer
body	string
created_at	datetime
Given the two tables, write a SQL query that creates a cumulative distribution of number of comments per user. Assume bin buckets class intervals of one.

Output:

columns	type
frequency	integer
cum_total	float

This question is similar to the question about creating a histogram from writing a query. However creating a cumulative distribution plot requires another couple of steps.

We can start out with the query to count the frequency of each user by joining  to  and then grouping by the user id to get the number of comments per user.

WITH hist AS (
    SELECT users.id, COUNT(comments.user_id) AS frequency
    FROM users
    LEFT JOIN comments
        ON users.id = comments.user_id
    GROUP BY 1
)

SELECT * FROM hist
Now we can group on the frequency column to get the distribution per number of comments. This is our general histogram distribution of number of comments per user. Note that since we are getting the COUNT of the  table, users that comment 0 times will show up in the 0 frequency bucket.

WITH hist AS (
    SELECT users.id, COUNT(comments.user_id) AS frequency
    FROM users
    LEFT JOIN comments
        ON users.id = comments.user_id
    GROUP BY 1
),

freq AS (
    SELECT frequency, COUNT(*) AS num_users
    FROM hist
    GROUP BY 1
)

SELECT * FROM freq
Now that we have our histogram, how do we get a cumulative distribution? Specifically we want to see our frequency table go from:

frequency | count
----------+------
0         |  10
1         |  15
2         |  12

to:

frequency | cumulative
----------+-----------
0         |  10
1         |  25
2         |  27

Let's see if we can find a pattern and logical grouping that gets us what we want. The constraints given to us are that we will probably have to self-join since we can compute the cumulative total from the data in the existing histogram table.

If we can model out that computation, we'll find that the cumulative is taken from the sum all of the frequency counts lower than the specified frequency index. In which we can then run our self join on a condition where we set the left f1 table frequency index as greater than the right table frequency index.

WITH hist AS (
    SELECT users.id, COUNT(comments.user_id) AS frequency
    FROM users
    LEFT JOIN comments
        ON users.id = comments.user_id
    GROUP BY 1
),

freq AS (
    SELECT frequency, COUNT(*) AS num_users
    FROM hist
    GROUP BY 1
)

SELECT * 
FROM freq AS f1
LEFT JOIN freq AS f2
    ON f1.frequency >= f2.frequency
Now we just have to sum up the num_users column while grouping by the f1.frequency index.

WITH hist AS (
    SELECT users.id, COUNT(comments.user_id) AS frequency
    FROM users
    LEFT JOIN comments
        ON users.id = comments.user_id
    GROUP BY 1
),

freq AS (
    SELECT frequency, COUNT(*) AS num_users
    FROM hist
    GROUP BY 1
)

SELECT f1.frequency, SUM(f2.num_users) AS cum_total
FROM freq AS f1
LEFT JOIN freq AS f2
    ON f1.frequency >= f2.frequency
GROUP BY 1


--
`transactions` table

column	type
id	integer
user_id	integer
created_at	datetime
product_id	integer
quantity	integer
`products` table

column	type
id	integer
name	string
price	float
 

Given a table of transactions and products, write a query to return the transactions that have a cost that is greater than the average cost of all transactions.

Given this table, we should clarify from the question what it's actually asking.

An average price greater than the average price of all transactions implies a couple of things. One is that the products themselves must be dynamically priced and not standardized given that we need to calculate the average price of each product.

Another is that we have to calculate the average price of all transactions which means we need to create a sub-query first to get this value. We can easily do so by computing a simple average on the entire table.

WITH zap AS (
    SELECT AVG(price) AS avg_price
    FROM transactions AS t
    INNER JOIN products AS p
            ON t.product_id = p.id
)

SELECT * FROM zap
 

Now that we have this value, we can use it to filter our existing transactions table for all the products that have an average price greater than this avg_price value we just computed. However first we need to run a GROUP BY on each product_id to get the product average price.

We can filter using a WHERE condition with a sub-query or an INNER JOIN. For our example we'll just run an INNER JOIN.

 

WITH zap AS (
    SELECT product_id, ROUND(AVG(price)) AS product_avg_price
    FROM transactions
    INNER JOIN products AS p
    	ON t.product_id = p.id
    GROUP BY 1
)

SELECT ap.product_id, product_avg_price, avg_price
FROM zap
INNER JOIN (
	SELECT AVG(price) AS avg_price
    FROM transactions AS t
    INNER JOIN products AS p
    	ON t.product_id = p.id
) AS ap
    ON zap.product_avg_price > ap.avg_price

--
user_dimension table

column	type
user_id	int
account_id	int
account_dimension table

column	type
account_id	int
paying_customer	boolean
download_facts table

column	type
date	date
user_id	int
downloads	int
Given three tables: user_dimension, account_dimension, and download_facts, find the average number of downloads for free vs paying customers broken out by day.

Note: The account_dimension table maps users to multiple accounts where they could be a paying customer or not.

Output:

column	type
date	date
paying_customer	boolean
average_downloads	float

This type of SQL question is common for establishing a baseline level of competency. It's a good data reporting type of question. 

Let's first break it down. What values in which tables can we join together to get the data that we need? Ideally when we read the question, we have an idea of what kinds of values we want to see.

The data should be broken down in a way in which we could easily graph the values to visualize two line plots of free vs paying users. The x-axis would represent the date and the y-axis would represent the average number of downloads. 

Given this graph, we could assume we would then need three columns. 

One column representing the date
Another column representing the average downloads
One last column representing if the datapoint is a free group of users or paying group of users. 
 

Cool, now it's pretty clear to get the data we have to join all three tables together. Exactly how is cleared up if we can map each one of the foreign keys to the primary values in each table. 

The user_dimension table represents the mapping between account ids and user ids while the account_dimension table holds the value if the customer is paying or not. Lastly the download_facts table has the date and number of downloads per user. 

SELECT *
FROM user_dimension AS ud
INNER JOIN account_dimension AS ad
    ON ud.account_id = ad.account_id
LEFT JOIN download_facts AS df 
    ON ud.user_id = df.user_id
 

Let's note, why do we use a LEFT JOIN when joining the user_dimension table to the download_facts table?

This in fact allows us to get all the users that might not have made any downloads at all for a certain day. That way when we eventually compute the average, we can make sure we have the correct denominator, which is the total number of users in the user_dimension table. 

Now since we want the average number of downloads for free vs paying customers broken out by day, we can assume that the query will need to group the resulting dataset on two columns, to break out the aggregation of free and paying customers and the other by date.

Lastly to get the average number of downloads, we'll have to use the SUM function divided by the total count and run on distinct user_id just in case there exists duplicates.

 

SELECT 
    date
    , paying_customer
    , SUM(downloads)/COUNT(DISTINCT ud.user_id) AS average_downloads
FROM user_dimension AS ud
INNER JOIN account_dimension AS ad
    ON ud.account_id = ad.account_id
LEFT JOIN download_facts AS df 
    ON ud.user_id = df.user_id
GROUP BY 1,2
 

One lingering question is, why doesn't the AVERAGE function work in this case?

The user to account mapping provides an answer. Given that it's likely that an account has many users since the user_dimension is a mapping table, we can't run the AVERAGE function as it takes an average grouped on the user level when we want it on the account level.

--
`feed_comments`

 ad_id   |  user_id  |  comment_id
---------+-----------+---------------
 integer |  integer  |   integer

`moments_comments`

 ad_id   |  user_id  |  comment_id
---------+-----------+---------------
 integer |  integer  |   integer

`ads`

 id      |  name
---------+--------
 integer | varchar
 

You're given three tables.

An ads table holds an ID and the advertisement name like "Labor day shirts sale". The feed_comments table holds the comments on ads by different users that occurs in the regular feed. The moments_comments table holds the comments on ads by different users in the moments section.

Write a query to get the percentage of comments, by ad, that occurs in the feed versus mentions sections of the app.

Output:

ad_name       | % feed   | % mentions
--------------+----------+-----------
Labor Day     | 60%      | 40%
Polo Shirts   | 85%      | 15%


Let's figure out the equation we want to formulate our eventual solution in SQL. For each ad, we want the comment ratio that is from the feed and from mentions out of the total.

% feed = comments in feed / (comments in feed + comments in mentions)
% mentions = comments in mentions / (comments in feed + comments in mentions)

Okay, now we know our equation, we can work towards getting the variables we want towards solving it.

Let's look at the `feed_comments` table first. We know we want the total comments by each `ad_id` so we can do a simple GROUP BY to get the count.

 

SELECT 
    ad_id
    , COUNT(DISTINCT comment_id) AS num_comments
FROM feed_comments AS fc 
GROUP BY 1
 

However, if an ad does not exist in the `feed_comments` table but exists in the  table or the `moments_comments` table, then we'd be filtering the ad out of having a comment count of zero. One way we can get around that is by left joining the ads table to the `feed_comments` table. We can do the same thing to the `moments_comments` table.

 

WITH fc AS (
    SELECT 
        ads.id AS ad_id
        , COUNT(DISTINCT comment_id) AS num_comments
    FROM ads
    LEFT JOIN feed_comments AS fc 
        ON ads.id = fc.ad_id
    GROUP BY 1
),

mc AS (
    SELECT 
        ads.id AS ad_id
        , COUNT(DISTINCT comment_id) AS num_comments
    FROM ads
    LEFT JOIN moments_comments AS mc 
        ON ads.id = mc.ad_id
    GROUP BY 1
)

SELECT * FROM fc,mc
 

Now given both of the counts, we can join them back to the ads table to get the names of each ad and compute our equations for the percentages of the total.

 

WITH fc AS (
    SELECT 
        ads.id AS ad_id
        , COUNT(DISTINCT comment_id) AS num_comments
    FROM ads
    LEFT JOIN feed_comments AS fc 
        ON ads.id = fc.ad_id
    GROUP BY 1
),

mc AS (
    SELECT 
        ads.id AS ad_id
        , COUNT(DISTINCT comment_id) AS num_comments
    FROM ads
    LEFT JOIN moments_comments AS mc 
        ON ads.id = mc.ad_id
    GROUP BY 1
)

SELECT ads.name
    , fc.num_comments/(fc.num_comments + mc.num_comments) AS percentage_feed
    , mc.num_comments/(fc.num_comments + mc.num_comments) AS percentage_moments
FROM ads
LEFT JOIN fc 
    ON ads.id = fc.ad_id 
LEFT JOIN mc 
    ON ads.id = mc.ad_id


--
projects
    +---------------+---------+
 +->| id            | int     |
 |  | title         | varchar |
 |  | start_date    | date    |
 |  | end_date      | date    |
 |  | budget        | int     |
 |  +---------------+---------+
 |
 |  employees_projects
 |  +---------------+---------+
 +--| project_id    | int     |
    | employee_id   | int     |
    +---------------+---------+
 

We're given two tables. One is named `projects` and the other maps employees to the projects they're working on. 

We want to select the five most expensive projects by budget to employee count ratio. But let's say that we've found a bug where there exists duplicate rows in the `employees_projects` table.

Write a query to account for the error and select the top five most expensive projects by budget to employee count ratio.

Output:

column	type
title	string
budget_per_employee	float

Given that the bug only exists in the  table, we can reuse most of the code from this question as long as we rebuild the  table by removing duplicates.

One way to do so is to simply group by the columns  and . By grouping by both columns, we're creating a table that sets distinct value on  and , thereby getting rid of any duplicates.

Then all we have to do is then query from that table and nest it into another subquery.

 

SELECT 
    p.title, 
    budget/num_employees AS budget_per_employee
FROM projects AS p
INNER JOIN (
    SELECT project_id, COUNT(*) AS num_employees
    FROM (
        SELECT project_id, employee_id
        FROM employees_projects
        GROUP BY 1,2
    ) AS gb
    GROUP BY project_id
) AS ep
    ON p.id = ep.project_id
ORDER BY budget/num_employees DESC
LIMIT 5;

--
`transactions` table

column	type
id	integer
user_id	integer
created_at	datetime
product_id	integer
quantity	integer
 

Given the revenue transactions table above, write a query that finds the third purchase of every user.

Output:

column	type
user_id	integer
created_at	datetime
product_id	integer
quantity	integer


This problem set is relatively straight forward at first. We can first determine the order of purchases for every user by looking at the created_at column and ordering by user_id and the created_at column. 

However, we still need an indicator of which purchase was the third value. Whenever we think of ranking our dataset, it's helpful to then immediately think of a specific window function we can use. 

In this case, we need to apply the RANK function to the transactions table. The RANK function is a window function that assigns a rank to each row in the partition of the result set. 

RANK() OVER (PARTITION BY user_id ORDER BY created_at ASC) AS rank_value
In this example, the PARTITION BY clause distributes the rows in the result set into partitions by one or more criteria.

Second, the ORDER BY clause sorts the rows in each partition by the column we indicated, in this case, created_at.

Finally, the RANK() function is operated on the rows of each partition and re-initialized when crossing each partition boundary. The end result is a column with the rank of each purchase partitioned by user_id.

All we have to do is then wrap the table in a subquery and filter out where the new column is then equal to 3, which is equivalent for subsetting for the third purchase.

SELECT user_id, created_at, product_id, quantity
FROM ( 
    SELECT 
        user_id
        , created_at
        , product_id
        , quantity
        , RANK() OVER (
            PARTITION BY user_id 
            ORDER BY created_at ASC
        ) AS rank_value 
    FROM transactions
) AS t
WHERE rank_value = 3;

--
`search_results` 

column	type
query	varchar
result_id	integer
position	integer
rating	integer
 

You're given a table that represents search results from searches on Facebook. The `query` column is the search term, `position` column represents each position the search result came in, and the rating column represents the human rating of the result from 1 to 5 where 5 is high relevance and 1 is low relevance.

Write a query to get the percentage of search queries where all of the ratings for the query results are less than a rating of 3. Please round your answer to two decimal points.

Output:

column	type
percentage_less_than_3	float

Here's a neat trick. If a question includes the phrasing of "where ALL of the values are less/greater etc.." we should not be using a WHERE clause for our filtering.

Why is that? Because we have to do the filtering after a GROUP BY when looking for the cases where a certain condition must be applied to a distinct value. In this case, the distinct value is query in which there are multiple search results per query. 

We're looking for search queries where all of the search results have a rating less than 3. Let's try to make this performance happy and not write a couple sub-queries while looking for this. Which means we have to use the HAVING clause.

 

WITH low_rating AS (
    SELECT query
    FROM search_results
    GROUP BY 1
    HAVING SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) = COUNT(*)
) 

SELECT * FROM low_rating
 

Notice the condition in the HAVING clause. We are checking to see if the count of search results with ratings less than 3 equates to the total count of all search results for each query. If they do, then we don't filter them out. That leaves us with all of the queries with ratings less than 3. 

Now that we have all of the queries, we can rejoin it to our original table and do a COUNT DISTINCT on search query terms. The numerator would be all of the queries with a less than 3 rating and the denominator would be the total distinct search queries. 

 

WITH low_rating AS (
    SELECT query
    FROM search_results
    GROUP BY 1
    HAVING SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) = COUNT(*)
) 

SELECT ROUND(COUNT(DISTINCT lr.query)/COUNT(DISTINCT sr.query),2) AS percentage_less_than_three
FROM search_results AS sr 
LEFT JOIN low_rating AS lr 
    ON sr.query = lr.query

--
users table

Column	Type
id	integer
name	string
 

rides table

Column	Type
id	integer
passenger_user_id	integer
distance	float
 

Write a query to report the distance travelled by each user in descending order.

Output:

column	type
name	string
distance_travelled	float

Given this problem statement, we need to accomplish two things. One is to figure out the total distance traveled for each user_id. The second is to then get the name of the user and order it by the distance traveled.

Let's break it down into steps and tackle an easier problem first. First off, how would we get the total distance traveled for all users? 

One way to do so would be with the SUM function. Since the  table represents all of the rides, each row in the  table represents one ride and the distance column traveled in each ride respectively. Therefore to ge the total distance traveled we could just run:

SELECT SUM(distance)
FROM rides
 

Okay, but now we want it by each user. So whenever the question asks specifically for one metric/column BY another column, we need to remember that we are doing an aggregation function, which will then need a GROUP BY. We are grouping by the user_id in order to then sum up the total distance travelled by each user.

SELECT user_id, SUM(distance) AS distance_traveled
FROM rides
GROUP BY user_id
 

Great, now lastly we need to get the names of the users, we can do this in two ways. We can either join to the rides table before or after our aggregation.

Which kind of join do we need to use however?

We definitely need to use a LEFT JOIN. The reason because that there could exists users that have not travelled on any rides, and therefore would not have a row in the rides table. Those users have technically traveled 0 in terms of distance. Given that we need to represent the users as the single source of truth, we will use it in the FROM statement and then LEFT JOIN a table called rides.

SELECT 
    name
    , SUM(distance) AS distance_traveled
FROM users
LEFT JOIN rides
    ON users.id = rides.passenger_user_id
GROUP BY name
 

Lastly we need to order the values by two fields: the distance traveled and the name if the distances then match. We can do this by the ORDER BY function and set the total distance by DESC (descending) and the name field as ASC (ascending).

Note that when we reference the distance_traveled column we use the aggregation of SUM(distance). This is because many SQL engines require you to reference the actual aggregation instead of the column. Make a note of this for future interviews. As a way to make sure your syntax will always be correct, follow this format. 

 

SELECT 
    name
    , SUM(distance) AS distance_traveled
FROM users
LEFT JOIN rides
    ON users.id = rides.passenger_user_id
GROUP BY name
ORDER BY SUM(distance) DESC, name ASC

--
employees                             projects
+---------------+---------+           +---------------+---------+
| id            | int     |<----+  +->| id            | int     |
| first_name    | varchar |     |  |  | title         | varchar |
| last_name     | varchar |     |  |  | start_date    | date    |
| salary        | int     |     |  |  | end_date      | date    |
| department_id | int     |--+  |  |  | budget        | int     |
+---------------+---------+  |  |  |  +---------------+---------+
                             |  |  |
departments                  |  |  |  employees_projects
+---------------+---------+  |  |  |  +---------------+---------+
| id            | int     |<-+  |  +--| project_id    | int     |
| name          | varchar |     +-----| employee_id   | int     |
+---------------+---------+           +---------------+---------+
 

Over budget on a project is defined when the salaries, prorated to the day, exceed the budget of the project.

For example, if Alice and Bob both combined income make 200K and work on a project of a budget of 50K that takes half a year, then the project is over budget given 0.5 * 200K = 100K > 50K.

Write a query to select all projects that are over budget. Assume that employees only work on one project at a time.

Output:

column	type
project_title	varchar
project_forecast	float

Let's map out what the formula for constructing overbudget. In the question there was a simple example. If we define E as number of employees, PL as project length in days, S as in total salaries, and B as budget. Then our formula can be:

PL / 365 * (S*E) > B

To calculate this with SQL, we need this formula to apply on each row. This means we need each project to have it's own row, with each variable having it's own column like shown.

title   | project_days  | budget    | total_salary
--------+---------------+-----------+-------------
tps     | 100           | 50,000    | 100,000
reports | 125           | 200,00    | 250,000   
..
To get there we need to do join each table together with the corresponding information and then aggregate by title to get each project within it's own row.

SELECT 
    title
        -- days of project
        , DATEDIFF(end_date, start_date) AS project_days
        , budget
        -- coalesce turns null values to 0 in case of left joins
        , SUM(COALESCE(salary,0)) AS total_salary
    FROM projects AS p
    LEFT JOIN employees_projects AS ep
        ON p.id = ep.project_id
    LEFT JOIN employees AS e 
        ON e.id = ep.employee_id
    GROUP BY 1,2,3
Notice how we're left joining  to both  and . This is due to the effect that if there exists no employees on a project, we still need to define it as overbudget and setting the salaries as 0.

We're also grouping by title, project_days, and budget, so that we can get the total sum. Given that each of title, project_days, and budget are distinct for each project, we can do the group by without a fear of duplication in our SUM.

Finally, we can wrap the query into a sub-query and apply our equation to each project title with a CASE statement to tell if the project is over budget or not. 

SELECT 
    title
    , CASE WHEN 
        CAST(project_days AS DECIMAL)/365 * total_salary > budget 
        THEN 'overbudget' ELSE 'within budget' 
      END AS project_forecast
FROM (
    SELECT 
          title
        , DATEDIFF(end_date, start_date) AS project_days
        , budget
        , SUM(COALESCE(salary,0)) AS total_salary
    FROM projects AS p
    LEFT JOIN employees_projects AS ep
        ON p.id = ep.project_id
    LEFT JOIN employees AS e 
        ON e.id = ep.employee_id
    GROUP BY 1,2,3
) AS temp

-- 
Twitter is rolling out more push notifications to users because they think users are missing out on good content.

Let's say that after we release more notifications, we suddenly see the total number of unsubscribes increase.

 

`events` table

column	type
user_id	integer
created_at	datetime
action	string
 

`variants` table

column	type
user_id	integer
experiment	string
variant	string
 

We're given two tables, one of events where actions are 'login', 'nologin', and 'unsubscribe' and another table of abtesting buckets for each user.

Write a query given these tables to display a metric or graph to understand how unsubscribes are affecting login rates over time. Let's say that all users are automatically put into the abtest. 

Intuitively, we are tasked with comparing multiple different variables at play here. There is the new notification system along with it's effect of creating more unsubscribes. We're not sure how unsubscribes are affecting login rates but we can plot a graph that would help us visualize how the login rates change before and after an unsubscribe from a user.

We can also see how the login rates compare for unsubscribes for each bucket of the ab test. Given that we want to measure two different changes, we know we have to eventually in SQL do a GROUP BY of two different variables: date and bucket variant. 

For us to visualize this, we'll need to plot two lines on an 2D graph. The x-axis will represent days until unsubscribing with a range of -30 to 0 to 30, in which -30 is thirty days before unsubscribing and 30 is 30 days after unsubscribing. The y-axis will represent the average login rate for each day. And we'll be plotting two lines for each of the abtest variants, control and test.

Cool, now that we have what we're going to graph, how do we write a query to get the dataset for the graph? We can make sure our dataset looks something like this:

 

variant | days_since_unsub | login_rate
--------+------------------+-----------
control |       -30        |    90%
test    |       -30        |    91%
..
 

We have each column representing a different axis or line for our graph.

Now for our SQL query. We know that we have to get every user that has unsubscribed so we will first INNER JOIN the  table to the  table where there exists an  event. Now we've isolated all users that have ever unsubscribed.

Additionally we have to then get every event in which the user has logged in and divide it by the total number of users that are eligible within the timeframe.

 

SELECT 
    variant
    , DATEDIFF('day', e1.created_at, e2.created_at) AS days_since_unsub
    , COUNT(DISTINCT CASE WHEN e2.action = 'login' THEN e2.user_id)/COUNT(DISTINCT abtest.user_id) AS login_rate
FROM variants as abtest
INNER JOIN events AS e1
    ON abtest.user_id = e1.user_id
        AND e1.action = 'unsubscribe'
INNER JOIN events AS e2
    ON abtest.user_id = e2.user_id
        AND e2.action IN ('login', 'nologin')
        AND DATEDIFF('day', e1.created_at, e2.created_at) 
            BETWEEN -30 AND 30
GROUP BY 1,2

--
events table

column	type
id	integer
user_id	integer
created_at	datetime
action	string
url	string
platform	string
In the table above, column `action` represents either ('post_enter', 'post_submit', 'post_canceled') for when a user starts a post (enter), ends up canceling it (cancel), or ends up posting it (submit).

Write a query to get the post success rate for each day in the month of January 2020.

Sample:

user_id	created_at	event_name
123	2019-01-01	post_enter
123	2019-01-01	post_submit
456	2019-01-02	post_enter
456	2019-01-02	post_canceled
Output:

column	type
dt	datetime
post_success_rate	float

Let's see if we can clearly define the metrics we want to calculate before just jumping into the problem. We want post success rate for each day over the past week.

To get that metric let's assume post success rate can be defined as:

(total posts created) / (total posts entered)

Additionally since the success rate must be broken down by day, we must make sure that a post that is entered must be completed on the same day.

Cool, now that we have these requirements, it's time to calculate our metrics. We know we have to GROUP BY the date to get each day's posting success rate. We also have to break down how we can compute our two metrics of total posts entered and total posts actually created.

Let's look at the first one. Total posts entered can we calculated by a simple query such as filtering for where the event is equal to 'enter'.

SELECT COUNT(user_id)
FROM events
WHERE action = 'post_enter'
Now we have to get all of the users that also successfully created the post in the same day. We can do this with a join and set the correct conditions. The conditions are:
- Same user
- Successfully posted
- Same day

We can get those by doing a LEFT JOIN to the same table, and adding in those conditions. Remember we have to do a LEFT JOIN in this case because we want to use the join as a filter to where the conditions have been successfully met. 

SELECT *
FROM events AS c1
LEFT JOIN events AS c2
    ON c1.user_id = c2.user_id
        AND c2.action = 'post_submit'
        AND DATE(c1.created_at) = DATE(c2.created_at)
WHERE c1.action = 'post_enter'
    AND MONTH(c1.created_at) = 1
    AND YEAR(c1.created_at) = 2020
However this query runs into an issue in which if we join on all of our conditions, we'll find that if a user posted multiple times in the same day, we'll be dealing with a multiplying join that will square the actual number of posts that we did. 

To simplify it, all we need to do instead is ignore the JOIN, and take the count of all of the events that are posts divided by all of the events that are enter.

SELECT 
    DATE(c1.created_at) AS dt
    , COUNT(c2.user_id) / COUNT(c1.user_id) AS success_rate
FROM events AS c1
LEFT JOIN events AS c2
    ON c1.user_id = c2.user_id
        AND c2.action = 'post_submit'
        AND DATE(c1.created_at) = DATE(c2.created_at)
WHERE c1.action = 'post_enter'
    AND MONTH(c1.created_at) = 1
    AND YEAR(c1.created_at) = 2020
GROUP BY 1


employees    
+---------------+---------+     
| id            | int     |
| first_name    | varchar |     
| last_name     | varchar |     
| salary        | int     |     
| department_id | int     |--+  
+---------------+---------+  |  
                             |
departments                  |
+---------------+---------+  |  
| id            | int     |<-+  
| name          | varchar |     
+---------------+---------+     
Write a SQL query to select the 2nd highest salary in the engineering department. If more than one person shares the highest salary, the query should select the next highest salary.

Output:

column	type
salary	int

When the question prompts for "2nd highest" anything, many times people's heads go straight to partition rank functions. Do not be fooled, the question asks for a singular value.

This can be done easily by first selecting all of the salaries within engineering. We'll join on the department_id in both fields and filter where the department name is equivalent to 'engineering'.

Now that we have all of the salaries, we can order by salary and only select the top two after grabbing all of the distinct values by grouping by the salary field. Then we can query from this CTE and reverse the order and select the top one which will then by the second highest salary.

SELECT
    salary
FROM (
    SELECT salary
    FROM employees
    INNER JOIN departments
        ON employees.department_id = departments.id
    WHERE departments.name = 'engineering'
    GROUP BY 1
    ORDER BY 1 DESC
    LIMIT 2
) AS t
ORDER BY 1 ASC
LIMIT 1
Alternative Solution (using OFFSET):

We can use the OFFSET clause, after LIMIT, to skip a prespecified number of rows before returning the rows. In this case, since our salaries are sorted in descending order, and we want the second highest salary, we can offset the highest salary row:

SELECT salary
    FROM employees
    INNER JOIN departments
        ON employees.department_id = departments.id
    WHERE departments.name = 'engineering'
    GROUP BY 1
    ORDER BY 1 DESC
    LIMIT 1 OFFSET 1

--
`transactions` table

column	type
id	integer
user_id	integer
created_at	datetime
product_id	integer
quantity	integer
`products` table

column	type
id	integer
name	string
price	float
 

Let's say we have two tables, `transactions` and `products`. Hypothetically the `transactions` table consists of over a billion rows of purchases bought by users.

We are trying to find paired products that are often purchased together by the same user, such as wine and bottle openers, chips and beer, etc..

Write a query to find the top 100 paired products and their names.

Output:

column	type
P1	string
P2	string
count	integer

We are tasked with finding pairs of products which are purchased together by the same user. Before we can do anything, however, we need to join the two tables: transactions and products on id = product_id, so that we can associate each transaction with a product name:

 

SELECT  user_id, created_at, products.name 
FROM transactions 
JOIN products 
    ON transactions.product_id = products.id
 

Afterwards, we are faced with the first challenge of selecting all instances where the user purchased a pair of products together. One intuitive way to accomplish this is to select all created_at dates in which more than one transaction occurred by the same user_id, which would look like this:

 

SELECT  
   user_id
   , created_at
   , products.name 
FROM transactions 
JOIN products 
    ON transactions.product_id = products.id
WHERE transactions.id NOT IN (
    SELECT id 
    FROM transactions 
    GROUP BY created_at, user_id 
    HAVING COUNT(*) = 1
)
 

This is an acceptable way to accomplish the task but it runs into trouble in the next step, where we will need to count all unique instances of each pairing of products.

Fortunately, there is a clever solution which handles both parts of the problem efficiently. By self joining the combined table with itself, we can specify the join to connect rows sharing created_at and user_id:

 

WITH purchases AS (
    SELECT  
       user_id
       , created_at
       , products.name 
FROM transactions 
JOIN products 
    ON transactions.product_id = products.id 
)

SELECT 
   t1.name AS P1
   , t2.name AS P2
   , count(*)
FROM purchases AS t1 
JOIN purchases AS t2 
   ON t1.user_id = t2.user_id 
      AND t1.created_at = t2.created_at
 

The self join produces every combination of pairs of products purchased. However, looking at the resulting selection, it becomes clear that there is an issue:


Product 1

Product 2

federal discuss hard

federal discuss hard

night sound feeling

night sound feeling

go window serious

go window serious

outside learn nice

outside learn nice

 

We are including pairs of the same products in our selection.

To fix this, we add AND t1.name < t2.name. One additional problem that this solves for us is that it enforces a consistent order to the pairing of names throughout the table, namely that the first name will be alphabetically “less” than the second one (i.e. A < Z). This is important because it avoids the potential problem of undercounting pairs of names that are in different orders (i.e. A & B vs B & A).

Finally, we can then finish the problem by grouping and ordering in order to count the total occurrences of each pair.

 

WITH purchases AS (
    SELECT  
       user_id
       , created_at
       , products.name 
FROM transactions 
JOIN products 
    ON transactions.product_id = products.id 
)

SELECT 
   t1.name AS P1
   , t2.name AS P2
   , count(*)
FROM purchases AS t1 
JOIN purchases AS t2 
   ON t1.user_id = t2.user_id 
      AND t1.name < t2.name
      AND t1.created_at = t2.created_at
GROUP BY 1,2 ORDER BY 3 DESC
LIMIT 100

--
`transactions` table

column	type
id	integer
user_id	integer
created_at	datetime
product_id	integer
quantity	integer
Given a transactions table with date timestamps, sample every 4th row ordered by the date.

Output:

column	type
created_at	datetime
product_id	integer

If we're sampling from this table and we want to specifically sample every fourth value, we'll probably have to use a window function.

Generally the rule of thumb is if the question states or asks for some Nth value like the third purchase of each customer or the tenth notification sent, then window functions are the best options given they allow us to use the RANK() or ROW_NUMBER() function to provide a numerical index based on a certain ordering.

In this case we can use the row number function which allows us to partition by any value we want. Since we don't need the partition in this case because our dataset is just a date and a value, we can assign a row number for the entire dataset which allows us to order all of our values by the date and time.
 

Given a table with event logs, find the top five users with the longest continuous streak of visiting the platform in 2020.

Note: A continuous streak counts if the user visits the platform at least once per day on consecutive days. 

Output

column	type
user_id	integer
streak_length	integer

WITH grouped AS (
    SELECT 
        DATE(DATE_ADD(created_at, INTERVAL -ROW_NUMBER() 
            OVER (PARTITION BY user_id ORDER BY created_at) DAY)) AS grp,
        user_id, 
        created_at 
    FROM (
        SELECT * 
        FROM events 
        GROUP BY created_at, user_id) dates
)
SELECT 
    user_id, streak_length 
FROM (
    SELECT user_id, COUNT(*) as streak_length
    FROM grouped
    GROUP BY user_id, grp
    ORDER BY COUNT(*) desc) c
GROUP BY user_id
LIMIT 5
 

Explanation:

We need to find the top five users with the longest continuous streak of visiting the platform. Before anything else, let’s make sure we are selecting only distinct dates from the created_at column for each user so that the streaks aren’t incorrectly interrupted by duplicate dates. 

SELECT *
        FROM events
        GROUP BY created_at, user_id) dates
After that, the first step is to find a method of calculating the “streaks” of each user from the created_at column. This is a “gaps and islands” problem, in which the data is split into “islands” of consecutive values, separated by “gaps” (i.e. 1-2-3, 5-6, 9-10). A clever trick which will help us group consecutive values is taking advantage of the fact that subtracting two equally incrementing sequences will produce the same difference for each pair of values. 

For example, [1, 2, 3, 5, 6] - [0, 1, 2, 3, 4] = [1, 1, 1, 2, 2].

By creating a new column containing the result of such a subtraction, we can then group and count the streaks for each user. For our incremental sequence, we can use the row number of each event, obtainable with either window functions: ROW_NUMBER() or DENSE_RANK(). The difference between these two functions lies in how they deal with duplicate values, but since we need to remove duplicate values either way to accurately count the streaks, it doesn’t make a difference. 

SELECT 
        DATE(DATE_ADD(created_at, INTERVAL -ROW_NUMBER() 
            OVER (PARTITION BY user_id ORDER BY created_at) DAY)) AS grp,
        user_id, 
        created_at 
    FROM (
        SELECT * 
        FROM events 
        GROUP BY created_at, user_id) dates
With the events categorized into consecutive streaks, it is simply a matter of grouping by the streaks, counting each group, selecting the highest streak for each user, and ranking the top 5 users.

WITH grouped AS (
    SELECT 
        DATE(DATE_ADD(created_at, INTERVAL -ROW_NUMBER() 
            OVER (PARTITION BY user_id ORDER BY created_at) DAY)) AS grp,
        user_id, 
        created_at 
    FROM (
        SELECT * 
        FROM events 
        GROUP BY created_at, user_id) dates
)
SELECT 
    user_id, streak_length 
FROM (
    SELECT user_id, COUNT(*) as streak_length
    FROM grouped
    GROUP BY user_id, grp
    ORDER BY COUNT(*) desc) c
GROUP BY user_id
LIMIT 5
Note that the second subquery was necessary in order to get the streak_length (count) as a column in our final selection, as it involves multiple groupings.

--
`sms_sends` table

column	type
ds	datetime
country	string
carrier	string
phone_number	integer
type	string
 

`confirmers` table

column	type
date	datetime
phone_number	integer
 

We're given two tables, one that represents SMS sends to phone numbers and the other represents confirmations from SMS sends. 

1. Write a query to calculate the number of phone numbers that we sent 'confirmation' SMS texts to yesterday by carrier and country.

Example: 

ds	country	carrier	phone_number	type
2017-10-01	US	sprint	8005551111	confirmation
2017-10-01	US	sprint	8005551111	friend_request
2017-10-01	US	at&t	8005550000	confirmation
2017-10-01	US	at&t	8005550000	confirmation
2017-10-01	CA	rogers	8005550101	message
 

2. Calculate what percentage of users were confirmed per day.

1. The first question is pretty straightforward. We just have to note that we want only the texts that are 'confirmations' and get the 'number of phone numbers' that we sent the texts to yesterday.

In that case that means we want the distinct phone number and not the distinct number of texts sent.

 

SELECT carrier, country, COUNT(DISTINCT phone_number)
FROM sms_sends
WHERE type = 'confirmation'
AND ds = DATE_SUB(current_date, INTERVAL 1 DAY)
GROUP BY 1,2
 

2. This problem is a little trickier. We definitely need our second table which is the data on which phones actually confirmed the text messages.

It seems pretty simple in that we just have to figure out:

(Number of confirmation texts sent) / (Number of confirmation texts confirmed)

But notice how we have to actually get this value by day. In which since the timeframe is not specified, we can assume that the texts that are sent should be confirmed within the same day or else it's not a valid confirmation.

In this case we have to do a LEFT JOIN onto the confirmers table and then JOIN on two different columns: the phone_number and date. That way we can get the confirmations that happened in the same day.

 

SELECT ss.ds, COUNT(DISTINCT c.phone_number)/COUNT(DISTINCT ss.phone_number)
FROM sms_sends AS ss
LEFT JOIN comfirmers AS c 
    ON ss.phone_number = c.phone_number
        AND ss.ds = c.date
WHERE type = 'confirmation'
GROUP BY 1
 

Note that we also specified the type = 'confirmation' in the WHERE clause instead of the join. This is because if we LEFT JOIN and add the type = 'confirmation' in the join, we wouldn't be filtering the base table, , for only the confirmation texts.


`attribution` table

column	type
session_id	integer
channel	string
conversion	boolean
 

`user_sessions` table

column	type
session_id	integer
created_at	datetime
user_id	integer
 

The schema above is for a retail online shopping company consisting of two tables, attribution and user_sessions. 

The attribution table logs a session visit for each row.
If conversion is true, then the user converted to buying on that session.
The channel column represents which advertising platform the user was attributed to for that specific session.
Lastly the `user_sessions` table maps many to one session visits back to one user.
First touch attribution is defined as the channel to which the converted user was associated with when they first discovered the website.

Calculate the first touch attribution for each user_id that converted. 

Example output:

user_id	channel
123	facebook
145	google
153	facebook
172	organic
173	email

First touch attribution is tricky because we have to look at the full span of the user's visits ONLY if they converted as a customer.

Therefore we need to do two actions: subset all of the users that converted to customers and figure out their first session visit to attribute the actual channel. We can do that by creating a sub-query that only gets the distinct users that have actually converted.

 

-- grab all of the users that converted and create a CTE
WITH conv AS (
    SELECT user_id
    FROM attribution AS a
    INNER JOIN user_sessions AS us 
        ON a.session_id = us.session_id
    WHERE conversion = 1
    GROUP BY 1 -- group by to get distinct user_ids
)

SELECT * FROM conv
 

Given these converted user_ids, we now have to figure out on which session they actually first visited the site. Given that the session that the user first visited could be different from the one they converted, we need to identify the first session.

We can do this by using the  field to identify the first time the user visited the site. If we group by the `user_id`, we can aggregate the date time and apply the MIN() function to find the user's first visit.

Afterwards all we then have to do is join the minimum  date time and  back to the attribution table to find the session and channel for which the user first arrived on the site. 

 

WITH conv AS (
    SELECT us.user_id
    FROM attribution AS a
    INNER JOIN user_sessions AS us 
        ON a.session_id = us.session_id
    WHERE conversion = 1
    GROUP BY 1 -- group by to get distinct user_ids
),

-- get the first session by user_id and created_at time. 
first_session AS (
    SELECT 
        min(us.created_at) AS min_created_at
        , conv.user_id
    FROM user_sessions AS us
    INNER JOIN conv 
        ON us.user_id = conv.user_id
    INNER JOIN attribution AS a 
        ON a.session_id = us.session_id
    GROUP BY conv.user_id
)

-- join user_id and created_at time back to the original table.
SELECT us.user_id, channel
FROM attribution
JOIN user_sessions AS us 
    ON attribution.session_id = us.session_id
-- now join the first session to get a single row for each user_id
JOIN first_session
-- double join 
    ON first_session.min_created_at = us.created_at 
        AND first_session.user_id = us.user_id

==
`friend_requests` table

column	type
requester_id	integer
requested_id	integer
created_at	datetime
 

`friend_accepts` table

column	type
acceptor_id	integer
requester_id	integer
created_at	datetime
 

We're given two tables. `friend_requests`holds all the friend requests made and `friend_accepts` is all of acceptances.

Write a query to find the overall acceptance rate of friend requests.

Output:

column	type
acceptance_rate	float

The overall acceptance rate is going to be computed by the total number of acceptances of friend requests divided by the total friend requests given:

Count of acceptances / Count of friend requests

We can pretty easily get both values. Our denominator will be the total number of friend requests which will be the base table. We can compute the total number of acceptances by then LEFT JOINING to the  table.

In the JOIN, we have to make sure we're joining on the correct columns. In this case we have to match our requester_id to the requestor_id and be sure to also match on the second column of requested_id to acceptor_id. Note that we cannot compute the DISTINCT count given that users can send and accept friend requests to multiple other users. 

 

SELECT COUNT(a.acceptor_id)/COUNT(r.requester_id)
FROM friend_requests r
LEFT JOIN friend_accepts AS a 
ON r.requester_id = a.requester_id 
        AND r.requested_id = a.acceptor_id;

==
There are two tables. One table is called `swipes` that holds a row for every Tinder swipe and contains a boolean column that determines if the swipe was a right or left swipe called `is_right_swipe`. The second is a table named `variants` that determines which user has which variant of an AB test.

Write a SQL query to output the average number of right swipes for two different variants of a feed ranking algorithm by comparing users that have swiped the first 10, 50, and 100 swipes on their feed.

Tip: Users have to have swiped at least 10 times to be included in the subset of users to analyze the mean number of right swipes.

Example Input:

`variants`

id	experiment	variant	user_id
1	feed_change	control	123
2	feed_change	test	567
3	feed_change	control	996
`swipes`

id	user_id	swiped_user_id	created_at	is_right_swipe
1	123	893	2018-01-01	0
2	123	825	2018-01-02	1
3	567	946	2018-01-04	0
4	123	823	2018-01-05	0
5	567	952	2018-01-05	1
6	567	234	2018-01-06	1
7	996	333	2018-01-06	1
8	996	563	2018-01-07	0
Note: created_at doesn't show timestamps but assume it is a datetime column.

Output:

mean_right_swipes	variant	swipe_threshold	num_users
5.3	control	10	9560
5.6	test	10	9450
20.1	control	50	2001
22.0	test	50	2019
33.0	control	100	590
34.0	test	100	568

If you're a data scientist in charge of improving recommendations at a company and you develop an algorithm, how do you know if it performs better than the existing one?

One metric to measure performance is called precision (also called positive predictive value), which has applications in machine learning as well as information retrieval. It is defined as the fraction of relevant instances among the retrieved instances.

Given the problem set of measuring two feed ranking algorithms, we can break down this problem as measuring the mean precision between two different algorithms by comparing average right swipes for two different populations for the users first 10, 50, and 100 swipes.

We're given two tables, one called  that essentially breaks down which test variant each user has received. It contains a column named  that we have to filter on for the  experiment. We know we have to join this table back to the `swipes` table in order to differentiate both of the variants from each other.

The other table, , is a transaction type table, meaning that it logs each users activity in the app. In this case, it's left and right swipes on other users.

Given the problem set, the first step is to formulate a way to average the right swipes for each user that satisfies the conditions of swiping at least 10, 50, and 100 total swipes. Given this condition, the first thing we have to do is add a rank column to the swipe table. That way we can look at each user's first X swipes.

 

WITH swipe_ranks AS (
    SELECT 
        swipes.user_id
        , variant
        , RANK() OVER (
            PARTITION BY user_id ORDER BY created_at ASC
        ) AS ranks
        , is_right_swipe
    FROM swipes
    INNER JOIN variants 
        ON swipes.user_id = variants.user_id
    WHERE experiment = 'feed_change'
)
SELECT * FROM swipe_ranks
 

Observe how we implement a RANK function by partitioning by user_id and ordering by the created_at field. This gives us a rank of 1 for the first swipe the user made, 2 for the second, and etc...

Now our swipe_ranks table looks like this:

 

user_id	variant	created_at	rank	is_right_swipe
123	control	2018-01-01	1	0
123	control	2018-01-02	2	1
567	test	2018-01-04	1	0
123	control	2018-01-05	3	0
567	test	2018-01-05	2	1
567	test	2018-01-06	3	1
996	control	2018-01-06	1	1
996	control	2018-01-07	2	0
 

Notice how the rank value does not reach above 3 in our sample data. Since each user needs to swipe on at least 10 users to reach the minimum swipe threshold, each of these users would be subsetted out of the analysis.

Constructing a query, we can create a subquery that specifically gets all the users that swiped at least 10 times. We can do that by using a COUNT(*) function or by looking where the rank column is greater than 10.

 

WITH swipe_ranks AS (
    SELECT 
        swipes.user_id
        , variant
        , RANK() OVER (
            PARTITION BY user_id ORDER BY created_at ASC
        ) AS ranks
        , is_right_swipe
    FROM swipes
    INNER JOIN variants 
        ON swipes.user_id = variants.user_id
    WHERE experiment = 'feed_change'
)
SELECT user_id
FROM swipe_ranks
WHERE ranks > 10
GROUP BY 1
 

Then we can rejoin these users into the original swipe ranks table, group by the experiment variant, and take an average of the number of right swipes each user made where the rank was less than 10.

Remember that we have to specify a filter for the rank column because we cannot analyze swipe data greater than the threshold we are setting since the recommendation algorithm is intended to move more relevant matches to the top of the feed.

 

WITH swipe_ranks AS (
    SELECT 
        swipes.user_id
        , variant
        , RANK() OVER (
            PARTITION BY user_id ORDER BY created_at ASC
        ) AS ranks
        , is_right_swipe
    FROM swipes
    INNER JOIN variants 
        ON swipes.user_id = variants.user_id
    WHERE experiment = 'feed_change'
)
SELECT 
    variant
    , CAST(SUM(is_right_swipe) AS DECIMAL)/COUNT(DISTINCT sr.user_id) AS mean_right_swipes
    , 10 AS swipe_threshold
    , COUNT(DISTINCT sr.user_id) AS num_users
FROM swipe_ranks AS sr
INNER JOIN (
    SELECT swipe_ranks.user_id
    FROM swipe_ranks
    WHERE ranks > 10
    GROUP BY 1
) AS subset 
    ON subset.user_id = sr.user_id
WHERE ranks <= 10
GROUP BY 1
 

Awesome! This should work. Notice this value gives us the value for only the threshold of rank under 10. We can copy most of the code and re-use it for 50 and 100 by unioning the tables together. Putting it all together now.

 

WITH swipe_ranks AS (
    SELECT 
        swipes.user_id
        , variant
        , RANK() OVER (
            PARTITION BY user_id ORDER BY created_at ASC
        ) AS ranks
        , is_right_swipe
    FROM swipes
    INNER JOIN variants 
        ON swipes.user_id = variants.user_id
    WHERE experiment = 'feed_change'
)

SELECT 
    variant
    , CAST(SUM(is_right_swipe) AS DECIMAL)/COUNT(DISTINCT sr.user_id) AS mean_right_swipes
    , 10 AS swipe_threshold
    , COUNT(DISTINCT sr.user_id) AS num_users
FROM swipe_ranks AS sr
INNER JOIN (
    SELECT user_id
    FROM swipe_ranks
    WHERE ranks >= 10
    GROUP BY 1
) AS subset 
    ON subset.user_id = sr.user_id
WHERE ranks <= 10
GROUP BY 1

UNION ALL

SELECT 
    variant
    , CAST(SUM(is_right_swipe) AS DECIMAL)/COUNT(DISTINCT sr.user_id) AS mean_right_swipes
    , 50 AS swipe_threshold
    , COUNT(DISTINCT sr.user_id) AS num_users
FROM swipe_ranks AS sr
INNER JOIN (
    SELECT user_id
    FROM swipe_ranks
    WHERE ranks >= 50
    GROUP BY 1
) AS subset 
    ON subset.user_id = sr.user_id
WHERE ranks <= 50
GROUP BY 1

UNION ALL

SELECT 
    variant
    , CAST(SUM(is_right_swipe) AS DECIMAL)/COUNT(DISTINCT sr.user_id) AS mean_right_swipes
    , 100 AS swipe_threshold
    , COUNT(DISTINCT sr.user_id) AS num_users
FROM swipe_ranks AS sr
INNER JOIN (
    SELECT user_id
    FROM swipe_ranks
    WHERE ranks >= 100
    GROUP BY 1
) AS subset 
    ON subset.user_id = sr.user_id
WHERE ranks <= 100
GROUP BY 1

==
users table

columns	type
id	int
name	varchar
created_at	datetime
 

Given a users table, write a query to get the cumulative number of new users added by day, with the total reset every month. 

 

Example Output:

Date	Monthly Cumulative
2020-01-01	5
2020-01-02	12
...	...
2020-02-01	8
2020-02-02	17
2020-02-03	23

This question first seems like it could be solved by just running a COUNT(*) and grouping by date. Or maybe it's just a regular cumulative distribution function?

But we have to notice that we are actually grouping by a specific interval of month and date. And that when the next month comes around, we want to the reset the count of the number of users.

Tangetially aside - the practical benefit for a query like this is that we can get a retention graph that compares the cumulative number of users from one month to another. If we have a goal to acquire 10% more users each month, how do we know if we're on track for this goal on February 15th without having the same number to compare it to for January 15th?

Therefore how can we make sure that the total amount of users in January 31st rolls over back to 0 on February 1st?

Let's first just solve the issue of getting the total count of users. We know that we'll need to know the number of users that sign up each day. This can be written pretty easily. 

WITH daily_total AS (
    SELECT 
        DATE(created_at) AS dt 
       , COUNT(*) AS cnt
    FROM users
    GROUP BY 1
)
 

Now let's first take a pointer from the concept explained in the question Cumulative Distribution. If you haven't solved that problem yet, look at it first.

We know that this question is similar, except this time, we want to add a partition or interval where the cumulative value resets at the end of the month. Looking at this exercept from the question:

If we can model out that computation, we'll find that the cumulative is taken from the sum all of the frequency counts lower than the specified frequency index. In which we can then run our self join on a condition where we set the left f1 table frequency index as greater than the right table frequency index.

Okay, so we know that we have to specify a self join in the same way where we want to get the cumulative value by comparing each date against each other. But now the only difference here is that we add an additional condition in the join where the month and year have to be the same. That way we apply a filter to the same month and year AND limit the cumulative total. 

 

FROM daily_total AS t
LEFT JOIN daily_total AS u
    ON t.dt >= u.dt
        AND MONTH(t.dt) = MONTH(u.dt)
        AND YEAR(t.dt) = YEAR(u.dt)
 

Therefore if we bring it all together:

 

WITH daily_total AS (
    SELECT 
        DATE(created_at) AS dt 
       , COUNT(*) AS cnt
    FROM users
    GROUP BY 1
)

SELECT
    t.dt AS date
    , SUM(u.cnt) AS monthly_cumulative
FROM daily_total AS t
LEFT JOIN daily_total AS u
    ON t.dt >= u.dt
        AND MONTH(t.dt) = MONTH(u.dt)
        AND YEAR(t.dt) = YEAR(u.dt)
GROUP BY 1

--
`notification_deliveries` table

column	type
notification	varchar
user_id	int
created_at	datetime
 

`users` table

column	type
user_id	int
created_at	datetime
conversion_date	datetime
 

We're given two tables, a table of notification deliveries and a table of users with created and purchase conversion dates. If the user hasn't purchased then the `conversion_date` column is NULL.

Write a query to get the distribution of total push notifications before a user converts.

Output:

column	type
total_pushes	int
frequency	int

If we're looking for the distribution of total push notifications before a user converts, we can evaluate that we want our end result to look something like this:

total_pushes | frequency
-------------+----------
    0        |  100
    1        |  250
    2        |  300
   ...       |  ...
In order to get there, we have to follow a couple of logical conditions for the JOIN between  and 

We have to join on the  field in both tables.
We have to exclude all users that have not converted.
We have to set the  value as greater than the  value in the delivery table in order to get all notifications sent to the user. 
Cool, we know this has to be a LEFT JOIN additionally in order to get the users that converted off of zero push notifications as well. 

We can get the count per user, and then group by that count to get the overall distribution. 

SELECT total_pushes, COUNT(*) AS frequency
FROM (
    SELECT u.user_id, COUNT(*) as total_pushes
    FROM users AS u
    LEFT JOIN notification_deliveries AS nd
        ON u.user_id = nd.user_id
            AND u.conversion_date >= nd.created_at
    WHERE u.conversion_date IS NOT NULL
    GROUP BY 1
) AS pushes
GROUP BY 1

==
payments table

Column	Type
payment_id	integer
sender_id	integer
recipient_id	integer
created_at	datetime
payment_state	string
amount_cents	integer
 

users table

Column	Type
id	integer
created_at	datetime
neighborhood_id	integer
 

You're given two tables, payments and users. The payments table holds all payments between users with the payment_state column consisting of either 'success' or 'failed'. 

How many customers that signed up in January 2020 had a total successful sending and receiving volume greater than $100 in their first 30 days?

Note: The sender_id and recipient_id both represent the user_id

Output:

column	type
num_customers	int

https://www.youtube.com/watch?v=yy41VYI3l1U&feature=emb_title&ab_channel=DataScienceJay

`friends` table

column	type
user_id	integer
friend_id	integer
 

`page_likes` table

column	type
user_id	integer
page_id	integer
 

Let's say we want to build a naive recommender. We're given two tables, one table called `friends` with a user_id and friend_id columns representing each user's friends, and another table called `page_likes` with a user_id and a page_id representing the page each user liked.

Write an SQL query to create a metric to recommend pages for each user based on recommendations from their friends liked pages. 

Note: It shouldn't recommend pages that the user already likes.

Output:

column	type
user_id	integer
page_id	integer
num_friend_likes	integer

Let's solve this problem by visualizing what kind of output we want from the query. Given that we have to create a metric for each user to recommend pages, we know we want something with a user_id and a page_id along with some sort of recommendation score.

Let's try to think of an easy way to represent the scores of each user_id and page_id combo. One naive method would be to create a score by summing up the total likes by friends on each page that the user hasn't currently liked. Then the max value on our metric will be the most recommendable page.

The first thing we have to do is then to write a query to associate users to their friends liked pages. We can do that easily with an initial join between the two tables.

 

WITH t1 AS (
    SELECT 
        f.user_id 
        , f.friend_id
        , pl.page_id 
    FROM friends AS f
    INNER JOIN page_likes AS pl
        ON f.friend_id = pl.user_id
)
 

Now we have every single user_id associated with the friends liked pages. Can't we just do a GROUP BY on user_id and page_id fields and get the DISTINCT COUNT of the  field? Not exactly. We still have to filter out all of the pages that the original users also liked.

We can do that by joining the original  table back to the CTE. We can filter out all the pages that the original users liked by doing a LEFT JOIN on  and then selecting all the rows where the JOIN on user_id and page_id are NULL.

 

SELECT t1.user_id, t1.page_id, COUNT(DISTINCT t1.friend_id) AS num_friend_likes
FROM t1
LEFT JOIN page_likes AS pl
    ON t1.page_id = pl.page_id 
        AND t1.user_id = pl.user_id
WHERE pl.user_id IS NULL # filter out existing user likes
GROUP BY 1
 

In this case we only need to check one column, where pl.user_id IS NULL. Once we GROUP BY the user_id and page_id, we now can count the distinct number of friends, which will display the distinct number of likes on each page by friends creating our metric. 

==

users table

columns	type
id	int
name	varchar
neighborhood_id	int
created_at	datetime
 

neighborhoods table

columns	type
id	int
name	varchar
city_id	int
 

We're given two tables, a users table with demographic information and the neighborhood they live in and a neighborhoods table.

Write a query that returns all of the neighborhoods that have 0 users. 

Output:

columns	type
neighborhood_name	varchar

Whenever the question asks about finding values with 0 something (users, employees, posts, etc..) immediately think of the concept of LEFT JOIN! An inner join finds any values that are in both tables, a left join keeps only the values in the left table.

Our predicament is to find all the neighborhoods without users. To do this we must do a left join from the neighborhoods table to the users table which will give us an output like this:

 

neighborhoods.name  | users.id
____________________|__________
castro              | 123
castro              | 124
cole valley         | null
castro heights      | 534
castro heights      | 564
 

If we then add in a where condition of WHERE users.id IS NULL, then we will get every single neighborhood without a singular user.

SELECT n.name   
FROM neighborhoods AS n 
LEFT JOIN users AS u
    ON n.id = u.neighborhood_id
WHERE u.id IS NULL
 

An alternative method is to use the IN clause. This method involves finding all the neighborhoods that the user's live in, and then using that as a filter to subset all of the existing neighborhoods in the neighborhoods table. 

SELECT
  name
FROM neighborhoods
WHERE id NOT IN (
    SELECT DISTINCT neighborhood_id
    FROM users
)
 

This method might be slightly more inefficient depending on the SQL interpreter used. In this secondary method, we have to find the DISTINCT number of neighborhood IDs which would result in scanning the table once before then doing a second scan on the neighborhoods table. 

The first method however does a join but then only needs to do one scan through the combined tables to filter out the NULL values. 

Overall if you're using an advanced SQL interpreter, it will find the most efficient method out of the existing ones no matter what. 

--
`notification_deliveries` table

column	type
notification	varchar
user_id	int
created_at	datetime
 

`users` table

column	type
user_id	int
created_at	datetime
conversion_date	datetime
 

We're given two tables, a table of notification deliveries and a table of users with created and purchase conversion dates. If the user hasn't purchased then the `conversion_date` column is NULL.

Write a query to get the conversion rate for each notification.

Example Output:

notification	conversion_rate
activate_premium	0.05
try_premium	0.03
free_trial	0.11

This question is a little trickier and surprisingly complex so we should begin to break it down by working backwards. 

Let's try to understand the formula for computing the value we want. For each notification, we want the number of notifications delivered with conversions divided by the number of notifications delivered to users that haven't converted yet. 

That's kind of confusing but if try to simplify it, the numerator is the total number of conversions off that notification, and the denominator is total notifications sent minus the already converted users. 

To get these values, we first need to understand how to query for the notifications delivered with conversions. Given we only have the conversion date, we understood from the prior question that the notification that we convert on is the last notification that the user receives before the conversion date. 

We can model that by joining the two tables and getting the MAX value of the notification date that occurred before the conversion date. That way we can rejoin the date and user_id back to the notifications table to figure out which notification value it was.

WITH conv_dt AS (
    SELECT nd.user_id, MAX(nd.created_at) AS notif_conversion_dt
    FROM users
    INNER JOIN notification_deliveries AS nd
        ON u.user_id = nd.user_id
            AND u.conversion_date >= nd.created_at
    WHERE u.conversion_date IS NOT NULL
    GROUP BY 1
)


Now we'll re-join the CTE back to the notification_deliveries table. Notice how we're joining on only the user_id and then creating a CASE statement to flag which notification the conversion occured on. This way, we can still get all of the notifications that were sent to the user which will eventually be our denominator.

 

WITH conv AS (
    SELECT 
        nd.notification
        , nd.user_id
        , CASE WHEN conv_dt.notif_conversion_dt = nd.created_at THEN 1 ELSE 0 END AS notif_converted
        , conv_dt.notif_conversion_dt
    FROM notification_deliveries AS nd
    INNER JOIN conv_dt
        ON nd.user_id = conv_dt.user_id
) 
 

Now given our CTE, we can join this back to  once again. This time we join on a condition only where everything on the left side will be the notifications sent to users before conversion, and the right side will be the conversions.

That way all we have to do is SUM the  flag and divide by the total COUNT.

 

SELECT
    nd.notification
    , SUM(notif_converted)/COUNT(*) AS conversion_rate
FROM notification_deliveries AS nd
INNER JOIN conv 
    ON nd.notification = conv.notification
        AND nd.user_id = conv.user_id
        AND nd.created_at <= conv.notif_conversion_dt
GROUP BY 1

==
employees table

columns	types
id	int
first_name	varchar
last_name	varchar
salary	int
department_id	int
 

departments table

columns	types
id	int
name	varchar
 

Given the tables above, select the top 3 departments by the highest percentage of employees making over 100K in salary and have at least 10 employees.

Example output:

percentage_over_100K	department name	number of employees
90%	engineering	25
50%	marketing	50
12%	sales	12

Let's approach this problem by looking at the output of what the response would look like.

We know that we need to calculate the total number employees that are making over $100K by each department. This means that we're going to have to run a GROUP BY on the department name since we want a new row for each department.  

We also need a formula to represent how we can differentiate employees that make over $100K and those that make less. We can calculate that by formulating:

(Number of people making over $100K) / (Total number of people in that department)

Now in terms of implementation, if we first do a JOIN between the employees table and the departments table, then we can get all of the datapoints we need together. Then all that is left is:

a function to get all of the employees
a function to get all employees making over 100K
dividing those values by each other
 

1. A JOIN to the employees table to get all of the employee salaries

SELECT * 
FROM departments AS d
LEFT JOIN employees AS e
    ON d.id = e.department_id
 

2. A HAVING clause to filter out departments with under 10 employees after our GROUP BY

SELECT 
    d.name
FROM departments AS d
LEFT JOIN employees AS e
    ON d.id = e.department_id
GROUP BY d.name
HAVING COUNT(*) >= 10
Why do we use a HAVING clause instead of a WHERE clause?

HAVING in particular allows us to apply a filter after a GROUP BY without having to then wrap the original query in a sub-query. 

 

3. A CASE WHEN clause then allows us to differentiate when a employee makes over 100K. We can do this by running a SUM only when the employee is making over 100K. If the employee makes over 100K, then we mark the employee as a 1, otherwise we mark them as a 0. 

SELECT SUM(CASE WHEN
        salary > 100000 THEN 1 ELSE 0
    END) AS Total
FROM employees
 

Now putting it all together. We finally need to get the percentage by taking the actual count of employees. 

 

SELECT CAST(SUM(
        CASE WHEN 
            salary > 100000 THEN 1 ELSE 0 
        END) AS DECIMAL
      )/COUNT(*) AS percentage_over_100K
      , d.name as department_name
      , COUNT(*) AS number_of_employees
FROM departments AS d
LEFT JOIN employees AS e
    ON d.id = e.department_id
GROUP BY d.name
HAVING COUNT(*) >= 10
ORDER BY 2 DESC
LIMIT 3

==
`account_status` table

column	type
account_id	integer
date	datetime
status	string
 

Given the table of account statuses, compute the percentage of accounts that were closed on January 1st, 2020 (over the total number of accounts). Each account can have only one record at the daily level indicating the status at the end of the day.

Example:

account_id	date	status
1	2020-01-01	closed
1	2019-12-31	open
2	2020-01-01	closed
Output:

column	type
percentage_closed	float
 
==
We're given two tables. Table A has one million records with fields ID and AGE. Table B has 100 records with two fields as well, ID and SALARY.

Let's say in Table B, the mean salary is 50K and the median salary is 100K.

SELECT A.ID,A.AGE,B.SALARY
FROM A
LEFT JOIN B
ON A.ID = B.ID
WHERE B.SALARY > 50000
1. Given the query above gets run, about how many records would be returned?

2. What would you estimate as the average salary of the records returned?

1. This question is tricky and it tests two different concepts. SQL JOINs and if the interviewer understands the concept of distributions in means and medians.

In the SQL query we're given that Table A has 1 million rows and Table B has only a 100. Assuming that the IDs are unique in both tables, if we were to run a regular INNER JOIN between the two tables we would assume 100 records returned from the constraint on the size based on the number of rows in Table B.

What happens when we run a left join? Without the WHERE clause this statement would return a million rows given that Table A would keep all of it's records since a LEFT JOIN retains all the records in the table referenced in the FROM statement.

SELECT A.ID,A.AGE,B.SALARY
FROM A
LEFT JOIN B
ON A.ID = B.ID
Yet since we added in a WHERE filter on Table B where B is greater than 50000, it reduces the size of the joined tables to the number of values in table B which satisfy thus condition. Since the median is double the mean, this means that the distribution of salaries is skewed to the left, but the mean is still 50000.

The 50th percentile is equivalent to the median, which means that half of all observations will be larger than the median, and half of the observations will be lower than the median. Since we are filtering on values greater than 50K but still less than the median, we can assume that the number of values returned will be between 50 and 100, likely around 66. 

2. We're given that the median is 100K which is double the mean. This means if we were to visualize the distribution, we would see a spike at somewhere less than 50K, and then a long tail or small spike greater than 100K for a bimodal distribution.

Given that we're only returning the salaries that are greater than 50K, we can be confident that now the distribution of the resulting salaries will be greater than 100K on the long tail given the median was double the mean.

==
subscriptions table

column	type
user_id	int
start_date	date
end_date	date
 

Given a table of product subscriptions with a subscription start date and end date for each user, write a query that returns true or false whether or not each user has a subscription date range that overlaps with any other user.

Example:

user_id	start_date	end_date
1	2019-01-01	2019-01-31
2	2019-01-15	2019-01-17
3	2019-01-29	2019-02-04
4	2019-02-05	2019-02-10
 

Output

user_id	overlap
1	True
2	True
3	True
4	False

What's the complexity of the solution?

We know that there's going to be a comparison of each subscription against every other one. 

gotcha 2
Are you making sure that a user is not compared to their own subscription?

solution
Let's take a look at each of the conditions first and see how they could be triggered. Given two date ranges, what determines if the subscriptions would overlap?

Let's set an example with two dateranges: A and B.

Let ConditionA>B demonstrate that DateRange A is completely after DateRange B.

_                        |---- DateRange A ------| 
|---Date Range B -----|                           _
ConditionA>B is true if StartA > EndB.

Let ConditionB>A demonstrate that DateRange B is completely after DateRange A.

|---- DateRange A -----|                       _ 
 _                          |---Date Range B ----|
Condition B>A is true if EndA < StartB.

Overlap then exists if neither condition is held true. In that if one range is neither completely after the other, nor completely before the other, then they must overlap.

De Morgan's laws says that:

Not (A Or B) <=> Not A And Not B.

Which is equivalent to: Not (StartA > EndB) AND Not (EndA < StartB)

Which then translates to: (StartA <= EndB) and (EndA >= StartB).

Awesome, we've figured out the logic. Given this condition, how can we apply it to SQL?

Well we know we have to use the condition as logic for our join. In this case we'll be joining to the same table but comparing each user to a different user in the table. We also want to run a left join to match each other user that satisfies our condition. In this case it should look like this:

 

SELECT *
FROM subscriptions AS s1
LEFT JOIN subscriptions AS s2
    ON s1.user_id != s2.user_id
        AND s1.start_date <= s2.end_date
        AND s1.end_date >= s2.start_date
 

We've set s1 as our A and s2 as our B. Given the conditional join, a user_id from s2 should exist for each user_id in s1 on the condition where there exists overlap between the dates.

Wrapping it all together now, we can group by the s1.user_id field and just check if any value exists true for where s2.user_id IS NOT NULL.

 

SELECT
    s1.user_id
    , MAX(CASE WHEN s2.user_id IS NOT NULL THEN 1 ELSE 0 END) AS overlap
FROM subscriptions AS s1
LEFT JOIN subscriptions AS s2
    ON s1.user_id != s2.user_id
        AND s1.start_date <= s2.end_date
        AND s1.end_date >= s2.start_date
GROUP BY 1

==
Let's say we want to run some data collection on the Golden Gate bridge.

1. What would the table schema look like if we wanted to track how long each car took coming into San Francisco to enter and exit the bridge? Let's say we want to track additional descriptives like the car model and license plate.

2. Write a query on the given tables to get the time of the fastest car on the current day.

3. Write a query on the given tables to get the car model with the average fastest times for the current day. (Example: Let's say three ferararis crossed the bridge on average in one minute). 

1. This question functions slightly more like data engineering or architecture program. Given a certain use case or application, we have to model how we want to store the information.

In this case we're given that we have to track time entered and exited leaving the bridge, but also the car make and model along with license plate information. We know that the car model to license plate information will be one to many, given that each license plate represents a single car, and a car model can be replicated many times.

Let's model the schema in this format then of each drive across the bridge as a distinct event. We can set an  and  for each car as they go through the bridge.

 table

column	type
id	integer
license_plate	varchar
enter_time	datetime
exit_time	datetime
car_model_id	integer
 

 table

column	type
id	integer
model_name	varchar
 

Notice how we set a foreign key to represent each car model. Given there can be many duplicate car models in the  table, setting the value to an integer foreign key allows us to save space in our schema when representing the model name of the car multiple times. 

2. Since we only need the crossing time and the license plate number, we can write a query that only uses the  table.

Let's set conditions where the  and  are both set to the current date. Let's compute the fastest time as being the minimum difference between the  and the .

 

SELECT 
    license_plate
    , MIN(DATEDIFF(exit_time, enter_time)) AS crossing_time
FROM crossings
WHERE DATE(enter_time) = DATE(NOW())
    AND DATE(exit_time) = DATE(NOW())
GROUP BY 1
ORDER BY 2 
LIMIT 1

3.

Let's compute the average fastest car model as the sum of all of the crossings by the specific car models divided by all of the crossings. We don't care about duplicates in this scenario given that total crossings should be the denominator and total crossing time as the numerator.

We can join the two tables together on the `car_model_id` field and then group by the model name. Since we only need the fastest car model we can order by our computation metric, then limit the table size to one.

 

SELECT 
    cm.model_name
    , SUM(DATEDIFF(exit_time, enter_time))/COUNT(*) AS avg_crossing_time
FROM crossing AS c
INNER JOIN car_models AS cm 
    ON c.car_model_id = cm.id
GROUP BY 1
ORDER BY 2 
LIMIT 1

==
`messages` table

column	type
id	integer
date	date
user1	integer
user2	integer
msg_count	integer
 

We have a table that represents the total number of messages sent between two users by date on messenger.

1. What are some insights that could be derived from this table?

2. What do you think the distribution of the number of conversations created by each user per day looks like?

3. Write a query to get the distribution of the number of conversations created by each user by day in the year 2020.

Output:

column	type
num_conversations	integer
frequency	integer

1. Top level insights that can be derived from this table are the total number of messages being sent per day, number of conversations being started, and the average number of messages per conversation.

If we think about business facing metrics, we can start analyzing it by including time series.

How many more conversations are being started over the past year compared to now? Do more conversations between two users indicate a closer friendship versus the depth of the conversation in total messages? 


2. The distribution would be likely skewed to the right or bimodal. If we think about the probability for a user to have a conversation with more than one additional person per day, would that likelihood be going up or down?

The peak is probably around one to five new conversations a day. After that we would see a large decrease with a potential bump of very active users that may be using messenger tools for work.

3. Given we just want to count the number of conversations, we can ignore the message count and focus on getting our key metric of number of new conversations created by day in a single query.

To get this metric, we have to group by the date field and then group by the distinct number of users messaged. Afterward we can then group by the frequency value and get the total count of that as our distribution.

 

SELECT num_conversations, COUNT(*) AS frequency
FROM (
    SELECT user1, DATE(date), COUNT(DISTINCT user2) AS num_conversations
    FROM messages
    WHERE YEAR(date) = '2020'
    GROUP BY 1,2
) AS t
GROUP BY 1

==
`transactions` table

column	type
id	integer
user_id	integer
created_at	datetime
product_id	integer
quantity	integer
`products` table

column	type
id	integer
name	string
price	float
 
Given a table of transactions and products, write a function to get the month over month change in revenue for the year 2019.

Output:

column	type
month	integer
month_over_month	float

WITH monthly_transactions AS (
    SELECT 
        MONTH(created_at) AS month,
        YEAR(created_at) AS year,
        SUM(price) AS revenue
    FROM transactions AS t
    INNER JOIN products AS p
            ON t.product_id = p.id
    WHERE YEAR(created_at) = 2019
    GROUP BY 1,2
    ORDER BY 1
)

SELECT
    month
    , (revenue - previous_revenue)/previous_revenue AS month_over_month
FROM (
SELECT 
    month,
    revenue,
    LAG(revenue,1) OVER (
        ORDER BY month
    ) previous_revenue
    FROM monthly_transactions
) AS t

The second way we can do this if we aren't given the LAG function to use is to do a self-join on the month - 1. 

WITH monthly_transactions AS (
    SELECT 
        MONTH(created_at) AS month,
        YEAR(created_at) AS year,
        SUM(price) AS revenue
    FROM transactions AS t
    INNER JOIN products AS p
            ON t.product_id = p.id
    WHERE YEAR(created_at) = 2019
    GROUP BY 1,2
    ORDER BY 1
)

SELECT
    mt1.month,
    (mt2.revenue - mt1.revenue)/mt1.revenue AS month_over_month
FROM monthly_transactions AS mt1
LEFT JOIN monthly_transactions AS mt2
    ON mt1.month = mt2.month - 1

==
`search_results` table

column	type
query	varchar
result_id	integer
position	integer
rating	integer
 

You're given a table that represents search results from searches on Facebook. The query column is the search term, position column represents each position the search result came in, and the rating column represents the human rating of the search result from 1 to 5 where 5 is high relevance and 1 is low relevance.

1. Write a query to compute a metric to measure the quality of the search results for each query. 

2. You want to be able to compute a metric that measures the precision of the ranking system based on position. For example, if the results for dog and cat are....

 

query	result_id	position	rating	notes
dog	1000	1	2	picture of hotdog
dog	998	2	4	dog walking
dog	342	3	1	zebra
cat	123	1	4	picture of cat
cat	435	2	2	cat memes
cat	545	3	1	pizza shops
 

...we would rank 'cat' as having a better search result ranking precision than 'dog' based on the correct sorting by rating.

Write a query to create a metric that can validate and rank the queries by their search result precision.

Outupt:

column	type
query	varchar
avg_rating	float

1. This is an unusual SQL problem given it asks to define a metric and then write a query to compute it. Generally this should be pretty simple. Can we rank by the metric and figure out which query has the best overall results? 

For example, if the search query for 'tiger' has 5s for each result, then that would be a perfect result. 

The way to compute that metric would be to simply take the average of the rating for all of the results. In which the query can very easily be:

SELECT query, AVG(rating)
FROM search_results
GROUP BY 1
 

2. The precision metric is a little more difficult now that we have to account for a second factor which is position. We now have to find a way to weight the position in accordance to the rating to normalize the metric score. 

This type of problem set can get very complicated if we wanted to dive deeper into it. However the question is clearly more marked towards being practical in figuring out the metric and developing an easy SQL query than developing a search ranking precision scale that optimizes for something like CTR. 

In solving the problem, it's helpful to look at the example to construct an approach towards a metric. For example, if the first result is rated at 5 and the last result is rated at a 1, that's good. Even better however is if the first result is rated 5 and the last result is also rated 5. Bad is if the first result is 1 and the last result is 5. 

However if we use the approach from question number 1, we'll get the same metric score no matter which ways the values are ranked by position. So how do we factor position into the ranking?

What if we took the inverse of the position as our weighted factor? In which case it would be 1/position as a weighted score. Now no matter what the overall rating, we have a way to weight the position into the formula. 

 

SELECT query, AVG((1/position) * rating)
FROM search_results
GROUP BY 1

==
ad_impressions 

column	type
dt	datetime
user_id	integer
campaign_id	integer
impression_id	string
 

campaigns 

column	type
id	integer
start_dt	datetime
end_dt	datetime
goal	integer
 

The schema above represents advertiser campaigns and impressions. The campaigns table specifically has a goal, which is the number that the advertiser wants to reach in total impressions. 

1. Given the table above, generate a daily report that tells us how each campaign delivered during the previous 7 days.

2. Using this data, how do we evaluate how each campaign is delivering and by what heuristic do we surface promos that need attention?

https://www.youtube.com/watch?v=LcVz8wSM-AM&feature=emb_title&ab_channel=DataScienceJay

==
`search_results` table

column	type
query	varchar
result_id	integer
position	integer
rating	integer
 

`search_events` table

column	type
search_id	integer
query	varchar
has_clicked	boolean
 

You're given a table that represents search results from searches on Facebook. The `query` column is the search term, `position` column represents each position the search result came in, and the `rating` column represents the human rating from 1 to 5 where 5 is high relevance and 1 is low relevance.

Each row in the `search_events` table represents a single search with the `has_clicked` column representing if a user clicked on a result or not. We have a hypothesis that the CTR is dependent on the search result rating.

Write a query to return data to support or disprove this hypothesis.

This question requires us to formulaicly do two things: create a metric that can analyze a problem that we face and then actually compute that metric.

Let's think about the data we want to display to prove or disprove the hypothesis. Our output metric is CTR. If CTR is high when search result ratings are high and CTR is low when the search result ratings are low, then our hypothesis is proven. However if the opposite is true, CTR is low when the search result ratings are high, or there is no proven correlation between the two, then our hypothesis is not proven.

With that in mind, why don't we then look at the results split into different search rating buckets. If we measure the CTR for queries that all have results rated at 1, and then measured CTR for queries that have results rated at lower than 2, etc... we can measure to see if the increase in rating is correlated with an increase in CTR.

We can formulate this result by writing a first SQL query for getting the number of results for each query in each bucket. In this case we want to look at the distribution of where the results are less than a certain rating threshold.

WITH ratings AS (
    SELECT query
        , SUM(CASE WHEN 
                rating <= 1 THEN 1 ELSE 0 
            END) AS num_results_rating_one
        , SUM(CASE WHEN 
                rating <= 2 THEN 1 ELSE 0 
            END) AS num_results_rating_two
        , SUM(CASE WHEN 
                rating <= 3 THEN 1 ELSE 0 
            END) AS num_results_rating_three
        , COUNT(*) AS total_results
    FROM search_results
    GROUP BY 1
) 

SELECT * FROM ratings
Looking at the CTE above, we are aggregating to get the number of results that are less than a certain rating threshold. This allows us later on to see the percentage that are within each bucket. If we re-join to the  table, we can calculate the CTR by then grouping by each bucket. 

 

WITH ratings AS (
    SELECT query
        , SUM(CASE WHEN 
                rating <= 1 THEN 1 ELSE 0 
            END) AS num_results_rating_one
        , SUM(CASE WHEN 
                rating <= 2 THEN 1 ELSE 0 
            END) AS num_results_rating_two
        , SUM(CASE WHEN 
                rating <= 3 THEN 1 ELSE 0 
            END) AS num_results_rating_three
        , COUNT(*) AS total_results
    FROM search_results
    GROUP BY 1
) 

SELECT
    CASE 
        WHEN total_results - num_results_rating_one = 0 
            THEN 'results_one'
        WHEN total_results - num_results_rating_two = 0 
            THEN 'results_two'
        WHEN total_results - num_results_rating_three = 0 
            THEN 'results_three'
    END AS ratings_bucket
    , SUM(has_clicked)/COUNT(*) AS ctr
FROM search_events AS se 
LEFT JOIN ratings AS r
    ON se.query = r.query
GROUP BY 1
 

In the CASE WHEN statement, we are calculating each ratings bucket by checking to see if all the search results are less than 1, 2, or 3 by subtracting the total from the number within the bucket and seeing if it equates to 0.

This metric helps us get away from averages within the bucketing system. Averages wouldn't measure the effects of bad ratings as much given how outliers affect them. For example, a query with one result with a 1 rating and another with a 5 rating would equate to an average of 3. Whereas in this system, a query with all of their results under 1 or all of their results under 2, we can determine to be actually bad ratings.

==
`job_postings` table

column	type
id	integer
job_id	integer
user_id	integer
date_posted	datetime
 

Given a table of job postings, write a query to breakdown the number of users that have posted their jobs once versus the number of users that have posted at least one job multiple times.

Output:

column	type
posted_jobs_once	int
posted_at_least_one_job_multiple_times	int

This question is kind of complicated so let's break it down into multiple steps. First let's visualize what the output would look like.

We want the value of two different metrics, the number of users that have posted their jobs once versus the number of users that have posted at least one job multiple times. What does that mean exactly?

Well if a user has 5 jobs but only posted them once, then they are part of the first statement. But if they have a 5 jobs and posted a total of 7 times, that means that they had to at least posted one job multiple times. 

We can visualize it the following way with an example. Let's say this is our end output:

 

Users posted once   | Posted Multiple times
-----------------------------------------
        1           |       1
 

Great, to get to that point, we need a table with the count of user-job pairings and the number of times each job gets posted. 

 

user_id | job_id | number of times posted
-----------------------------------------
  1          1             2
  1          2             1
  2          3             1
 

We can pretty easily get to that point with just a simple GROUP BY on two variables, user_id and job_id. 

 

WITH user_job AS (
    SELECT user_id, job_id, COUNT(DISTINCT date_posted) AS num_posted
    FROM job_postings
    GROUP BY user_id, job_id
)

SELECT * FROM user_job
 

Now we just need a way to differentiate the users that posted each job once from users that posted multiple times. Let's go back to our example. We can deduce that if we take the sum of the number of rows for each user and the sum of the number of times each job is posted, they must be equal for the user to have posted each job only once, since we grouped by the user and the job id.  

We can make this differentiation by looking at the users and the average number of job postings they make, per user-job combo. If it's more than 1, then they've posted one job at least multiple times. If it's equivalent to one, then that satisfies our condition of posting each job only once. 

 

Example:

user_id | avg_num_posted
------------------------
    1   |      1.5
    2   |       1
 

Then, once we have this differentiation, we can now just count the number of users that have greater than one in the avg_num_posted column. 

 

WITH user_job AS (
    SELECT user_id, job_id, COUNT(DISTINCT date_posted) AS num_posted
    FROM job_postings
    GROUP BY user_id, job_id
)

SELECT
    SUM(CASE WHEN avg_num_posted = 1 THEN 1 END) AS posted_jobs_once
    , SUM(CASE WHEN avg_num_posted > 1 THEN 1 END) AS posted_at_least_one_job_multiple_times
FROM (
    SELECT 
        user_id
        , AVG(num_posted) AS avg_num_posted
    FROM user_job
    GROUP BY user_id
) AS t 
 
Second Solution

Given what we then know after solving the problem the first way, we can further optimize the solution by taking the first sub-query and making it into a way in-which we can count the total number of jobs and posts by each user, then seeing if the values are not equal. 

WITH user_job AS (
    SELECT user_id, job_id, COUNT(DISTINCT date_posted) AS num_posted
    FROM job_postings
    GROUP BY user_id, job_id
)

SELECT
        SUM(CASE WHEN n_jobs = n_posts THEN 1 ELSE 0 END) AS posted_jobs_once
        , SUM(CASE WHEN n_jobs != n_posts THEN 1 ELSE 0 END) AS posted_at_least_one_job_multiple_times
FROM (
        SELECT user_id
                   , COUNT(DISTINCT job_id) AS n_jobs
                   , COUNT(DISTINCT id) AS n_posts
        FROM job_postings
        GROUP BY 1
) AS t

==

Let's say we have 1 million app rider journey trips in the city of Seattle. We want to build a model to predict ETA after a rider makes a ride request.

How would we know if we have enough data to create an accurate enough model?

Collecting data can be costly. This question assesses the candidate’s skill in being able to practically figure out how a candidate might approach a problem with evaluating a model.

Specifically, what other kinds of information should we look into when we're given a dataset and build a model with a "pretty good" accuracy rate.

If this is the first version of a model, how would we ever know if we should put any effort into iteration of the model? And exactly how can we evaluate the cost of extra effort into the model?

There are a couple of factors to look into.

1. Look at the feature set size to training data size ratio. If we have an extremely high number of features compared to data points, then the model will be prone to overfitting and inaccuracy.

2. Create an existing model off a portion of the data, the training set, and measure performance of the model on the validation sets, otherwise known as using a holdout set. We hold back some subset of the data from the training of the model, and then use this holdout set to check the model performance to get a baseline level.

This way we can compare some of the existing model evaluation metrics against a baseline of other ETA models in other cities. Or other models that have been deployed at the company. 

3. Learning curves. Learning curves help us calculate our accuracy rate by testing data on subsequently larger subsets of data. If we fit our model on 20%, 40%, 60%, 80% of our data size and then cross-validate to determine model accuracy, we can then determine how much more data we need to achieve a certain accuracy level.

For example. If we reach 75% accuracy with 500K datapoints but then only 77% accuracy with 1 million datapoints, then we’ll realize that our model is not predicting well enough with it’s existing features since doubling the training data size did not significantly increase the accuracy rate. This would inform us that we need to re-evaluate our features rather than collect more data. 

==


