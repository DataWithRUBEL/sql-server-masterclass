1️⃣7️⃣ Dynamic SQL - Build Queries at Runtime
Safe Dynamic SQL with Parameterization

-- Safe approach: sp_executesql with parameters
DECLARE @SearchCountry NVARCHAR(50) = 'India';
DECLARE @MinAmount DECIMAL(10,2) = 50000;
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'
    SELECT c.CustomerName, c.Country, SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country AND SUM(o.TotalAmount) > @Amount
    GROUP BY c.CustomerID, c.CustomerName, c.Country
';

EXEC sp_executesql 
    @SQL,
    N'@Country NVARCHAR(50), @Amount DECIMAL(10,2)',
    @Country = @SearchCountry,
    @Amount = @MinAmount;

-- Build dynamic column selection
DECLARE @Columns NVARCHAR(MAX) = 'OrderID, OrderDate, TotalAmount';
SET @SQL = N'SELECT ' + @Columns + ' FROM Orders WHERE YEAR(OrderDate) = 2024';
EXEC sp_executesql @SQL;

-- Build dynamic pivot
DECLARE @Countries NVARCHAR(MAX) = '[India], [Bangladesh], [Pakistan]';
SET @SQL = N'
    SELECT *
    FROM (SELECT Country, TotalAmount FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID)
    PIVOT (SUM(TotalAmount) FOR Country IN (' + @Countries + ')) PivotTable
';
EXEC sp_executesql @SQL;



















