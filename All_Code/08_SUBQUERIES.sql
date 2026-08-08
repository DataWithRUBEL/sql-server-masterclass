🟢 LEVEL 8: SUBQUERIES


Scalar Subquery (Returns 1 value)
-- Find customers with credit limit above average
SELECT CustomerName, CreditLimit
FROM Customers
WHERE CreditLimit > (SELECT AVG(CreditLimit) FROM Customers);

-- Products more expensive than cheapest product
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products);



Correlated Subquery (References outer query)

-- Orders more expensive than that customer's average
SELECT o.OrderID, c.CustomerName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.TotalAmount > (
    SELECT AVG(Total)
    FROM Orders
    WHERE CustomerID = o.CustomerID
);

-- Customers who bought the most expensive product
SELECT DISTINCT c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    WHERE c.CustomerID = o.CustomerID
    AND od.ProductID = (SELECT ProductID FROM Products WHERE Price = (SELECT MAX(Price) FROM Products))
);



Nested Subquery
-- Categories with more products than average
SELECT Category, COUNT(*) AS ProductCount
FROM Products
WHERE Category IN (
    SELECT Category FROM Products
    GROUP BY Category
    HAVING COUNT(*) > (SELECT AVG(ProductCount) FROM (
        SELECT COUNT(*) AS ProductCount FROM Products GROUP BY Category
    ) AS AvgCount)
)
GROUP BY Category;






