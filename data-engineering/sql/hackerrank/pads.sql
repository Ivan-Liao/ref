select
    CONCAT(Name, ' (',LEFT(Occupation,1),')') as Output
from OCCUPATIONS 
order by Name
union
select
    CONCAT('There are a total of ', count(Occupation), ' ', lower(Occupation)) as Output
from OCCUPATIONS
group by Occupation
order by count(Occupation)