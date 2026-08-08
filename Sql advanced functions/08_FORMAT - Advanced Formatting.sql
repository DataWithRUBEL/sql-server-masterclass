🔷 FORMAT - Advanced Formatting
What it does: Numbers, dates, and values formatted strings  convert 

-- Number formatting
SELECT 
    Price,
    FORMAT(Price, 'C2') AS CurrencyFormat,
    FORMAT(Price, 'N0') AS NumberFormat,
    FORMAT(Price, '0,0.00') AS CustomFormat
FROM Products;

-- Date formatting
SELECT 
    OrderDate,
    FORMAT(OrderDate, 'd') AS ShortDate,
    FORMAT(OrderDate, 'D') AS LongDate,
    FORMAT(OrderDate, 'yyyy-MM-dd') AS ISO8601,
    FORMAT(OrderDate, 'dddd, MMMM dd, yyyy') AS Readable
FROM Orders;

-- Percentage formatting
SELECT 
    ProductName,
    Price,
    FORMAT(Price / (SELECT MAX(Price) FROM Products), 'P2') AS PricePercentageOfMax
FROM Products;

-- Custom business formats
SELECT 
    OrderID,
    TotalAmount,
    FORMAT(TotalAmount, '₹#,##0.00') AS IndianCurrency,
    FORMAT(TotalAmount / 80, '$#,##0.00') AS USDollar,
    FORMAT(CAST(TotalAmount / 100 AS INT), '000000') AS SixDigitCode
FROM Orders;

-- Report generation
SELECT 
    CustomerName,
    FORMAT(SUM(TotalAmount), 'C2') AS TotalSpent,
    FORMAT(COUNT(*), 'N0') AS OrdersPlaced,
    FORMAT(AVG(TotalAmount), 'C2') AS AvgOrderValue
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;










