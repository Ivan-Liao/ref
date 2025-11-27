-- Sample Data
CREATE TABLE SalesData (
    Region VARCHAR(50),
    Product VARCHAR(50),
    SalesAmount DECIMAL(10, 2)
);

INSERT INTO SalesData (Region, Product, SalesAmount) VALUES
('East', 'Laptop', 1200.00),
('West', 'Laptop', 1500.00),
('East', 'Mouse', 50.00),
('West', 'Mouse', 75.00),
('East', 'Keyboard', 100.00),
('West', 'Keyboard', 120.00);


SELECT Product, East, West
FROM (
    SELECT Region, Product, SalesAmount
    FROM SalesData
) AS SourceTable
PIVOT (
    SUM(SalesAmount)
    FOR Region IN ([East], [West])
) AS PivotTable;