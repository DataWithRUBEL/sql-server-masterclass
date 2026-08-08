-- Check if specific column was updated
CREATE TRIGGER OrdersPriceChangeTrigger
ON OrderDetails
AFTER UPDATE
AS
BEGIN
    IF UPDATE(UnitPrice)
    BEGIN
        INSERT INTO PriceAuditLog (OrderDetailID, OldPrice, NewPrice, ChangeTime)
        SELECT i.OrderDetailID, d.UnitPrice, i.UnitPrice, GETDATE()
        FROM inserted i
        JOIN deleted d ON i.OrderDetailID = d.OrderDetailID;
    END
END;

-- Check multiple columns
IF UPDATE(Price) OR UPDATE(Stock)
BEGIN
    -- Log changes
END;
