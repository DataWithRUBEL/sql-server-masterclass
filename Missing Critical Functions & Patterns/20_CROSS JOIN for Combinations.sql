2️⃣0️⃣ CROSS JOIN for Combinations
Generate All Possible Combinations


-- All customer-product combinations for recommendation engine
SELECT 
    c.CustomerID,
    c.CustomerName,
    p.ProductID,
    p.ProductName,
    p.Price,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM OrderDetails od 
            JOIN Orders o ON od.OrderID = o.OrderID
            WHERE o.CustomerID = c.CustomerID AND od.ProductID = p.ProductID
        ) THEN 'Purchased'
        ELSE 'Not Purchased'
    END AS PurchaseStatus
FROM Customers c
CROSS JOIN Products p
ORDER BY c.CustomerID, p.ProductID;

-- Matrix generation (dates × products)
SELECT 
    d.DateValue,
    p.ProductID,
    p.ProductName,
    0 AS SalesAmount -- Placeholder for actual sales
FROM (
    SELECT CAST('2024-01-01' AS DATE) + NUMBERS.RN AS DateValue
    FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS RN FROM Products p CROSS JOIN Products p2) NUMBERS
    WHERE NUMBERS.RN < 365
) d
CROSS JOIN Products p
ORDER BY d.DateValue, p.ProductID;




Practice Exercises:
-- 1. Build customer purchase frequency report with OFFSET/FETCH
-- 2. Create hierarchical employee org chart with recursive CTE
-- 3. Reshape wide format sales data using PIVOT
-- 4. Calculate moving averages and running totals with window functions
-- 5. Build multi-level sales report with GROUPING SETS
-- 6. Extract top N items per group with CROSS APPLY
-- 7. Optimize slow queries using EXISTS instead of IN
-- 8. Build dynamic SQL ETL procedure
-- 9. Parse JSON API responses
-- 10. Compare performance of different approaches
















