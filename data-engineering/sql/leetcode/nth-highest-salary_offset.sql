CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE M INT;
    
    -- M = N-1 kar diya, kyunki OFFSET hamesha 0-based hota hai
    SET M = N - 1;
  RETURN (
      # Write your MySQL query statement below.
        SELECT DISTINCT Salary
        FROM Employee
        -- Salaries ko descending order me lagaya
        ORDER BY Salary DESC
        -- (N-1) salaries skip karo, phir ek salary uthao
        LIMIT 1 OFFSET M
  );
END