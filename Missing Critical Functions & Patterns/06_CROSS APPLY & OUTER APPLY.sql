6️⃣ CROSS APPLY & OUTER APPLY - Row-by-Row Processing
CROSS APPLY - Inner Join Effect

-- Get top 2 products for each customer
WITH CustomerProducts AS (
    SELECT DISTINCT 
        c.CustomerID,
        c.CustomerName,
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity) AS QuantityPurchased
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName, p.ProductID, p.ProductName
)
SELECT 
    c.CustomerName,
    ca.ProductName,
    ca.QuantityPurchased
FROM Customers c
CROSS APPLY (
    SELECT TOP 2 ProductName, QuantityPurchased
    FROM CustomerProducts cp
    WHERE cp.CustomerID = c.CustomerID
    ORDER BY QuantityPurchased DESC
) ca;

-- Practical: Latest 3 orders per customer
SELECT 
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
CROSS APPLY (
    SELECT TOP 3 OrderID, OrderDate, TotalAmount
    FROM Orders
    WHERE CustomerID = c.CustomerID
    ORDER BY OrderDate DESC
) o;









OUTER APPLY - Left Join Effect
-- All customers + their latest 2 orders (even if none)
SELECT 
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    ISNULL(o.TotalAmount, 0) AS TotalAmount
FROM Customers c
OUTER APPLY (
    SELECT TOP 2 OrderID, OrderDate, TotalAmount
    FROM Orders
    WHERE CustomerID = c.CustomerID
    ORDER BY OrderDate DESC
) o;

-- Practical: Categories with/without products
SELECT 
    DISTINCT Category,
    p.ProductName,
    p.Price
FROM (SELECT DISTINCT Category FROM Products) Categories
OUTER APPLY (
    SELECT TOP 5 ProductName, Price
    FROM Products
    WHERE Category = Categories.Category
    ORDER BY Price DESC
) p;





