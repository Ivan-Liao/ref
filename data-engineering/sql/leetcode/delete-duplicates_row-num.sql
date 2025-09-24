-- mysql syntax
with duplicates as (
    select id, 
        row_number() over (partition by email order by id) as row_num
    from Person
)
delete p from Person p, duplicates d
where
    p.id = d.id and d.row_num > 1