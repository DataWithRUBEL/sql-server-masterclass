🔷 AGGREGATION FUNCTIONS - Advanced
1. APPROX_COUNT_DISTINCT - Approximate Distinct Count (Fast)

What it does: APPROXIMATE count return  (large datasets fast)

-- Exact count (slow for huge datasets)
SELECT COUNT(DISTINCT CustomerID) AS ExactUniqueCustomers
FROM Orders;

-- Approximate count (very fast)
SELECT APPROX_COUNT_DISTINCT(CustomerID) AS ApproximateUniqueCustomers
FROM Orders;

-- Comparison
SELECT 
    (SELECT COUNT(DISTINCT CustomerID) FROM Orders) AS Exact,
    (SELECT APPROX_COUNT_DISTINCT(CustomerID) FROM Orders) AS Approximate,
    CAST(100 * ABS(
        (SELECT COUNT(DISTINCT CustomerID) FROM Orders) - 
        (SELECT APPROX_COUNT_DISTINCT(CustomerID) FROM Orders)
    ) / (SELECT COUNT(DISTINCT CustomerID) FROM Orders) AS DECIMAL(5,2)) AS ErrorPercentage;





2. STRING_AGG with ORDER BY - Ordered Concatenation

-- Simple concatenation (comma-separated)
SELECT 
    DATEPART(MONTH, OrderDate) AS Month,
    STRING_AGG(CAST(OrderID AS VARCHAR), ', ') AS OrderNumbers
FROM Orders
GROUP BY DATEPART(MONTH, OrderDate);

-- Ordered concatenation (sorted)
SELECT 
    CustomerID,
    STRING_AGG(ProductName, ' | ') WITHIN GROUP (ORDER BY ProductName) AS ProductsList
FROM (
    SELECT DISTINCT c.CustomerID, p.ProductName
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
) OrderedProducts
GROUP BY CustomerID;

-- Generate readable customer purchase history
SELECT 
    c.CustomerName,
    STRING_AGG(
        CONCAT(p.ProductName, ' (', FORMAT(o.OrderDate, 'dd-MMM-yyyy'), ')'),
        ' -> '
    ) WITHIN GROUP (ORDER BY o.OrderDate DESC) AS PurchaseHistory
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;









📊 PRACTICAL WORKFLOWS
Data Cleaning Pipeline
-- Raw data → Cleaned data
SELECT 
    TRY_CAST(ID AS INT) AS CleanedID,
    TRIM(UPPER(Name)) AS CleanedName,
    TRY_CAST(Amount AS DECIMAL(10,2)) AS CleanedAmount,
    TRANSLATE(LOWER(Email), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') AS CleanedEmail,
    CASE WHEN TRY_CAST(Date AS DATE) IS NULL THEN CAST(GETDATE() AS DATE) ELSE CAST(Date AS DATE) END AS CleanedDate
FROM RawData
WHERE TRY_CAST(ID AS INT) IS NOT NULL;






JSON Data Migration
-- Store structured data as JSON
INSERT INTO CustomerProfiles (CustomerID, ProfileJSON)
SELECT 
    CustomerID,
    (SELECT 
        CustomerName AS Name,
        Country,
        CreditLimit,
        RegistrationDate,
        GETDATE() AS ImportDate
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
FROM Customers;

-- Query JSON columns
SELECT 
    CustomerID,
    JSON_VALUE(ProfileJSON, '$.Name') AS Name,
    JSON_VALUE(ProfileJSON, '$.Country') AS Country,
    JSON_VALUE(ProfileJSON, '$.CreditLimit') AS Limit
FROM CustomerProfiles;
















