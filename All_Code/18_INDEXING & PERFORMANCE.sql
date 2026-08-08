🟢 LEVEL 18: INDEXING & PERFORMANCE

Clustered Index
-- Primary key is clustered index by default
-- Data physically sorted by this column
CREATE CLUSTERED INDEX IX_Customers_CustomerID ON Customers(CustomerID);

-- View existing indexes
EXEC sp_helpindex 'Customers';




Nonclustered Index
-- Speed up searches
CREATE NONCLUSTERED INDEX IX_Products_Category ON Products(Category);

-- Composite index (multiple columns)
CREATE NONCLUSTERED INDEX IX_Orders_CustomerDate 
ON Orders(CustomerID, OrderDate);

-- Covering index (include extra columns)
CREATE NONCLUSTERED INDEX IX_Orders_Full
ON Orders(CustomerID, OrderDate)
INCLUDE (TotalAmount, OrderStatus);





Execution Plan
-- Enable execution plan (CTRL+L in SSMS)
SELECT c.CustomerName, COUNT(o.OrderID) as OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;
-- Check if using index or table scan



Query Optimization
-- BAD: Function in WHERE clause (doesn't use index)
SELECT * FROM Orders WHERE YEAR(OrderDate) = 2024;

-- GOOD: Date range (uses index)
SELECT * FROM Orders 
WHERE OrderDate >= '2024-01-01' AND OrderDate < '2025-01-01';

-- BAD: Calculation in WHERE
SELECT * FROM Products WHERE Price * 1.1 > 50000;

-- GOOD: Direct comparison
SELECT * FROM Products WHERE Price > (50000 / 1.1);






SARGable Queries
-- NOT SARGable (Can't use index)
SELECT * FROM Products WHERE SUBSTRING(ProductName, 1, 5) = 'Lapto';

-- SARGable (Can use index)
SELECT * FROM Products WHERE ProductName LIKE 'Lapto%';
















