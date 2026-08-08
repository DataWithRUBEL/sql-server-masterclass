🟢 LEVEL 11: VIEWS


-- CREATE VIEW: Reusable query
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    COUNT(o.OrderID) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AvgOrderValue
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Country;

-- Use the view (just like a table)
SELECT * FROM vw_CustomerOrderSummary WHERE TotalSpent > 50000;

-- ALTER VIEW: Modify existing view
ALTER VIEW vw_CustomerOrderSummary AS
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    COUNT(o.OrderID) AS OrderCount,
    SUM(o.TotalAmount) AS TotalSpent,
    AVG(o.TotalAmount) AS AvgOrderValue,
    MAX(o.OrderDate) AS LastOrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Country;

-- DROP VIEW: Delete view
DROP VIEW vw_CustomerOrderSummary;

-- Complex view with joins
CREATE VIEW vw_OrderDetails_Full AS
SELECT 
    o.OrderID,
    c.CustomerName,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS LineTotal,
    o.OrderDate,
    o.OrderStatus
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;











