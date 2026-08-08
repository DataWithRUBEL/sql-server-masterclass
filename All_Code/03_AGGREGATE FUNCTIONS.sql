🟢 LEVEL 3: AGGREGATE FUNCTIONS

-- COUNT: Rows count করে
SELECT 
  COUNT(*) AS TotalCustomers 
FROM Customers;

SELECT 
  COUNT(DISTINCT Country) AS UniqueCountries 
FROM Customers;

-- SUM: Values add করে
SELECT 
  SUM(TotalAmount) AS TotalRevenue 
FROM Orders;
SELECT 
  SUM(Stock) AS TotalInventory 
FROM Products;

-- AVG: Average calculate করে
SELECT AVG(Price) AS AvgProductPrice 
FROM Products;
SELECT AVG(TotalAmount) AS AvgOrderValue 
FROM Orders;

-- MIN/MAX: Minimum এবং Maximum value find করে
SELECT 
      MIN(Price) AS CheapestProduct, 
      MAX(Price) AS MostExpensive 
FROM Products;
SELECT 
  MIN(OrderDate) AS FirstOrder, 
  MAX(OrderDate) AS LatestOrder 
FROM Orders;

-- Combined aggregates
SELECT 
    COUNT(*) AS TotalOrders,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TotalAmount) AS AvgOrderValue,
    MIN(TotalAmount) AS SmallestOrder,
    MAX(TotalAmount) AS LargestOrder
FROM Orders;




















