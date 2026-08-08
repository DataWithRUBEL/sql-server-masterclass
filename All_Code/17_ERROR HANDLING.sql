🟢 LEVEL 17: ERROR HANDLING


-- TRY...CATCH
BEGIN TRY
    SELECT 1 / 0; -- Error!
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber;
    SELECT ERROR_MESSAGE() AS ErrorMessage;
    SELECT ERROR_SEVERITY() AS ErrorSeverity;
    SELECT ERROR_STATE() AS ErrorState;
END CATCH

-- THROW (Raise error)
IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = 999)
    THROW 50000, 'Customer not found', 1;

-- Practical error handling in procedure
CREATE PROCEDURE sp_ProcessOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
            THROW 50001, 'Customer does not exist', 1;
        
        IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
            THROW 50002, 'Product does not exist', 1;
        
        DECLARE @AvailableStock INT;
        SELECT @AvailableStock = Stock FROM Products WHERE ProductID = @ProductID;
        
        IF @Quantity > @AvailableStock
            THROW 50003, 'Insufficient stock', 1;
        
        -- Process order
        INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus)
        SELECT @CustomerID, GETDATE(), (p.Price * @Quantity), 'Pending'
        FROM Products p WHERE ProductID = @ProductID;
        
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
        ROLLBACK;
    END CATCH
END;

