7️⃣ EXISTS vs IN - Query Optimization
EXISTS (Recommended for Large Data)

-- Find customers who have placed orders
-- Method 1: EXISTS (More efficient)
SELECT CustomerName, Email
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders WHERE CustomerID = c.CustomerID
);

-- Method 2: IN (Can be slower with large subquery)
SELECT CustomerName, Email
FROM Customers
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM Orders);

-- Execution comparison:
-- EXISTS: Stops as soon as 1 row found = Efficient
-- IN: Builds entire list first = Memory intensive

-- Real-world: Find products that haven't been ordered
SELECT ProductName, Price
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM OrderDetails od WHERE od.ProductID = p.ProductID
);

-- With performance difference shown
SELECT ProductName, Price,
    CASE 
        WHEN EXISTS (SELECT 1 FROM OrderDetails od WHERE od.ProductID = p.ProductID)
        THEN 'Ordered'
        ELSE 'Never Ordered'
    END AS OrderStatus
FROM Products p;









Multiple EXISTS Conditions
-- Complex filtering with multiple EXISTS
SELECT 
    c.CustomerName,
    c.Country,
    CASE 
        WHEN EXISTS (SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID)
        THEN 'Has Orders'
        ELSE 'No Orders'
    END AS OrderStatus,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM Orders o 
            WHERE o.CustomerID = c.CustomerID AND o.TotalAmount > 100000
        )
        THEN 'High-Value Customer'
        ELSE 'Regular'
    END AS Segment
FROM Customers c
ORDER BY OrderStatus;

