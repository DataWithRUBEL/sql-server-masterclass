🟢 LEVEL 2: FILTERING & OPERATORS

✅ AND / OR / NOT
-- AND: সব conditions match করতে হবে
SELECT 
  CustomerName, 
  Country, 
  CreditLimit
FROM Customers
WHERE Country = 'India' AND CreditLimit > 50000;

-- OR: কোনো একটা condition match করলে চলবে
SELECT 
  ProductName, 
  Category, 
  Price
FROM Products
WHERE Category = 'Electronics' OR Price > 25000;

-- NOT: opposite result
SELECT 
  CustomerName
FROM Customers
WHERE NOT Country = 'India';
-- Equivalent to: WHERE Country != 'India'

✅ IN / NOT IN
-- IN: multiple values check করে
SELECT 
  CustomerName, 
  Country
FROM Customers
WHERE Country IN ('India', 'Bangladesh', 'Pakistan');

-- NOT IN: exclude specific values
SELECT 
  ProductName
FROM Products
WHERE Category NOT IN ('Accessories', 'Clearance');

-- Use case: Find orders from specific customers
SELECT 
  OrderID, 
  OrderDate, 
  TotalAmount
FROM Orders
WHERE CustomerID IN (1, 3, 5);


✅ BETWEEN
-- Numeric range
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price BETWEEN 1000 AND 10000;

-- Date range
SELECT 
  OrderID, 
  OrderDate, 
  TotalAmount
FROM Orders
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-02-28';

-- NOT BETWEEN
SELECT 
  CustomerName, 
  CreditLimit
FROM Customers
WHERE CreditLimit NOT BETWEEN 50000 AND 80000;


✅ LIKE (Pattern Matching)
-- Starts with
SELECT 
  CustomerName, 
  Email
FROM Customers
WHERE CustomerName LIKE 'R%'; -- Names starting with R

-- Ends with
SELECT 
  ProductName
FROM Products
WHERE ProductName LIKE '%phone'; -- headphones, telephone

-- Contains
SELECT 
  CustomerName
FROM Customers
WHERE Email LIKE '%@email.com'; -- All @email.com addresses

-- Single character wildcard
SELECT 
  ProductName
FROM Products
WHERE ProductName LIKE 'M_use'; -- Mouse (exact 5 chars)

-- Case-insensitive LIKE (default in SQL Server)
SELECT * 
FROM Customers 
WHERE CustomerName LIKE 'rubel%';


✅ IS NULL / IS NOT NULL
-- Find NULL values
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderStatus IS NULL;

-- Find NOT NULL values
SELECT 
  CustomerName, 
  Email
FROM Customers
WHERE Email IS NOT NULL;

-- Practical: Orders without assigned status
SELECT 
  OrderID, 
  CustomerID, 
  OrderDate
FROM Orders
WHERE OrderStatus IS NULL;


✅ EXISTS / ANY / ALL
-- EXISTS: Check if subquery returns any row
SELECT DISTINCT 
  c.CustomerName
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Orders o WHERE o.CustomerID = c.CustomerID
);
-- Return only customers who have placed orders

-- ANY: Compare value to any value in a subquery
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > ANY (SELECT Price 
FROM Products 
WHERE Category = 'Electronics');

-- ALL: Compare value to all values
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > ALL (SELECT Price 
FROM Products 
WHERE Category = 'Accessories');
-- Products more expensive than ALL accessories










