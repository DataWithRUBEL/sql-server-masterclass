🟢 LEVEL 12: DATA MODIFICATION (INSERT, UPDATE, DELETE)

-- INSERT single row
INSERT INTO Customers (CustomerName, Email, Country, RegistrationDate, CreditLimit)
VALUES ('Karim Hassan', 'karim@email.com', 'Bangladesh', '2024-03-15', 55000);

-- INSERT multiple rows
INSERT INTO Products (ProductName, Category, Price, Stock, Supplier)
VALUES 
('Webcam', 'Electronics', 2500, 100, 'TechCorp'),
('USB Hub', 'Accessories', 800, 250, 'TechCorp');

-- INSERT from SELECT (Copy data)
INSERT INTO Products_Backup
SELECT * FROM Products WHERE Category = 'Electronics';

-- UPDATE single column
UPDATE Customers
SET Email = 'new@email.com'
WHERE CustomerID = 1;

-- UPDATE with calculation
UPDATE Products
SET Stock = Stock - 10
WHERE Category = 'Electronics';

-- UPDATE with JOIN
UPDATE Orders
SET OrderStatus = 'Completed'
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'India' AND o.OrderStatus = 'Processing';

-- DELETE specific rows
DELETE FROM Orders
WHERE OrderStatus = 'Cancelled' AND OrderDate < '2024-01-01';

-- DELETE with condition
DELETE FROM Products
WHERE Stock = 0 AND Price < 1000;

-- MERGE (Insert/Update/Delete in one statement)
MERGE INTO Customers AS target
USING (SELECT CustomerID, Email FROM Customers_New) AS source
ON target.CustomerID = source.CustomerID
WHEN MATCHED THEN
    UPDATE SET Email = source.Email
WHEN NOT MATCHED THEN
    INSERT (CustomerName, Email, Country, CreditLimit) 
    VALUES (source.CustomerName, source.Email, source.Country, 50000);













