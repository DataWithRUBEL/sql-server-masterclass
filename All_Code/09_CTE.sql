🟢 LEVEL 9: COMMON TABLE EXPRESSIONS (CTE)
Basic CTE

WITH CustomerOrders AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS OrderCount,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT * FROM CustomerOrders
WHERE TotalSpent > 25000
ORDER BY TotalSpent DESC;



Multiple CTEs
WITH CustomerStats AS (
    SELECT 
        CustomerID,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS TotalSpent
    FROM Orders
    GROUP BY CustomerID
),
ProductStats AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        COUNT(od.OrderDetailID) AS TimesSold,
        SUM(od.Quantity) AS QuantitySold
    FROM Products p
    LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT 
    cs.CustomerID,
    cs.OrderCount,
    cs.TotalSpent,
    ps.ProductName,
    ps.TimesSold
FROM CustomerStats cs
CROSS JOIN ProductStats ps
WHERE cs.TotalSpent > 50000 AND ps.TimesSold > 2;




Recursive CTE (Hierarchical data)
-- Generate numbers 1 to 10
WITH NumberSequence AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumberSequence
    WHERE Number < 10
)
SELECT * FROM NumberSequence;

-- Practical: Generate date range
WITH DateRange AS (
    SELECT CAST('2024-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateRange
    WHERE DateValue < CAST('2024-01-31' AS DATE)
)
SELECT DateValue FROM DateRange;





















