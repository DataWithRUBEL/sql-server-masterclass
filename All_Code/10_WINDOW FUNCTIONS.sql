🟢 LEVEL 10: WINDOW FUNCTIONS


ROW_NUMBER()
-- Rank each customer's orders chronologically
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS OrderSequence
FROM Orders;
-- Output: Customer 1 has order sequence 1, 2, 3...



RANK() / DENSE_RANK()
-- Rank products by price (with gaps vs without gaps)
SELECT 
    ProductName,
    Price,
    RANK() OVER (ORDER BY Price DESC) AS PriceRank,
    DENSE_RANK() OVER (ORDER BY Price DESC) AS DenseRank
FROM Products;
-- RANK: 1, 2, 2, 4 (gaps when ties)
-- DENSE_RANK: 1, 2, 2, 3 (no gaps)





NTILE()
-- Divide customers into 4 quartiles by spending
SELECT 
    CustomerName,
    TotalSpent,
    NTILE(4) OVER (ORDER BY TotalSpent DESC) AS SpendingQuartile
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
) AS CustomerSpending;




LAG() / LEAD()
-- Previous and next order amounts for each customer
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderAmount,
    LEAD(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrderAmount
FROM Orders;





Running Total (SUM with OVER)
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        PARTITION BY YEAR(OrderDate)
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM Orders
ORDER BY OrderDate;





Moving Average
-- 3-order moving average
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    AVG(TotalAmount) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg3Orders
FROM Orders
ORDER BY OrderDate;




FIRST_VALUE() / LAST_VALUE()
-- First and last purchase for each customer
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    FIRST_VALUE(OrderDate) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate
    ) AS FirstPurchaseDate,
    LAST_VALUE(OrderDate) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS LastPurchaseDate
FROM Orders;







