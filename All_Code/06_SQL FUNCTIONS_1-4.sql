🟢 LEVEL 6: SQL FUNCTIONS
STRING FUNCTIONS
-- UPPER / LOWER
SELECT 
  UPPER(CustomerName) AS UpperName 
FROM Customers;
SELECT 
  LOWER(ProductName) AS LowerName 
FROM Products;


-- TRIM / LTRIM / RTRIM (Remove spaces)
SELECT 
  TRIM('  Hello World  ') AS Trimmed; -- 'Hello World'
SELECT 
  LTRIM('  Text') AS LeftTrimmed; -- 'Text'
SELECT
  RTRIM('Text  ') AS RightTrimmed; -- 'Text'


-- LEFT / RIGHT / SUBSTRING
SELECT 
  LEFT(CustomerName, 3) AS FirstThreeChars 
FROM Customers;


SELECT 
  RIGHT(Email, 8) AS EmailDomain 
FROM Customers; -- @email.com



SELECT 
  SUBSTRING(CustomerName, 1, 5) AS FirstFive 
FROM Customers;


-- REPLACE
SELECT 
  REPLACE(Email, '@email.com', '@gmail.com') AS NewEmail 
FROM Customers;


-- LEN (String length)
SELECT 
  CustomerName, 
  LEN(CustomerName) AS NameLength 
FROM Customers;


-- CONCAT / String Concatenation
SELECT 
  CONCAT(CustomerName, ' (', Country, ')') AS CustomerInfo 
FROM Customers;

-- Alternative: CustomerName + ' (' + Country + ')'

-- STRING_AGG (SQL Server 2017+) - ⭐ Very useful
SELECT 
    Country,
    STRING_AGG(CustomerName, ', ') AS CustomerList
FROM Customers
GROUP BY Country;
-- Result: India: Rahul Roy, Priya Sharma



NUMBER FUNCTIONS
-- ROUND
SELECT 
  Price, 
  ROUND(Price, 0) AS Rounded 
FROM Products;
SELECT 
  ROUND(TotalAmount, 2) 
FROM Orders;

-- ABS (Absolute value)
SELECT 
  ABS(-150) AS Positive; -- 150

-- CEILING / FLOOR
SELECT 
  CEILING(4.2) AS Ceil, FLOOR(4.8) AS Floor; -- 5, 4

-- POWER / SQRT
SELECT 
  POWER(2, 3) AS PowerResult; -- 8
SELECT 
  SQRT(16) AS SquareRoot; -- 4

-- RAND (Random number 0-1)
SELECT 
  RAND() AS RandomValue;
SELECT 
  ProductID, FLOOR(RAND() * 100) AS RandomNumber 
FROM Products;




DATE FUNCTIONS
-- GETDATE (Current date/time)
SELECT 
  GETDATE() AS CurrentDateTime;



-- DATEADD (Add interval to date)
SELECT 
  DATEADD(DAY, 30, OrderDate) AS DueDatePlus30Days 
FROM Orders;
SELECT 
  DATEADD(MONTH, -3, 
  GETDATE()) AS ThreeMonthsAgo;



-- DATEDIFF (Difference between dates)
SELECT 
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysAgo
FROM Orders;



-- DATEPART / DATENAME (Extract parts)
SELECT 
    OrderDate,
    DATEPART(YEAR, OrderDate) AS OrderYear,
    DATEPART(MONTH, OrderDate) AS OrderMonth,
    DATEPART(QUARTER, OrderDate) AS OrderQuarter,
    DATENAME(MONTH, OrderDate) AS MonthName
FROM Orders;


-- EOMONTH (End of month)
SELECT 
  OrderDate, 
  EOMONTH(OrderDate) AS EndOfMonth 
  FROM Orders;

-- CAST / CONVERT (Type conversion)
SELECT 
  CAST(Price AS INT) 
FROM Products;
SELECT 
  CONVERT(VARCHAR(10), OrderDate, 101) AS FormattedDate  -- 101 format: mm/dd/yyyy
FROM Orders;





NULL FUNCTIONS
-- ISNULL (Replace NULL with value)
SELECT 
    CustomerName,
    ISNULL(Email, 'No Email') AS EmailOrDefault
FROM Customers;



-- COALESCE (Return first non-NULL value)
SELECT 
    CustomerName,
    COALESCE(Email, SecondaryEmail, 'No Contact') AS PrimaryEmail
FROM Customers;



-- NULLIF (Return NULL if two values equal)
SELECT 
    ProductID,
    NULLIF(Price, 0) AS SafePrice -- NULL if price is 0
FROM Products;











