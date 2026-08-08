🟢 LEVEL 20: ADVANCED SQL

Dynamic SQL
-- Build query at runtime
DECLARE @TableName NVARCHAR(50) = 'Customers';
DECLARE @SQL NVARCHAR(MAX) = 'SELECT * FROM ' + @TableName;
EXEC sp_executesql @SQL;

-- Parameterized dynamic SQL (safer)
DECLARE @CustomerID INT = 1;
DECLARE @SQL NVARCHAR(MAX) = 'SELECT * FROM Orders WHERE CustomerID = @CustID';
EXEC sp_executesql @SQL, N'@CustID INT', @CustID = @CustomerID;



PIVOT
-- Transpose rows to columns
SELECT 
    [Electronics],
    [Accessories],
    [Clearance]
FROM (
    SELECT Category, ProductName FROM Products
) SourceTable
PIVOT (
    COUNT(ProductName)
    FOR Category IN ([Electronics], [Accessories], [Clearance])
) PivotTable;





UNPIVOT
-- Transpose columns to rows
SELECT MonthName, Sales
FROM (
    SELECT Jan, Feb, Mar, Apr FROM MonthlySales
) SourceTable
UNPIVOT (
    Sales FOR MonthName IN (Jan, Feb, Mar, Apr)
) UnpivotTable;




JSON Functions
-- Convert row to JSON
SELECT CustomerID, CustomerName, Email
FROM Customers
FOR JSON PATH;

-- Parse JSON
DECLARE @JSON NVARCHAR(MAX) = '{"CustomerName":"Rahul", "Country":"India"}';
SELECT 
    JSON_VALUE(@JSON, '$.CustomerName') AS Name,
    JSON_VALUE(@JSON, '$.Country') AS Country;





Temp Tables vs Table Variables
-- Local Temp Table (visible within connection)
CREATE TABLE #TempOrders (
    OrderID INT,
    CustomerID INT,
    TotalAmount DECIMAL(10,2)
);
INSERT INTO #TempOrders SELECT OrderID, CustomerID, TotalAmount FROM Orders;

-- Global Temp Table (visible across connections)
CREATE TABLE ##GlobalTempOrders (...);

-- Table Variable (In-memory, faster for small data)
DECLARE @OrdersTable TABLE (
    OrderID INT,
    TotalAmount DECIMAL(10,2)
);
INSERT INTO @OrdersTable SELECT OrderID, TotalAmount FROM Orders;

-- Use in joins/subqueries
SELECT * FROM @OrdersTable WHERE TotalAmount > 50000;




SQL SERVER SPECIFIC FEATURES

STRING_AGG() - Concatenate strings (SQL Server 2017+)
SELECT 
  Country, STRING_AGG(CustomerName, ', ') 
  FROM Customers 
  GROUP BY Country;




FORMAT() - Format dates/numbers
SELECT 
  FORMAT(Price, 'C2') AS FormattedPrice 
FROM Products;
SELECT 
  FORMAT(OrderDate, 'dd/MM/yyyy') 
FROM Orders;



IIF() - Inline IF (simpler than CASE)
SELECT 
  CustomerName, 
  IIF(CreditLimit > 50000, 'VIP', 'Regular') 
FROM Customers;




OFFSET...FETCH - Pagination
SELECT * 
FROM Products 
ORDER BY Price DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;














