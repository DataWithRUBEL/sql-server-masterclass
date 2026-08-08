1️⃣1️⃣ CONCAT_WS - Concatenation with Separator
String Building with Separator


-- Old way (using +)
SELECT 
    CustomerName + ', ' + Country + ', ' + Email AS CustomerInfo
FROM Customers;

-- CONCAT_WS way (handles NULLs, cleaner)
SELECT 
    CONCAT_WS(', ', CustomerName, Country, Email) AS CustomerInfo
FROM Customers;

-- Difference: CONCAT_WS skips NULL values
-- Result without CONCAT_WS if Email is NULL: "Rahul Roy, India, "
-- Result with CONCAT_WS: "Rahul Roy, India"

-- Real-world: Build full address
SELECT 
    CustomerID,
    CONCAT_WS(' | ', CustomerName, Country, CreditLimit) AS FullInfo,
    CONCAT_WS('-', YEAR(RegistrationDate), MONTH(RegistrationDate), DAY(RegistrationDate)) AS RegistrationYMD
FROM Customers;

-- CSV generation
SELECT 
    CONCAT_WS(',', OrderID, CustomerID, TotalAmount, OrderStatus) AS CSVLine
FROM Orders
ORDER BY OrderID;


















