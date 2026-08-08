9️⃣ ISNULL vs COALESCE - NULL Handling Nuances
Performance & Functionality Differences




-- ISNULL (SQL Server only, 2 arguments)
SELECT 
    OrderID,
    ISNULL(DiscountApplied, 0) AS Discount
FROM Orders;

-- COALESCE (ANSI standard, N arguments, more flexible)
SELECT 
    OrderID,
    COALESCE(DiscountApplied, SpecialOffer, 0) AS DiscountAmount,
    COALESCE(SecondaryEmail, PrimaryEmail, 'No Email') AS Email
FROM Customers;

-- Performance:
-- ISNULL: Faster (native SQL Server)
-- COALESCE: Slower but more readable

-- Type conversion difference
SELECT 
    CustomerName,
    CAST(CreditLimit AS VARCHAR) AS CreditAsString,
    ISNULL(SpecialRate, 0) AS Rate1,              -- Returns DECIMAL
    COALESCE(SpecialRate, 0) AS Rate2             -- Returns DECIMAL
FROM Customers;

-- Multiple NULLs scenario
SELECT 
    CustomerID,
    COALESCE(
        SecondaryPhone,
        MobilePhone,
        OfficePhone,
        'No Contact'
    ) AS ContactNumber
FROM Customers;



















