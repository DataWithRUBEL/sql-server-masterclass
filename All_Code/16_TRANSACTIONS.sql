🟢 LEVEL 16: TRANSACTIONS


-- Basic transaction
BEGIN TRANSACTION;
    INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus)
    VALUES (1, '2024-03-25', 50000, 'Pending');
    
    UPDATE Customers
    SET CreditLimit = CreditLimit - 50000
    WHERE CustomerID = 1;
COMMIT;

-- Rollback on error
BEGIN TRANSACTION;
    BEGIN TRY
        INSERT INTO Orders VALUES (999, '2024-03-25', 50000, 'Pending'); -- Might fail
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        PRINT 'Transaction rolled back due to error';
    END CATCH
END;

-- Savepoint (Partial rollback)
BEGIN TRANSACTION;
    INSERT INTO Orders VALUES (1, '2024-03-25', 50000, 'Pending');
    SAVE TRANSACTION SavePoint1;
    
    INSERT INTO Orders VALUES (2, '2024-03-26', 60000, 'Pending');
    SAVE TRANSACTION SavePoint2;
    
    INSERT INTO Orders VALUES (999, '2024-03-27', 70000, 'Pending'); -- Might fail
    
    IF @@ERROR != 0
        ROLLBACK TRANSACTION SavePoint2; -- Undo last insert only
    COMMIT;


