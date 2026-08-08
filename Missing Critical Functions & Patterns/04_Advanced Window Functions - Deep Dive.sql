4️⃣ Advanced Window Functions - Deep Dive
PERCENT_RANK & CUME_DIST - Distribution Functions

-- Percentile ranking (0-1 scale)
SELECT 
    ProductName,
    Price,
    PERCENT_RANK() OVER (ORDER BY Price) AS PercentRank,
    CUME_DIST() OVER (ORDER BY Price) AS CumulativeDistribution,
    NTILE(4) OVER (ORDER BY Price) AS Quartile
FROM Products;

-- Explanation:
-- PERCENT_RANK: (rank - 1) / (rows - 1) → 0 to 1
-- CUME_DIST: rows <= current / total rows → 0 to 1
-- NTILE: Divide into N equal groups

-- Real-world: Customer spending percentiles
SELECT 
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalSpent,
    PERCENT_RANK() OVER (ORDER BY SUM(o.TotalAmount)) AS SpendingPercentile,
    CUME_DIST() OVER (ORDER BY SUM(o.TotalAmount)) AS SpendingCumulativeDist,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(o.TotalAmount)) >= 0.75 THEN 'Top 25%'
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(o.TotalAmount)) >= 0.50 THEN 'Top 50%'
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(o.TotalAmount)) >= 0.25 THEN 'Top 75%'
        ELSE 'Bottom 25%'
    END AS Quartile
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;







PERCENTILE_CONT & PERCENTILE_DISC - Statistical Percentiles
-- Calculate 50th percentile (median) of prices
SELECT 
    Category,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS MedianPrice,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS Q1Price,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS Q3Price,
    AVG(Price) OVER (PARTITION BY Category) AS AvgPrice
FROM Products
GROUP BY Category, Price;

-- PERCENTILE_DISC: Discrete value (actual row)
-- PERCENTILE_CONT: Interpolated value (between rows)

-- Statistical outlier detection
WITH PriceStats AS (
    SELECT 
        Category,
        Price,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER (PARTITION BY Category) AS Q3
    FROM Products
)
SELECT 
    Category,
    Price,
    Q1,
    Q3,
    Q3 - Q1 AS IQR,
    CASE 
        WHEN Price < Q1 - 1.5 * (Q3 - Q1) THEN 'Lower Outlier'
        WHEN Price > Q3 + 1.5 * (Q3 - Q1) THEN 'Upper Outlier'
        ELSE 'Normal'
    END AS OutlierStatus
FROM PriceStats;








ROWS vs RANGE Clauses - Advanced Window Specifications
-- Running total with ROWS (count-based)
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal_ROWS,
    -- Moving average (3-row window)
    AVG(TotalAmount) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg_3Rows
FROM Orders
ORDER BY OrderDate;

-- Running total with RANGE (value-based) - useful for same dates
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (
        ORDER BY OrderDate
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal_RANGE
FROM Orders
ORDER BY OrderDate;

-- Difference:
-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW = Last 3 rows exactly
-- RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW = All rows within 2 days








LAG & LEAD with Advanced Features
-- Compare with multiple previous/next values
SELECT 
    OrderDate,
    TotalAmount,
    LAG(TotalAmount, 1) OVER (ORDER BY OrderDate) AS PreviousOrder,
    LAG(TotalAmount, 2) OVER (ORDER BY OrderDate) AS TwoOrdersAgo,
    LEAD(TotalAmount, 1) OVER (ORDER BY OrderDate) AS NextOrder,
    TotalAmount - LAG(TotalAmount, 1) OVER (ORDER BY OrderDate) AS AmountChange,
    CASE 
        WHEN TotalAmount > LAG(TotalAmount, 1) OVER (ORDER BY OrderDate) THEN 'Increase'
        WHEN TotalAmount < LAG(TotalAmount, 1) OVER (ORDER BY OrderDate) THEN 'Decrease'
        ELSE 'Same'
    END AS Trend
FROM Orders;

-- Default value for LAG/LEAD (when NULL)
SELECT 
    OrderID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount, 1, 0) OVER (ORDER BY OrderDate) AS PreviousOrder, -- 0 if NULL
    LEAD(TotalAmount, 1, 0) OVER (ORDER BY OrderDate) AS NextOrder    -- 0 if NULL
FROM Orders;

-- Customer purchase gaps (days between orders)
SELECT 
    CustomerID,
    OrderDate,
    DATEDIFF(DAY, LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) AS DaysSinceLast
FROM Orders
ORDER BY CustomerID, OrderDate;








FIRST_VALUE & LAST_VALUE with Proper Frame
-- Customer first and last purchase
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalAmount,
    FIRST_VALUE(OrderDate) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS FirstPurchaseDate,
    LAST_VALUE(OrderDate) OVER (
        PARTITION BY CustomerID 
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS LastPurchaseDate,
    DATEDIFF(DAY, 
        FIRST_VALUE(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
        LAST_VALUE(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
    ) AS CustomerLifespanDays
FROM Orders
ORDER BY CustomerID, OrderDate;

-- Maximum amount in customer's order history
SELECT 
    CustomerID,
    OrderID,
    TotalAmount,
    MAX(TotalAmount) OVER (PARTITION BY CustomerID) AS MaxOrderAmount,
    MIN(TotalAmount) OVER (PARTITION BY CustomerID) AS MinOrderAmount,
    TotalAmount - MIN(TotalAmount) OVER (PARTITION BY CustomerID) AS AmountAboveMin
FROM Orders
ORDER BY CustomerID;











