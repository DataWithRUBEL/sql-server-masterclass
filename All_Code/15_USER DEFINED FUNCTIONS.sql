🟢 LEVEL 15: USER DEFINED FUNCTIONS

-- Scalar Function (Returns single value)
CREATE FUNCTION fn_CalculateDiscount (@TotalAmount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Discount DECIMAL(10,2);
    IF @TotalAmount > 100000
        SET @Discount = @TotalAmount * 0.15;
    ELSE IF @TotalAmount > 50000
        SET @Discount = @TotalAmount * 0.10;
    ELSE
        SET @Discount = @TotalAmount * 0.05;
    RETURN @Discount;
END;

-- Use scalar function
SELECT OrderID, TotalAmount, dbo.fn_CalculateDiscount(TotalAmount) AS Discount
FROM Orders;

-- Table-Valued Function (Returns table)
CREATE FUNCTION fn_CustomerOrderHistory (@CustomerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        OrderID,
        OrderDate,
        TotalAmount,
        OrderStatus,
        DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysAgo
    FROM Orders
    WHERE CustomerID = @CustomerID
);

-- Use table-valued function
SELECT * FROM fn_CustomerOrderHistory(1);

-- Multi-statement table-valued function
CREATE FUNCTION fn_ProductAnalysis (@CategoryFilter NVARCHAR(50))
RETURNS @ProductStats TABLE (
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2),
    TimesSold INT,
    Revenue DECIMAL(10,2)
)
AS
BEGIN
    INSERT @ProductStats
    SELECT 
        p.ProductName,
        p.Category,
        p.Price,
        COUNT(od.OrderDetailID) AS TimesSold,
        ISNULL(SUM(od.Quantity * od.UnitPrice), 0) AS Revenue
    FROM Products p
    LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
    WHERE p.Category = @CategoryFilter
    GROUP BY p.ProductID, p.ProductName, p.Category, p.Price;
    RETURN;
END;





