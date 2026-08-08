1: SQL FUNDAMENTALS
  

✅ SELECT
What it does: Data retrieve করে tables থেকে
-- All columns
SELECT * 
FROM Customers;

-- Specific columns
SELECT 
  CustomerID, 
  CustomerName, 
  Email 
FROM Customers;

-- Single column
SELECT 
  ProductName 
FROM Products;


✅ FROM
What it does: Define করে কোন table থেকে data pull করতে হবে 
SELECT 
  CustomerName, 
  Country 
FROM Customers;


✅ WHERE
What it does: Filter করে specific conditions based এ
-- India থেকে সব customers
SELECT 
  CustomerName, 
  Country 
FROM Customers 
WHERE Country = 'India';

-- Price ৫০০০ এর উপরে products
SELECT 
  ProductName, 
  Price 
FROM Products 
WHERE Price > 5000;

-- ২০২৪ সালের orders
SELECT 
  OrderID, 
  OrderDate, 
  TotalAmount 
FROM Orders 
WHERE YEAR(OrderDate) = 2024;


✅ ORDER BY
What it does: Sort করে result ascending বা descending order এ
-- Price highest to lowest
SELECT 
  ProductName, 
  Price 
FROM Products 
ORDER BY Price DESC;

-- Customer name alphabetically
SELECT 
  CustomerName, 
  Country 
FROM Customers 
ORDER BY CustomerName ASC;

-- Multiple column sorting
SELECT 
  CustomerName, 
  OrderDate, 
  TotalAmount 
FROM Orders o
INNER JOIN Customers c 
ON o.CustomerID = c.CustomerID
ORDER BY CustomerName ASC, 
         OrderDate DESC;


✅ GROUP BY
What it does: Group করে data একটি column base এ আর aggregate function apply করে 
-- Countries এ customers এর count
SELECT 
  Country, 
  COUNT(*) AS CustomerCount 
FROM Customers 
GROUP BY Country;

-- Product category তে total products
SELECT 
  Category, 
  COUNT(*) AS ProductCount 
FROM Products 
GROUP BY Category;

-- Total sales per customer
SELECT 
  c.CustomerName, 
  COUNT(o.OrderID) AS OrderCount, 
  SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


✅ HAVING
What it does: WHERE এর মতো, কিন্তু GROUP BY এর পরে filter করে 
-- Countries যেখানে 2+ customers আছে
SELECT 
  Country, 
  COUNT(*) AS CustomerCount 
FROM Customers 
GROUP BY Country 
HAVING COUNT(*) >= 2;

-- Total sales > 50000 এর customers
SELECT 
  c.CustomerName, 
  SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.TotalAmount) > 50000;


✅ DISTINCT
What it does: Remove করে duplicate values
-- Unique countries
SELECT DISTINCT 
  Country 
FROM Customers;

-- Unique product categories
SELECT DISTINCT 
  Category 
FROM Products;

-- Unique order status
SELECT DISTINCT 
  OrderStatus 
FROM Orders;


✅ TOP
What it does: Select করে শুধুমাত্র N rows
-- Top 3 expensive products
SELECT TOP 3 
  ProductName, 
  Price 
FROM Products 
ORDER BY Price DESC;

-- Top 2 customers by spending
SELECT TOP 2 
  c.CustomerName, 
  SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC;

-- Top 50% of products by price
SELECT TOP 50 
  PERCENT ProductName, 
  Price 
FROM Products 
ORDER BY Price DESC;


✅ AS (Alias)
What it does: Rename করে column বা table names (temporary)
-- Column alias
SELECT 
    CustomerName AS 'Customer Name', 
    Email AS 'Email Address',
    Country AS 'Country/Region'
FROM Customers;

-- Calculation with alias
SELECT 
    ProductName, 
    Price AS 'Current Price',
    (Price * 0.1) AS 'Discount (10%)',
    (Price * 0.9) AS 'Final Price'
FROM Products;

-- Table alias (useful in joins)
SELECT 
    c.CustomerName, 
    o.OrderID, 
    o.OrderDate
FROM Customers c
INNER JOIN Orders o 
ON c.CustomerID = o.CustomerID;


✅ Comments
What it does: Explain করে code, execution এ ignored
-- Single line comment
/* 
   Multi-line comment
   এটা সব customers retrieve করছে
   যারা India থেকে
*/
SELECT 
  CustomerName, 
  Country 
FROM Customers 
WHERE Country = 'India'; -- Filter for India only






















