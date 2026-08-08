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


✅ Comparison Operators
Operator	                 Symbol	              Meaning	                  Example
Equal To	                 =	                  দুটো value same	          Price = 5000
Not Equal To	             != or <>	            দুটো value different	    Status != 'Pending'
Greater Than	             >	                  Left > Right	            Price > 10000
Less Than	                 <	                  Left < Right	            Age < 30
Greater Than or Equal	     >=	                  Left >= Right	            Salary >= 50000
Less Than or Equal	       <=	                  Left <= Right	            Stock <= 100


1️⃣ EQUAL TO (=)
-- Find specific customer
SELECT * 
FROM Customers
WHERE CustomerID = 1;

-- Find products in specific category
SELECT 
  ProductName, 
  Price 
FROM Products
WHERE Category = 'Electronics';

-- Orders with specific status
SELECT 
  OrderID, 
  OrderDate 
FROM Orders
WHERE OrderStatus = 'Completed';


-- With Numbers
-- Products with exact price
SELECT 
  ProductName 
FROM Products
WHERE Price = 5500;

-- Orders with exact amount
SELECT 
  OrderID 
FROM Orders
WHERE TotalAmount = 25000;

-- Count records matching condition
SELECT 
  COUNT(*) AS MatchingRecords
FROM Orders
WHERE TotalAmount = 75000;


-- With Dates
-- Orders from specific date
SELECT 
  OrderID, 
  CustomerID
FROM Orders
WHERE OrderDate = '2024-01-15';

-- Orders from specific month/year
SELECT 
  COUNT(*) 
FROM Orders
WHERE YEAR(OrderDate) = 2024 AND MONTH(OrderDate) = 1;

-- Better approach: Use date range (for performance)
SELECT 
  COUNT()
FROM Orders
WHERE OrderDate >= '2024-01-01' AND OrderDate < '2024-02-01';


-- With NULL (Important!)
-- ❌ WRONG - This will NOT work
SELECT * 
FROM Orders 
WHERE OrderStatus = NULL;
-- NULL is unknown, = comparison doesn't work

-- ✅ CORRECT - Use IS NULL
SELECT * 
FROM Orders 
WHERE OrderStatus IS NULL;


--Performance Tip
-- Use = for indexed columns (fast)
-- Index created on CustomerID
SELECT * 
FROM Orders 
WHERE CustomerID = 1; -- Very fast

-- Non-indexed comparison is slower
SELECT * 
FROM Orders 
WHERE Email = 'test@email.com'; -- Slower (table scan)


2️⃣ NOT EQUAL TO (!= or <>)
-- Basic Usage
-- Both syntaxes work (use != in modern SQL)
SELECT * 
FROM Orders 
WHERE OrderStatus != 'Cancelled';
SELECT * 
FROM Orders 
WHERE OrderStatus <> 'Cancelled';
-- Both return same results


-- Exclude Specific Values
-- All products EXCEPT Electronics
SELECT 
  ProductName, 
  Category, 
  Price
FROM Products
WHERE Category != 'Electronics';

-- All customers NOT from India
SELECT 
  CustomerName, 
  Country
FROM Customers
WHERE Country <> 'India';

-- Orders NOT yet completed
SELECT 
  OrderID, 
  OrderStatus
FROM Orders
WHERE OrderStatus != 'Completed';


-- Multiple Conditions
-- Orders that are NOT completed AND NOT pending
SELECT 
  OrderID, 
  OrderStatus, 
  TotalAmount
FROM Orders
WHERE OrderStatus != 'Completed' 
AND OrderStatus != 'Pending';

-- Better approach: Use NOT IN
SELECT 
  OrderID, 
  OrderStatus, 
  TotalAmount
FROM Orders
WHERE OrderStatus NOT IN ('Completed', 'Pending');

-- Or use IN with negation
SELECT 
  OrderID, 
  OrderStatus, 
  TotalAmount
FROM Orders
WHERE OrderStatus IN ('Processing', 'Cancelled');


-- With Numbers
-- Products NOT with default price
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price != 0;

-- Orders not exactly 50000
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount != 50000;


-- Null Consideration
-- ❌ WRONG
SELECT * 
FROM Orders 
WHERE OrderStatus != 'Completed';
-- This EXCLUDES NULL values (they're unknown)

-- ✅ CORRECT (if you want to include NULL)
SELECT * 
FROM Orders
WHERE OrderStatus != 'Completed' OR OrderStatus IS NULL;


3️⃣ GREATER THAN (>)
-- Basic Numeric Comparison
-- Products more expensive than 10000
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > 10000;

-- Orders greater than 50000
SELECT 
  OrderID, 
  TotalAmount, 
  OrderDate
FROM Orders
WHERE TotalAmount > 50000
ORDER BY TotalAmount DESC;

-- Quantity ordered more than 5 units
SELECT 
  OrderDetailID, 
  ProductID, 
  Quantity
FROM OrderDetails
WHERE Quantity > 5;


-- Date Comparison
-- Orders after January 2024
SELECT 
  OrderID, 
  OrderDate, 
  TotalAmount
FROM Orders
WHERE OrderDate > '2024-01-31';

-- Orders in last 30 days
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate > DATEADD(DAY, -30, GETDATE());

-- Customers registered after 2023
SELECT 
  CustomerName, 
  RegistrationDate
FROM Customers
WHERE RegistrationDate > '2023-12-31';


-- Comparison with Aggregates
-- Products more expensive than average
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- Result:
-- Laptop: 75000 (avg is 22040)
-- Monitor: 25000
-- Keyboard: 3500 (oops, this is LESS than avg)

-- Customers who spent more than average
SELECT 
  c.CustomerName, 
  SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
LEFT JOIN Orders o 
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(o.TotalAmount) > (SELECT AVG(TotalAmount) FROM Orders);


-- Combined with AND
-- Price between 5000 and 25000
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > 5000 AND Price < 25000;

-- Better approach: Use BETWEEN
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price BETWEEN 5000 AND 25000;


4️⃣ LESS THAN (<)
-- Basic Numeric Comparison
-- Cheap products (under 5000)
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price < 5000;

-- Small orders (less than 30000)
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount < 30000;

-- Low stock items
SELECT 
  ProductName, 
  Stock
FROM Products
WHERE Stock < 50;


-- Date Comparison
-- Orders before February 2024
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate < '2024-02-01';

-- Old customers (registered before 2022)
SELECT 
  CustomerName, 
  RegistrationDate
FROM Customers
WHERE RegistrationDate < '2022-01-01';

-- Recent registrations (last 90 days)
SELECT 
  CustomerName, 
  RegistrationDate
FROM Customers
WHERE RegistrationDate > DATEADD(DAY, -90, GETDATE());


-- Finding Edge Cases
-- Products with stock less than reorder point
SELECT 
  ProductName, 
  Stock, 
  Price
FROM Products
WHERE Stock < 100
ORDER BY Stock ASC;

-- Low-value orders
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount < 10000
ORDER BY TotalAmount;


5️⃣ GREATER THAN OR EQUAL (>=)
-- Basic Usage
-- Products 5000 or more
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price >= 5000;

-- Orders of 50000 or more
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount >= 50000;

-- Customers with good credit limit
SELECT 
  CustomerName, 
  CreditLimit
FROM Customers
WHERE CreditLimit >= 75000;


-- Range Queries
-- High-value orders (100000 and above)
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount >= 100000;

-- Quality products (rating >= 4.5)
SELECT 
  ProductName, 
  Rating
FROM Products
WHERE Rating >= 4.5;

-- Results:
-- Laptop: 75000 (doesn't meet criteria)
-- This demonstrates >= vs >


-- Date Ranges
-- Orders from Jan 1, 2024 onwards
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate >= '2024-01-01';

-- Year-to-date sales (Jan 1 to today)
SELECT 
  SUM(TotalAmount) AS YTDSales
FROM Orders
WHERE OrderDate >= '2024-01-01';


-- Boundary Detection
-- Find records AT or ABOVE threshold
SELECT 
    ProductName,
    Price,
    CASE 
        WHEN Price >= 25000 THEN 'Premium'
        WHEN Price >= 5000 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS PriceCategory
FROM Products;


6️⃣ LESS THAN OR EQUAL (<=)
-- Basic Usage
-- Cheap products (5000 or less)
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price <= 5000;

-- Small orders (30000 or less)
SELECT 
  OrderID, 
  TotalAmount
FROM Orders
WHERE TotalAmount <= 30000;

-- Customers with limited credit
SELECT 
  CustomerName, 
  CreditLimit
FROM Customers
WHERE CreditLimit <= 50000;


-- Date Ranges (Inclusive)
-- Orders up to Feb 28, 2024
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate <= '2024-02-28';

-- Legacy data (before 2024)
SELECT * 
FROM Orders
WHERE OrderDate <= '2023-12-31';

-- Data within specific time window
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate >= '2024-01-01' AND OrderDate <= '2024-02-28';


-- Inventory Checks
-- Low stock alert (100 units or less)
SELECT 
  ProductName, 
  Stock, 
  Price
FROM Products
WHERE Stock <= 100
ORDER BY Stock;

-- Products expiring soon
SELECT 
  ProductName, 
  ExpiryDate
FROM Products
WHERE ExpiryDate <= DATEADD(DAY, 30, GETDATE());


🔀 COMBINING COMPARISON OPERATORS
-- AND Logic (Both conditions true)
-- Mid-range products: Price between 5000-25000
SELECT 
  ProductName, Price
FROM Products
WHERE Price >= 5000 AND Price <= 25000;

-- Orders in Q1 2024
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate >= '2024-01-01' 
  AND OrderDate <= '2024-03-31';

-- Specific customer's completed orders over 50000
SELECT OrderID, 
  TotalAmount
FROM Orders
WHERE CustomerID = 1
  AND OrderStatus = 'Completed'
  AND TotalAmount > 50000;


-- OR Logic (Any condition true)
-- High-value or pending orders
SELECT 
  OrderID, 
  TotalAmount, 
  OrderStatus
FROM Orders
WHERE TotalAmount > 100000
  OR OrderStatus = 'Pending';

-- Premium or mid-range products
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price >= 25000 OR Price >= 5000 AND Price < 25000;

-- VIP customers (high credit limit OR high spending)
SELECT DISTINCT 
  c.CustomerName, 
  c.CreditLimit
FROM Customers c
WHERE CreditLimit > 80000
  OR EXISTS (
      SELECT 1 FROM Orders o
      WHERE o.CustomerID = c.CustomerID
      AND o.TotalAmount > 100000
  );


-- Negation (NOT)
-- NOT expensive
SELECT 
  ProductName, 
  Price
FROM Products
WHERE NOT (Price > 25000);
-- Equivalent to: Price <= 25000

-- NOT completed AND NOT pending
SELECT 
  OrderID, 
  OrderStatus
FROM Orders
WHERE NOT (OrderStatus = 'Completed' OR OrderStatus = 'Pending');
-- Equivalent to: OrderStatus NOT IN ('Completed', 'Pending')


🔢 DATA TYPE CONSIDERATIONS
-- Implicit Conversion
-- String to number comparison (SQL Server auto-converts)
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > '5000'; -- String '5000' converted to 5000

-- ❌ Be careful with this - can cause performance issues
-- SQL Server has to CONVERT each value, disabling index use

-- ✅ Better: Explicit matching data type
SELECT 
  ProductName, 
  Price
FROM Products
WHERE Price > 5000; -- Direct comparison, uses index


-- Date Conversion
-- String to date
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate > '2024-01-15'; -- Converted to DATE

-- With time component
SELECT 
  OrderID, OrderDate
FROM Orders
WHERE OrderDate > '2024-01-15 10:30:00'; -- Datetime precision

-- Better: Use CAST for clarity
SELECT 
  OrderID, 
  OrderDate
FROM Orders
WHERE OrderDate > CAST('2024-01-15' AS DATE);


-- VARCHAR vs INT Comparison
-- ❌ PROBLEM: Comparing VARCHAR to INT
SELECT * 
FROM Orders
WHERE TotalAmount = '50000'; -- Auto-conversion, slow

-- ✅ SOLUTION: Match data types
SELECT * 
FROM Orders
WHERE TotalAmount = 50000; -- Direct comparison, fast


📊 REAL-WORLD SCENARIOS
1. Price Tier Analysis
SELECT 
    ProductName,
    Price,
    CASE 
        WHEN Price > 50000 THEN 'Tier 1 - Premium'
        WHEN Price > 10000 THEN 'Tier 2 - Mid-Range'
        WHEN Price > 1000 THEN 'Tier 3 - Standard'
        ELSE 'Tier 4 - Budget'
    END AS PriceTier,
    CASE
        WHEN Price > 50000 THEN 1
        WHEN Price > 10000 THEN 2
        WHEN Price > 1000 THEN 3
        ELSE 4
    END AS TierNumber
FROM Products
ORDER BY TierNumber;

-- Result:
-- Laptop     | 75000  | Tier 1 | 1
-- Monitor    | 25000  | Tier 2 | 2
-- Keyboard   | 3500   | Tier 3 | 3
-- Mouse      | 1200   | Tier 3 | 3
-- Headphones | 5500   | Tier 2 | 2


2. Customer Segmentation
SELECT 
    c.CustomerName,
    SUM(o.TotalAmount) AS TotalSpent,
    COUNT(o.OrderID) AS OrderCount,
    CASE
        WHEN SUM(o.TotalAmount) > 100000 THEN 'Platinum'
        WHEN SUM(o.TotalAmount) > 50000 THEN 'Gold'
        WHEN SUM(o.TotalAmount) > 25000 THEN 'Silver'
        ELSE 'Bronze'
    END AS CustomerSegment
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 0
ORDER BY TotalSpent DESC;


3. Inventory Management
SELECT 
    ProductName,
    Stock,
    CASE
        WHEN Stock > 200 THEN 'Overstock - Reduce Order'
        WHEN Stock >= 100 THEN 'Optimal - No Action'
        WHEN Stock > 50 THEN 'Low Stock - Monitor'
        WHEN Stock > 0 THEN 'Critical - Reorder Now'
        ELSE 'Out of Stock'
    END AS StockStatus
FROM Products
ORDER BY Stock ASC;


4. Order Status Analysis
SELECT 
    CASE
        WHEN OrderStatus = 'Completed' THEN 'Fulfilled'
        WHEN OrderStatus = 'Processing' THEN 'In Progress'
        WHEN OrderStatus = 'Pending' THEN 'Awaiting Processing'
        ELSE 'Other'
    END AS OrderPhase,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TotalAmount) AS AvgOrderValue
FROM Orders
GROUP BY CASE
    WHEN OrderStatus = 'Completed' THEN 'Fulfilled'
    WHEN OrderStatus = 'Processing' THEN 'In Progress'
    WHEN OrderStatus = 'Pending' THEN 'Awaiting Processing'
    ELSE 'Other'
END;


5. Time-based Analysis
SELECT 
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysOld,
    CASE
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) < 7 THEN 'This Week'
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) < 30 THEN 'This Month'
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) < 90 THEN 'This Quarter'
        ELSE 'Older'
    END AS AgeCategory
FROM Orders
ORDER BY OrderDate DESC;


⚡ PERFORMANCE OPTIMIZATION
Index Usage
-- ✅ FAST: Direct comparison on indexed column
SELECT * 
FROM Orders
WHERE OrderDate >= '2024-01-01'
  AND OrderDate < '2024-02-01';
-- Uses index on OrderDate, very fast

-- ❌ SLOW: Function on indexed column
SELECT * 
FROM Orders
WHERE YEAR(OrderDate) = 2024;
-- Can't use index because of YEAR() function
-- Table scan required

-- ❌ SLOW: Implicit conversion
SELECT * 
FROM Orders
WHERE TotalAmount = '50000'; -- String compared to DECIMAL
-- Index not used due to type mismatch


--Query Execution Plans
-- Enable execution plan (Ctrl+L in SSMS)
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT * FROM Orders
WHERE TotalAmount > 50000;

-- Check output - should show "Index Seek" if optimized
-- Avoid "Table Scan" in large tables


Best Practices
-- ✅ Use range queries instead of functions
SELECT * 
FROM Orders
WHERE OrderDate >= '2024-01-01' AND OrderDate < '2024-02-01';

-- ✅ Match data types exactly
SELECT * 
FROM Orders WHERE TotalAmount > 50000; -- DECIMAL = DECIMAL

-- ✅ Use SARGable queries (Search Argument Able)
SELECT * 
FROM Products WHERE Price * 1.1 > 50000; -- ❌ NOT SARGable
SELECT * 
FROM Products WHERE Price > (50000 / 1.1); -- ✅ SARGable

-- ✅ Avoid OR with non-indexed columns
SELECT * 
FROM Orders
WHERE OrderStatus = 'Completed' OR OrderStatus = 'Pending';

-- Better: Use IN
SELECT * 
FROM Orders
WHERE OrderStatus IN ('Completed', 'Pending');


🐛 COMMON MISTAKES
Mistake 1: Comparing with NULL
-- ❌ WRONG - Returns NO rows
SELECT * 
FROM Orders WHERE OrderStatus = NULL;

-- ✅ CORRECT
SELECT * 
FROM Orders WHERE OrderStatus IS NULL;


Mistake 2: String vs Numeric
-- ❌ WRONG - Implicit conversion, slow
SELECT * 
FROM Orders WHERE TotalAmount = '50000';

-- ✅ CORRECT
SELECT * 
FROM Orders WHERE TotalAmount = 50000;


Mistake 3: Date Comparison with Time
-- ❌ PROBLEM - May miss records
SELECT * 
FROM Orders WHERE OrderDate = '2024-01-15';
-- Only gets midnight (00:00:00), misses 10:30 PM entries

-- ✅ SOLUTION - Use date range
SELECT * 
FROM Orders
WHERE OrderDate >= '2024-01-15' 
  AND OrderDate < '2024-01-16';

-- ✅ ALTERNATIVE - Use CAST
SELECT * 
FROM Orders
WHERE CAST(OrderDate AS DATE) = '2024-01-15';


Mistake 4: Case Sensitivity
-- SQL Server by default is case-INSENSITIVE
SELECT * 
FROM Customers WHERE Country = 'india'; -- Works
SELECT * 
FROM Customers WHERE Country = 'INDIA'; -- Also works

-- But some collations are case-sensitive
-- To force case-sensitivity:
SELECT * 
FROM Customers
WHERE Country COLLATE SQL_Latin1_General_CP1_CS_AS = 'india';


Mistake 5: Logical Operator Precedence
-- ❌ WRONG interpretation
SELECT * 
FROM Orders
WHERE OrderStatus = 'Completed' 
  OR OrderStatus = 'Pending'
  AND TotalAmount > 50000;
-- This actually means:
-- (OrderStatus = 'Completed') OR (OrderStatus = 'Pending' AND TotalAmount > 50000)

-- ✅ CORRECT - Use parentheses
SELECT * 
FROM Orders
WHERE (OrderStatus = 'Completed' OR OrderStatus = 'Pending')
  AND TotalAmount > 50000;


🚀 ADVANCED: Window Functions with Comparisons
-- Rank customers by spending
SELECT 
    CustomerID,
    CustomerName,
    TotalSpent,
    RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank,
    CASE
        WHEN RANK() OVER (ORDER BY TotalSpent DESC) = 1 THEN 'Top Spender'
        WHEN RANK() OVER (ORDER BY TotalSpent DESC) <= 5 THEN 'Top 5'
        WHEN RANK() OVER (ORDER BY TotalSpent DESC) <= 10 THEN 'Top 10'
        ELSE 'Others'
    END AS Tier
FROM (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
) CustomerStats
WHERE TotalSpent > 0;

-- Compare current order with previous order
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalAmount,
    LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PrevOrderAmount,
    CASE
        WHEN TotalAmount > LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
        THEN 'Increased'
        WHEN TotalAmount < LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
        THEN 'Decreased'
        ELSE 'Same'
    END AS SpendingTrend
FROM Orders;


📚 QUICK REFERENCE: When to Use Each Operator
Use = when:
  • Finding exact matches
  • Filtering by ID
  • Checking specific status

Use != when:
  • Excluding a specific value
  • Finding "not this"
  
Use > when:
  • Range queries (lower bound, exclusive)
  • Finding "greater than"
  
Use < when:
  • Range queries (upper bound, exclusive)
  • Finding "less than"
  
Use >= when:
  • Range queries (lower bound, inclusive)
  • Thresholds
  
Use <= when:
  • Range queries (upper bound, inclusive)
  • Cut-off dates
  
Use BETWEEN when:
  • Range with both bounds
  • Cleaner than > AND <


Practice Queries (Try these!)
-- 1. Find all orders greater than customer's average spend
-- 2. Products cheaper than median price
-- 3. Customers registered between 2022-2024
-- 4. Orders with 30+ days delivery time
-- 5. High-value orders (>100K) from Q1 2024











