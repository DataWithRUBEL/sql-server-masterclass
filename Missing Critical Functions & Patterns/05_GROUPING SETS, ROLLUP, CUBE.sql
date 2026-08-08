5️⃣ GROUPING SETS, ROLLUP, CUBE - Advanced Grouping
GROUPING SETS - Multiple Grouping Dimensions

-- Sales by: (1) Country, (2) Category, (3) Both, (4) Grand Total
SELECT 
    c.Country,
    p.Category,
    SUM(o.TotalAmount) AS Sales,
    COUNT(o.OrderID) AS OrderCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY GROUPING SETS (
    (c.Country),           -- Sales by country
    (p.Category),          -- Sales by category
    (c.Country, p.Category), -- Sales by country & category
    ()                     -- Grand total
)
ORDER BY Country, Category;

-- With GROUPING function to identify aggregation level
SELECT 
    c.Country,
    p.Category,
    SUM(o.TotalAmount) AS Sales,
    GROUPING(c.Country) AS IsCountryTotal,
    GROUPING(p.Category) AS IsCategoryTotal,
    CASE 
        WHEN GROUPING(c.Country) = 0 AND GROUPING(p.Category) = 0 THEN 'Country & Category'
        WHEN GROUPING(c.Country) = 0 THEN 'Country Total'
        WHEN GROUPING(p.Category) = 0 THEN 'Category Total'
        ELSE 'Grand Total'
    END AS GroupLevel
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY GROUPING SETS (
    (c.Country),
    (p.Category),
    (c.Country, p.Category),
    ()
)
ORDER BY IsCountryTotal, IsCategoryTotal;








ROLLUP - Hierarchical Totals
-- Year → Month → Day progression
SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    DAY(o.OrderDate) AS Day,
    SUM(o.TotalAmount) AS Sales,
    GROUPING(YEAR(o.OrderDate)) AS YearGrouping,
    GROUPING(MONTH(o.OrderDate)) AS MonthGrouping,
    GROUPING(DAY(o.OrderDate)) AS DayGrouping
FROM Orders o
GROUP BY ROLLUP (YEAR(o.OrderDate), MONTH(o.OrderDate), DAY(o.OrderDate))
ORDER BY Year, Month, Day;

-- Result shows:
-- 2024 | 1 | 1 | Sales
-- 2024 | 1 | 10 | Sales
-- 2024 | 1 | NULL | Month total
-- 2024 | NULL | NULL | Year total
-- NULL | NULL | NULL | Grand total

-- Practical: Sales hierarchy
SELECT 
    c.Country,
    p.Category,
    p.ProductName,
    SUM(o.TotalAmount) AS Sales
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY ROLLUP (c.Country, p.Category, p.ProductName)
ORDER BY Country, Category, ProductName;







CUBE - All Possible Combinations
-- All combinations of Country × Category
SELECT 
    c.Country,
    p.Category,
    SUM(o.TotalAmount) AS Sales,
    COUNT(o.OrderID) AS Orders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY CUBE (c.Country, p.Category)
ORDER BY Country, Category;

-- Result includes:
-- India | Electronics | Sales
-- India | (NULL) | India total
-- (NULL) | Electronics | Electronics total
-- (NULL) | (NULL) | Grand total

-- CUBE vs ROLLUP:
-- ROLLUP(A, B, C): (A,B,C), (A,B), (A), () = 4 groups
-- CUBE(A, B, C): 2^3 = 8 groups (all combinations)









