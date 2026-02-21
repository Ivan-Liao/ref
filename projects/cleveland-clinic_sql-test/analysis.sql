 -- 3 total number of encounters
SELECT count(PAT_ENC_CSN_ID) as total_encounters
FROM Encounter
;


 -- 3 the average age and the average LOS for each attending name per year and month.
with avg_los as (
    SELECT AVG(LOS) as avg_los,
        Provider,
        Year,
        Month
    FROM Provider_LOS
    GROUP BY Provider, Year, Month
), encounter_date_parts as (
    SELECT Attending_Name,
        date_part('month', ED_Arrival_Time) as Month, 
        date_part('year', ED_Arrival_Time) as Year,
        Age
    FROM Encounter a
)
SELECT a.Attending_Name,
    AVG(a.age) as avg_age,
    MAX(b.avg_los) as avg_los
FROM encounter_date_parts a
JOIN avg_los b 
    ON b.Provider = a.Attending_Name and b.Year = a.Year and b.Month = b.Year
GROUP BY Attending_Name, a.Month, a.Year
;

-- 4 Create a SQL query that returns arrival codes from the Encounter table not found in the EMS table.
SELECT Distinct Means_Of_Arrival_CD
FROM Encounter
EXCEPT
SELECT Means_Of_Arrival_CD
FROM EMS
;


-- 5 Write an “INSERT” statement to add the missing records to the EMS table
INSERT INTO EMS VALUES 
    (27, 'Ride Share', 1),
    (28, 'Lincoln FD', 1),
    (29, 'Out of Network Ambulance', 1),
    (30, 'Ride Share', 0)


-- 6 Returns the top 5 duos of attending and treatment team members with the most encounter records.
SELECT Attending_Name, 
    Treatment_Team_Name, 
    count(PAT_ENC_CSN_ID) as total_encounters
FROM Encounter
GROUP BY Attending_Name, Treatment_Team_Name
ORDER BY count(PAT_ENC_CSN_ID) desc
LIMIT 5
;

-- 7 row_number() to assign an ordered number to each record based on ED department, attending name and age.
SELECT PAT_ENC_CSN_ID,
    ED_Department,
    Attending_Name,
    Age,
    row_number() over (ORDER BY ED_Department, Attending_Name, Age) as row_num
FROM Encounter
;

