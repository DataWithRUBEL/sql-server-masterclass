🟢 LEVEL 5: SET OPERATORS

✅ UNION (Combine + Remove Duplicates)


-- সব India customers + সব Bangladesh customers (unique)
SELECT 
  CustomerName, 
  Country 
FROM Customers 
WHERE Country = 'India'
UNION
SELECT 
  CustomerName, 
  Country 
FROM Customers 
WHERE Country = 'Bangladesh';


✅ UNION ALL (Combine + Keep Duplicates)
  -- Returns duplicates if same name appears twice
SELECT 
  CustomerName 
FROM Customers
UNION ALL
SELECT 
  CustomerName 
FROM Customers;


✅ INTERSECT (Only matching records)
-- Products ordered AND in stock
SELECT 
  ProductID 
  FROM OrderDetails
INTERSECT
SELECT 
  ProductID 
FROM Products 
WHERE Stock > 0;



✅ INTERSECT (Only matching records)
-- Products ordered AND in stock
SELECT 
  ProductID 
FROM OrderDetails
INTERSECT
SELECT 
ProductID 
FROM Products 
WHERE Stock > 0;



✅ EXCEPT (Left table rows NOT in right table)
-- Products never ordered
SELECT 
  ProductID 
FROM Products
EXCEPT
SELECT DISTINCT 
  ProductID 
FROM OrderDetails;


















