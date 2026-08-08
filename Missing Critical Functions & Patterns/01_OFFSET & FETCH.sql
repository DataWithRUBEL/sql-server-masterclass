1️⃣ OFFSET & FETCH - Pagination (Essential for Reports)

Basic Pagination

-- Get records 11-20 (second page of 10 records each)
SELECT ProductID, 
  ProductName, 
  Price
FROM Products
ORDER BY Price DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- First 5 records
SELECT * 
FROM Customers
ORDER BY CustomerID
OFFSET 0 ROWS FETCH FIRST 5 ROWS ONLY;

-- Last 3 orders
SELECT TOP 3 * 
FROM Orders
ORDER BY OrderDate DESC; -- या OFFSET/FETCH version:


SELECT * 
FROM Orders
ORDER BY OrderDate DESC
OFFSET 0 ROWS FETCH FIRST 3 ROWS ONLY;






Pagination for Reports (Real-world)
-- Dynamic pagination formula
DECLARE @PageNumber INT = 2;
DECLARE @PageSize INT = 20;

SELECT 
    ROW_NUMBER() OVER (ORDER BY OrderDate DESC) AS RowNum,
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount
FROM Orders
ORDER BY OrderDate DESC
OFFSET (@PageNumber - 1) * @PageSize ROWS 
FETCH NEXT @PageSize ROWS ONLY;

-- Result: Page 2 shows records 21-40

-- Add total count and pages
WITH OrdersPaged AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY OrderDate DESC) AS RowNum,
        COUNT(*) OVER () AS TotalRecords,
        OrderID,
        CustomerID,
        OrderDate,
        TotalAmount
    FROM Orders
)
SELECT 
    RowNum,
    OrderID,
    OrderDate,
    TotalAmount,
    TotalRecords,
    CEILING(CAST(TotalRecords AS DECIMAL) / 20) AS TotalPages,
    CEILING(CAST(RowNum AS DECIMAL) / 20) AS CurrentPage
FROM OrdersPaged
WHERE RowNum BETWEEN (@PageNumber - 1) * 20 + 1 AND @PageNumber * 20;






Top N by Group with OFFSET/FETCH
-- Top 2 most expensive products per category
WITH RankedProducts AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Price DESC) AS Rank
    FROM Products
)
SELECT 
    Category,
    ProductName,
    Price,
    Rank
FROM RankedProducts
WHERE Rank <= 2
ORDER BY Category, Price DESC;

-- OFFSET/FETCH variant (for pagination within group)
WITH RankedOrders AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS OrderSeq
    FROM Orders
)
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalAmount,
    OrderSeq
FROM RankedOrders
WHERE OrderSeq > 2 AND OrderSeq <= 5; -- Skip first 2, take next 3 orders








