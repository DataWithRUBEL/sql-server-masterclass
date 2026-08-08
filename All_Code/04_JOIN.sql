🟢 LEVEL 4: JOIN


✅ No JOIN
SELECT *
FROM Customers;

SELECT *
FROM Orders;



✅ INNER JOIN
What it does: Both tables এ matching records থেকে data return করে

-- Customers + Orders (শুধু যারা order করেছে)
SELECT 
  c.CustomerName, 
  o.OrderID, 
  o.OrderDate, 
  o.TotalAmount
FROM Customers c
INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID;

-- Orders + OrderDetails + Products (complete order info)
SELECT 
    o.OrderID,
    od.OrderDetailID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS LineTotal
FROM Orders o
INNER JOIN OrderDetails od 
ON o.OrderID = od.OrderID
INNER JOIN Products p 
ON od.ProductID = p.ProductID;


✅ LEFT JOIN
What it does: Left table থেকে সব rows, right table থেকে matching rows
-- All customers, + orders (যদি order থাকে)
SELECT 
  c.CustomerName, 
  o.OrderID, 
  o.OrderDate
FROM Customers c
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;

-- Use case: Find customers who haven't placed orders
SELECT 
  c.CustomerName, 
  o.OrderID
FROM Customers c
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL; -- These customers have NO orders


✅ RIGHT JOIN
What it does: Right table থেকে সব rows, left table থেকে matching rows
-- All products, + order details (যদি ordered হয়)
SELECT 
  p.ProductName, 
  od.OrderDetailID, 
  od.Quantity
FROM Orders o
RIGHT JOIN Products p 
ON o.OrderID = p.ProductID
ORDER BY p.ProductName;



✅ FULL JOIN
SELECT 
  c.CustomerID,
  c.CustomerName,
  o.OrderID,
  o.CustomerID,
  o.TotalAmount
FROM Customers AS c
FULL JOIN Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL
OR c.CustomerID IS NULL;




✅ FULL OUTER JOIN
What it does: উভয় table থেকে সব rows (matching + non-matching)
SELECT 
  c.CustomerName, 
  o.OrderID, 
  o.OrderDate
FROM Customers c
FULL OUTER JOIN Orders o 
ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;




✅ CROSS JOIN
What it does: Create করে cartesian product (সব possible combinations)
-- Nornaml cross join
SELECT  *
FROM Customers
CROSS JOIN Orders;


  
-- সব customers × সব products (100 combinations)
SELECT 
  c.CustomerName, 
  p.ProductName
FROM Customers c
CROSS JOIN Products p;

-- Practical: Generate price quote for all customer-product pairs
SELECT 
    c.CustomerName,
    p.ProductName,
    p.Price,
    CASE 
        WHEN c.CreditLimit >= p.Price THEN 'Can Afford'
        ELSE 'Need Financing'
    END AS PurchasingPower
FROM Customers c
CROSS JOIN Products p
WHERE p.Category = 'Electronics';


✅ SELF JOIN
What it does: Table নিজের সাথে join করে
-- Find products of same category
SELECT 
    p1.ProductName AS Product1,
    p2.ProductName AS Product2,
    p1.Category
FROM Products p1
INNER JOIN Products p2 
    ON p1.Category = p2.Category 
    AND p1.ProductID < p2.ProductID;

-- Result: Groups similar category products together






🟢 Multiple Table Join

1️⃣ BASIC 4-TABLE INNER JOIN - All Tables Connected
Simple Sequential JOIN
-- Get complete order information (Customer + Order + Details + Product)
SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS LineTotal,
    o.TotalAmount,
    o.OrderStatus
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
ORDER BY c.CustomerID, o.OrderDate, p.ProductName;


       -- JOIN Path Diagram
Customers (1) ──INNER JOIN── Orders (Many)
                                   ↓
                        INNER JOIN OrderDetails (Many)
                                   ↓
                        INNER JOIN Products (Many)




2️⃣ MIXED JOIN TYPES - Combinations
-- LEFT JOIN with Multiple INNER JOINs
Goal: Show ALL customers (even without orders) + their complete order information
  
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    (od.Quantity * od.UnitPrice) AS LineAmount
FROM Customers c                          -- Include ALL customers
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID  -- Optional orders
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID  -- Required details
INNER JOIN Products p ON od.ProductID = p.ProductID   -- Required products
ORDER BY c.CustomerID, o.OrderDate;



-- CORRECT LEFT JOIN Approach (Avoid NULL Elimination)
-- Get ALL customers + orders (if any) + products (if ordered)
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    COUNT(DISTINCT od.OrderDetailID) AS ItemCount,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country
ORDER BY TotalSpent DESC NULLS LAST;



-- RIGHT JOIN Example (Rare, but Useful)

-- Show ALL products (even if never ordered)
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    COUNT(od.OrderDetailID) AS TimesSold,
    SUM(od.Quantity) AS TotalQuantitySold,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    o.OrderDate
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
RIGHT JOIN Products p ON od.ProductID = p.ProductID
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY p.ProductID, p.ProductName, p.Category, p.Price, o.OrderDate
ORDER BY TotalRevenue DESC NULLS LAST;

-- Shows products with their sales data (NULL if never ordered)





-- FULL OUTER JOIN - Both Sides of Unmatched Data
-- Find customers OR products that have no related records
SELECT 
    c.CustomerID,
    c.CustomerName,
    p.ProductID,
    p.ProductName,
    CASE 
        WHEN c.CustomerID IS NOT NULL AND p.ProductID IS NULL THEN 'Customer with no product match'
        WHEN c.CustomerID IS NULL AND p.ProductID IS NOT NULL THEN 'Product with no customer'
        ELSE 'Both matched'
    END AS JoinType
FROM Customers c
FULL OUTER JOIN (
    SELECT DISTINCT c.CustomerID, p.ProductID, p.ProductName
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
) orders_products ON c.CustomerID = orders_products.CustomerID
FULL OUTER JOIN Products p ON orders_products.ProductID = p.ProductID;



3️⃣ 4-TABLE JOIN WITH AGGREGATION
Revenue Analysis (4 Tables)
-- Sales metrics per customer, country, and category
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    p.Category,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    COUNT(od.OrderDetailID) AS LineItemsCount,
    SUM(od.Quantity) AS TotalQuantity,
    SUM(od.Quantity * od.UnitPrice) AS CategoryRevenue,
    AVG(od.UnitPrice) AS AvgPrice,
    MAX(od.UnitPrice) AS MaxPrice,
    MIN(od.UnitPrice) AS MinPrice
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country, p.Category
HAVING COUNT(DISTINCT o.OrderID) > 0
ORDER BY c.CustomerID, CategoryRevenue DESC;




-- Customer Purchase Analysis
-- RFM Analysis: Recency, Frequency, Monetary
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    -- Recency: Days since last purchase
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder,
    -- Frequency: Number of orders
    COUNT(DISTINCT o.OrderID) AS OrderFrequency,
    -- Monetary: Total spending
    SUM(od.Quantity * od.UnitPrice) AS TotalMonetary,
    AVG(o.TotalAmount) AS AvgOrderValue,
    -- RFM Segmentation
    CASE 
        WHEN DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) <= 30 
         AND COUNT(DISTINCT o.OrderID) >= 3
         AND SUM(od.Quantity * od.UnitPrice) > 50000
        THEN 'Champion'
        WHEN DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) <= 60 
         AND COUNT(DISTINCT o.OrderID) >= 2
        THEN 'Loyal'
        WHEN DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) > 90
        THEN 'At Risk'
        ELSE 'Regular'
    END AS CustomerSegment
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderID IS NOT NULL
GROUP BY c.CustomerID, c.CustomerName, c.Country
ORDER BY TotalMonetary DESC;




4️⃣ WINDOW FUNCTIONS WITH 4-TABLE JOIN
Ranking with Multiple Tables
-- Rank customers by spending within each country and category
SELECT 
    c.Country,
    p.Category,
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS CategorySpent,
    RANK() OVER (PARTITION BY c.Country, p.Category ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS RankInCategory,
    ROW_NUMBER() OVER (PARTITION BY c.Country, p.Category ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS RowNum,
    DENSE_RANK() OVER (PARTITION BY c.Country ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS CountryRank
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country, p.Category
ORDER BY c.Country, p.Category, RankInCategory;

-- Get top 2 customers per category
WITH RankedCustomers AS (
    SELECT 
        c.CustomerName,
        p.Category,
        SUM(od.Quantity * od.UnitPrice) AS CategorySpent,
        RANK() OVER (PARTITION BY p.Category ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS CategoryRank
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName, p.Category
)
SELECT * FROM RankedCustomers
WHERE CategoryRank <= 2
ORDER BY Category, CategoryRank;






-- Running Total with 4 Tables
-- Monthly sales running total
SELECT 
    DATEPART(YEAR, o.OrderDate) AS Year,
    DATEPART(MONTH, o.OrderDate) AS Month,
    DATENAME(MONTH, o.OrderDate) AS MonthName,
    SUM(od.Quantity * od.UnitPrice) AS MonthlySales,
    SUM(SUM(od.Quantity * od.UnitPrice)) OVER (
        PARTITION BY DATEPART(YEAR, o.OrderDate)
        ORDER BY DATEPART(MONTH, o.OrderDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS YTDRunningTotal,
    LAG(SUM(od.Quantity * od.UnitPrice)) OVER (ORDER BY DATEPART(YEAR, o.OrderDate), DATEPART(MONTH, o.OrderDate)) AS PreviousMonthSales,
    SUM(od.Quantity * od.UnitPrice) - LAG(SUM(od.Quantity * od.UnitPrice)) OVER (ORDER BY DATEPART(YEAR, o.OrderDate), DATEPART(MONTH, o.OrderDate)) AS MoMChange
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY DATEPART(YEAR, o.OrderDate), DATEPART(MONTH, o.OrderDate), DATENAME(MONTH, o.OrderDate)
ORDER BY Year, Month;





5️⃣ CTE WITH 4-TABLE JOIN
Chained CTEs for Clarity
-- Multi-level CTE structure
WITH OrderSummary AS (
    -- CTE 1: Get order details
    SELECT 
        o.OrderID,
        c.CustomerID,
        c.CustomerName,
        o.OrderDate,
        od.ProductID,
        od.Quantity,
        od.UnitPrice,
        (od.Quantity * od.UnitPrice) AS LineAmount
    FROM Orders o
    INNER JOIN Customers c ON o.CustomerID = c.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
),
CustomerSummary AS (
    -- CTE 2: Aggregate by customer
    SELECT 
        CustomerID,
        CustomerName,
        COUNT(DISTINCT OrderID) AS OrderCount,
        SUM(LineAmount) AS TotalSpent,
        AVG(LineAmount) AS AvgLineValue,
        MAX(LineAmount) AS MaxLine
    FROM OrderSummary
    GROUP BY CustomerID, CustomerName
),
CustomerRanking AS (
    -- CTE 3: Rank customers
    SELECT 
        *,
        RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank,
        NTILE(4) OVER (ORDER BY TotalSpent DESC) AS SpendingQuartile
    FROM CustomerSummary
)
SELECT * FROM CustomerRanking
WHERE SpendingRank <= 5;




-- Recursive CTE with JOINs (Advanced)
-- Build customer-product purchase history hierarchy
WITH RecursiveOrders AS (
    -- Anchor: First order
    SELECT 
        c.CustomerID,
        c.CustomerName,
        1 AS OrderSequence,
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        od.Quantity,
        CAST(o.OrderDate AS NVARCHAR(MAX)) AS OrderChain
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) = 1
    
    UNION ALL
    
    -- Recursive: Next orders
    SELECT 
        c.CustomerID,
        c.CustomerName,
        ro.OrderSequence + 1,
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        od.Quantity,
        ro.OrderChain + ' -> ' + CAST(o.OrderDate AS NVARCHAR(10))
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    INNER JOIN RecursiveOrders ro ON c.CustomerID = ro.CustomerID 
        AND o.OrderDate > ro.OrderDate
    WHERE ro.OrderSequence < 3 -- Limit recursion
)
SELECT * FROM RecursiveOrders
ORDER BY CustomerID, OrderSequence;

-- Result shows first 3 orders per customer in sequence





6️⃣ PIVOT WITH 4-TABLE JOIN
Reshape 4-Table Data
-- Sales pivot: Countries × Categories
SELECT 
    c.Country,
    [Electronics] AS Electronics_Sales,
    [Accessories] AS Accessories_Sales,
    [Clearance] AS Clearance_Sales,
    ([Electronics] + ISNULL([Accessories], 0) + ISNULL([Clearance], 0)) AS TotalSales
FROM (
    SELECT 
        c.Country,
        p.Category,
        SUM(od.Quantity * od.UnitPrice) AS Sales
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.Country, p.Category
) SourceData
PIVOT (
    SUM(Sales)
    FOR Category IN ([Electronics], [Accessories], [Clearance])
) PivotTable
ORDER BY TotalSales DESC;

-- Customer × Month pivot
SELECT 
    CustomerName,
    [Jan-2024] AS Jan2024,
    [Feb-2024] AS Feb2024,
    [Mar-2024] AS Mar2024,
    ISNULL([Jan-2024], 0) + ISNULL([Feb-2024], 0) + ISNULL([Mar-2024], 0) AS Q1Total
FROM (
    SELECT 
        c.CustomerName,
        FORMAT(o.OrderDate, 'MMM-yyyy') AS Month,
        SUM(od.Quantity * od.UnitPrice) AS MonthlySales
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.CustomerName, FORMAT(o.OrderDate, 'MMM-yyyy')
) SourceData
PIVOT (
    SUM(MonthlySales)
    FOR Month IN ([Jan-2024], [Feb-2024], [Mar-2024])
) PivotTable;




7️⃣ CROSS APPLY WITH 4-TABLE JOIN
Top N per Group
-- Top 3 products per customer
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    TopProducts.ProductName,
    TopProducts.QuantityPurchased,
    TopProducts.Revenue
FROM Customers c
CROSS APPLY (
    SELECT TOP 3 
        p.ProductName,
        SUM(od.Quantity) AS QuantityPurchased,
        SUM(od.Quantity * od.UnitPrice) AS Revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS Rank
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE o.CustomerID = c.CustomerID
    GROUP BY p.ProductID, p.ProductName
    ORDER BY Revenue DESC
) TopProducts
ORDER BY c.CustomerID, TopProducts.Rank;

-- Latest 2 orders per customer with product details
SELECT 
    c.CustomerName,
    RecentOrders.OrderID,
    RecentOrders.OrderDate,
    RecentOrders.ProductName,
    RecentOrders.Quantity,
    RecentOrders.LineAmount
FROM Customers c
CROSS APPLY (
    SELECT TOP 2 
        o.OrderID,
        o.OrderDate,
        p.ProductName,
        od.Quantity,
        (od.Quantity * od.UnitPrice) AS LineAmount,
        ROW_NUMBER() OVER (ORDER BY o.OrderDate DESC) AS OrderSeq
    FROM Orders o
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    WHERE o.CustomerID = c.CustomerID
    ORDER BY o.OrderDate DESC
) RecentOrders
ORDER BY c.CustomerName, RecentOrders.OrderSeq;






8️⃣ SUBQUERY WITH 4-TABLE JOIN
Correlated Subqueries
-- Find customers who spent above their country average
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    SUM(od.Quantity * od.UnitPrice) AS CustomerTotal,
    (
        SELECT AVG(CountryTotal)
        FROM (
            SELECT SUM(od2.Quantity * od2.UnitPrice) AS CountryTotal
            FROM Customers c2
            INNER JOIN Orders o2 ON c2.CustomerID = o2.CustomerID
            INNER JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID
            INNER JOIN Products p2 ON od2.ProductID = p2.ProductID
            WHERE c2.Country = c.Country
            GROUP BY c2.CustomerID
        ) CountryAvgs
    ) AS CountryAverage,
    CASE 
        WHEN SUM(od.Quantity * od.UnitPrice) > (
            SELECT AVG(CountryTotal)
            FROM (
                SELECT SUM(od2.Quantity * od2.UnitPrice) AS CountryTotal
                FROM Customers c2
                INNER JOIN Orders o2 ON c2.CustomerID = o2.CustomerID
                INNER JOIN OrderDetails od2 ON o2.OrderID = od2.OrderID
                INNER JOIN Products p2 ON od2.ProductID = p2.ProductID
                WHERE c2.Country = c.Country
                GROUP BY c2.CustomerID
            ) CountryAvgs
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END AS Performance
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country
ORDER BY c.Country, CustomerTotal DESC;

-- Better: Use CTE instead (cleaner)
WITH CountryStats AS (
    SELECT 
        c.Country,
        SUM(od.Quantity * od.UnitPrice) AS CountryTotal
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.Country
)
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    SUM(od.Quantity * od.UnitPrice) AS CustomerTotal,
    CAST(SUM(od.Quantity * od.UnitPrice) AS DECIMAL) / (SELECT COUNT(DISTINCT CustomerID) FROM Customers WHERE Country = c.Country) AS AvgPerCustomer
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country
ORDER BY c.Country, CustomerTotal DESC;






9️⃣ JOIN OPTIMIZATION - Performance Tuning
Good vs Bad JOIN Patterns
❌ BAD: Too Many Joins + Functions in WHERE
-- SLOW: 4 tables, but functions prevent index usage
SELECT c.CustomerName, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 2024              -- Function = no index
  AND CONVERT(INT, p.Price) > 50000         -- Type conversion = no index
  AND LEN(c.CustomerName) > 5;              -- Function = no index



✅ GOOD: Optimized JOIN + SARGable WHERE

-- FAST: Same logic, index-friendly
SELECT c.CustomerName, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >= '2024-01-01'          -- No function
  AND o.OrderDate < '2025-01-01'
  AND p.Price > 50000                       -- Direct comparison
  AND LEN(c.CustomerName) > 5;              -- Unavoidable function





Index Strategy for 4-Table Joins
-- Critical indexes for our joins

-- Foreign key indexes (usually auto-created)
CREATE CLUSTERED INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE CLUSTERED INDEX IX_OrderDetails_OrderID ON OrderDetails(OrderID);

-- Non-clustered indexes for common queries
CREATE NONCLUSTERED INDEX IX_Orders_Date ON Orders(OrderDate) INCLUDE (CustomerID, TotalAmount);
CREATE NONCLUSTERED INDEX IX_Products_Category ON Products(Category) INCLUDE (ProductID, Price);

-- Composite indexes for specific joins
CREATE NONCLUSTERED INDEX IX_OrderDetails_Composite 
ON OrderDetails(OrderID, ProductID) INCLUDE (Quantity, UnitPrice);

-- Verify indexes are being used
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT c.CustomerName, COUNT(*) AS OrderCount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;

-- Check execution plan for Index Seek (good) vs Index Scan (less ideal)






JOIN Order Matters
-- Execution plan considers join order
-- SQL Server optimizer typically does this automatically,
-- but understanding helps with complex queries

-- Option 1: Start with smallest filtered result set
SELECT c.CustomerName, p.ProductName, od.Quantity
FROM Products p
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE p.Category = 'Electronics';  -- Filter early

-- Option 2: Multiple conditions
SELECT c.CustomerName, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
WHERE c.Country = 'India'
  AND p.Category = 'Electronics'
  AND o.OrderDate >= '2024-01-01';






🔟 REAL-WORLD SCENARIOS
Scenario 1: Customer Analytics Dashboard
-- Multi-metric customer view
SELECT 
    c.CustomerID,
    c.CustomerName,
    c.Country,
    c.RegistrationDate,
    c.CreditLimit,
    -- Order metrics
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    MAX(o.OrderDate) AS LastOrderDate,
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder,
    -- Purchase metrics
    COUNT(DISTINCT od.OrderDetailID) AS TotalLineItems,
    COUNT(DISTINCT p.ProductID) AS UniqueProductsPurchased,
    COUNT(DISTINCT p.Category) AS CategoriesExplored,
    -- Financial metrics
    SUM(od.Quantity * od.UnitPrice) AS LifetimeValue,
    AVG(o.TotalAmount) AS AvgOrderValue,
    CAST(SUM(od.Quantity * od.UnitPrice) / NULLIF(COUNT(DISTINCT o.OrderID), 0) AS DECIMAL(10,2)) AS ValuePerOrder,
    MIN(od.UnitPrice) AS MinPricePurchased,
    MAX(od.UnitPrice) AS MaxPricePurchased,
    -- Product preferences
    STRING_AGG(DISTINCT p.Category, ', ') AS PreferredCategories,
    -- Status
    CASE 
        WHEN COUNT(DISTINCT o.OrderID) = 0 THEN 'Never Ordered'
        WHEN DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) > 180 THEN 'Inactive'
        WHEN DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) > 90 THEN 'At Risk'
        WHEN COUNT(DISTINCT o.OrderID) >= 5 AND SUM(od.Quantity * od.UnitPrice) > 50000 THEN 'VIP'
        ELSE 'Active'
    END AS CustomerStatus
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.Country, c.RegistrationDate, c.CreditLimit
ORDER BY LifetimeValue DESC NULLS LAST;






Scenario 2: Sales Performance Report
-- Detailed sales breakdown
SELECT 
    DATEPART(YEAR, o.OrderDate) AS Year,
    DATEPART(QUARTER, o.OrderDate) AS Quarter,
    DATEPART(MONTH, o.OrderDate) AS Month,
    DATENAME(MONTH, o.OrderDate) AS MonthName,
    c.Country,
    p.Category,
    p.ProductName,
    COUNT(DISTINCT o.OrderID) AS OrdersCount,
    SUM(od.Quantity) AS UnitsSOld,
    SUM(od.Quantity * od.UnitPrice) AS Revenue,
    CAST(SUM(od.Quantity * od.UnitPrice) / NULLIF(SUM(od.Quantity), 0) AS DECIMAL(10,2)) AS AvgUnitPrice,
    CAST(SUM(od.Quantity * od.UnitPrice) / NULLIF(COUNT(DISTINCT o.OrderID), 0) AS DECIMAL(10,2)) AS RevenuePerOrder,
    COUNT(DISTINCT c.CustomerID) AS UniqueCustomers,
    -- Year-over-year comparison
    CAST(100.0 * (SUM(od.Quantity * od.UnitPrice) - LAG(SUM(od.Quantity * od.UnitPrice)) 
        OVER (PARTITION BY p.ProductID, DATEPART(MONTH, o.OrderDate) ORDER BY DATEPART(YEAR, o.OrderDate))) 
        / NULLIF(LAG(SUM(od.Quantity * od.UnitPrice)) 
        OVER (PARTITION BY p.ProductID, DATEPART(MONTH, o.OrderDate) ORDER BY DATEPART(YEAR, o.OrderDate)), 0) AS DECIMAL(5,2)) AS YoYGrowth
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY DATEPART(YEAR, o.OrderDate), DATEPART(QUARTER, o.OrderDate), DATEPART(MONTH, o.OrderDate), 
         DATENAME(MONTH, o.OrderDate), c.Country, p.Category, p.ProductID, p.ProductName
ORDER BY Year DESC, Quarter DESC, Month DESC, Revenue DESC;





Scenario 3: Product Performance Analysis
-- Product-level deep dive
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    p.Price,
    p.Stock,
    -- Sales metrics
    COUNT(DISTINCT o.OrderID) AS OrdersIncluding,
    COUNT(DISTINCT c.CustomerID) AS UniqueCustomersPurchased,
    SUM(od.Quantity) AS TotalQuantitySOld,
    CAST(AVG(od.Quantity) AS DECIMAL(5,2)) AS AvgQuantityPerOrder,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    -- Customer segmentation
    COUNT(DISTINCT CASE WHEN c.Country = 'India' THEN c.CustomerID END) AS IndiaCustomers,
    COUNT(DISTINCT CASE WHEN c.Country = 'Bangladesh' THEN c.CustomerID END) AS BangladeshCustomers,
    COUNT(DISTINCT CASE WHEN c.Country = 'Pakistan' THEN c.CustomerID END) AS PakistanCustomers,
    -- Stock health
    CAST(p.Stock AS DECIMAL) / NULLIF(SUM(od.Quantity), 0) AS MonthsOfInventory,
    CASE 
        WHEN p.Stock = 0 THEN 'Out of Stock'
        WHEN p.Stock < 50 THEN 'Critical'
        WHEN p.Stock < 100 THEN 'Low'
        WHEN p.Stock < 200 THEN 'Medium'
        ELSE 'High'
    END AS StockStatus,
    -- Profitability (assuming cost = price * 0.6)
    SUM(od.Quantity * (od.UnitPrice - (od.UnitPrice * 0.4))) AS EstimatedProfit,
    -- Customer types
    COUNT(DISTINCT CASE WHEN SUM(od.Quantity * od.UnitPrice) > 100000 THEN c.CustomerID END) AS HighValueCustomers
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY p.ProductID, p.ProductName, p.Category, p.Price, p.Stock
ORDER BY TotalRevenue DESC NULLS LAST;




1️⃣1️⃣ QUERY PATTERNS LIBRARY
Pattern 1: All Orders with Product Details
SELECT c.CustomerName, o.OrderID, o.OrderDate, p.ProductName, od.Quantity, (od.Quantity * od.UnitPrice) AS Total
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
ORDER BY c.CustomerName, o.OrderDate;



Pattern 2: Customers with No Orders
SELECT c.CustomerID, c.CustomerName, c.Country, c.RegistrationDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.RegistrationDate DESC;





Pattern 3: Products Never Ordered
SELECT p.ProductID, p.ProductName, p.Category, p.Price, p.Stock
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.OrderDetailID IS NULL
ORDER BY p.ProductName;




Pattern 4: Top Customers by Category
WITH CategorySpending AS (
    SELECT 
        c.CustomerID, c.CustomerName,
        p.Category,
        SUM(od.Quantity * od.UnitPrice) AS Spending,
        RANK() OVER (PARTITION BY p.Category ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS Rank
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
    INNER JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY c.CustomerID, c.CustomerName, p.Category
)
SELECT * FROM CategorySpending WHERE Rank <= 3;


Pattern 5: Monthly Trends
SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    COUNT(*) AS Orders,
    SUM(o.TotalAmount) AS Revenue,
    COUNT(DISTINCT c.CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT p.ProductID) AS UniqueProducts
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY Year, Month;




1️⃣2️⃣ COMMON MISTAKES & SOLUTIONS
Mistake 1: Cartesian Product (Unintended Duplicate Rows)
-- ❌ WRONG: This creates multiple rows per order detail!
SELECT c.CustomerID, c.CustomerName, o.OrderID, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;

-- ISSUE: If one order has 3 products, you get 3 rows per order

-- ✅ RIGHT: Aggregate if needed
SELECT 
    c.CustomerID, 
    c.CustomerName, 
    o.OrderID,
    STRING_AGG(p.ProductName, ', ') AS Products
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, o.OrderID;






Mistake 2: NULL Elimination with LEFT JOIN
-- ❌ WRONG: LEFT JOIN followed by INNER JOIN eliminates NULLs
SELECT c.CustomerName, o.OrderID, p.ProductName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID -- This eliminates customers with no orders!
INNER JOIN Products p ON od.ProductID = p.ProductID;

-- ✅ RIGHT: Use LEFT JOINs consistently
SELECT c.CustomerName, o.OrderID, p.ProductName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID;




Mistake 3: Missing JOIN Condition
-- ❌ WRONG: Forgot to join OrderDetails!
SELECT c.CustomerName, o.OrderID, od.Quantity, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
-- Missing: INNER JOIN OrderDetails...
INNER JOIN Products p ON ...WHERE p.ProductID = ?;

-- ✅ RIGHT: All 4 tables properly connected
SELECT c.CustomerName, o.OrderID, od.Quantity, p.ProductName
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;







Mistake 4: Forgetting to GROUP BY
-- ❌ WRONG: Aggregation without GROUP BY
SELECT c.CustomerName, SUM(od.Quantity) AS TotalItems
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;
-- Error: Non-aggregated column not in GROUP BY

-- ✅ RIGHT: GROUP BY all non-aggregated columns
SELECT c.CustomerID, c.CustomerName, SUM(od.Quantity) AS TotalItems
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;









