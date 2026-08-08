🟢 LEVEL 14: STORED PROCEDURES


-- Simple procedure
CREATE PROCEDURE sp_GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT OrderID, OrderDate, TotalAmount, OrderStatus
    FROM Orders
    WHERE CustomerID = @CustomerID
    ORDER BY OrderDate DESC;
END;

-- Execute procedure
EXEC sp_GetCustomerOrders 1;

-- Procedure with multiple parameters
CREATE PROCEDURE sp_CreateOrder
    @CustomerID INT,
    @OrderDate DATE,
    @TotalAmount DECIMAL(10,2),
    @OrderStatus NVARCHAR(20) = 'Pending' -- Default value
AS
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus)
    VALUES (@CustomerID, @OrderDate, @TotalAmount, @OrderStatus);
    
    SELECT @@IDENTITY AS NewOrderID; -- Return new ID
END;

-- Execute with parameters
EXEC sp_CreateOrder 2, '2024-03-20', 35000, 'Processing';

-- Procedure with OUTPUT parameter
CREATE PROCEDURE sp_GetCustomerStats
    @CustomerID INT,
    @OrderCount INT OUTPUT,
    @TotalSpent DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT 
        @OrderCount = COUNT(*),
        @TotalSpent = SUM(TotalAmount)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;

-- Use OUTPUT parameter
DECLARE @Orders INT, @Spent DECIMAL(10,2);
EXEC sp_GetCustomerStats 1, @Orders OUTPUT, @Spent OUTPUT;
SELECT @Orders AS OrderCount, @Spent AS TotalSpent;

-- Procedure with error handling
CREATE PROCEDURE sp_SafeDeleteOrder
    @OrderID INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Orders WHERE OrderID = @OrderID;
        PRINT 'Order deleted successfully';
    END TRY
    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;












