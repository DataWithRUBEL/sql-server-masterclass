1️⃣3️⃣ Subquery Variations - Performance Patterns
Scalar vs Correlated vs Exists

-- 1. Scalar subquery (returns one value)
SELECT 
    ProductName,
    Price,
    (SELECT AVG(Price) FROM Products) AS AvgPrice,
    Price - (SELECT AVG(Price) FROM Products) AS DifferenceFromAvg
FROM Products;

-- 2. Correlated subquery (references outer query)
SELECT 
    c.CustomerName,
    c.CreditLimit,
    (SELECT COUNT(*) FROM Orders WHERE CustomerID = c.CustomerID) AS OrderCount,
    (SELECT MAX(TotalAmount) FROM Orders WHERE CustomerID = c.CustomerID) AS MaxOrder
FROM Customers c;

-- 3. EXISTS (most efficient for large datasets)
SELECT 
    c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID AND o.TotalAmount > 100000
);

-- Performance comparison for same result:
-- Scalar: Runs subquery for EACH row = Slow
-- Correlated: Same issue = Slow
-- EXISTS: Stops at first match = Fast

-- Subquery in FROM clause (inline view)
SELECT 
    HighValueCustomers.CustomerName,
    HighValueCustomers.TotalSpent,
    HighValueCustomers.OrderCount
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(o.TotalAmount) AS TotalSpent,
        COUNT(o.OrderID) AS OrderCount
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
    HAVING SUM(o.TotalAmount) > 50000
) HighValueCustomers
ORDER BY TotalSpent DESC;


















