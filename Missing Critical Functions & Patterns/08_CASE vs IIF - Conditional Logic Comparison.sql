8️⃣ CASE vs IIF - Conditional Logic Comparison
CASE vs IIF Performance


-- Method 1: IIF (Simple, Concise)
SELECT 
    ProductName,
    Price,
    IIF(Price > 25000, 'Premium', 'Standard') AS Category,
    IIF(Stock < 50, 'Low Stock', IIF(Stock < 100, 'Medium', 'High')) AS StockLevel
FROM Products;

-- Method 2: CASE (Explicit, Better for Complex Logic)
SELECT 
    ProductName,
    Price,
    CASE 
        WHEN Price > 50000 THEN 'Ultra Premium'
        WHEN Price > 25000 THEN 'Premium'
        ELSE 'Standard'
    END AS Category,
    CASE 
        WHEN Stock < 50 THEN 'Low Stock'
        WHEN Stock < 100 THEN 'Medium'
        ELSE 'High'
    END AS StockLevel
FROM Products;

-- Performance: IIF slightly faster for simple binary conditions
-- CASE better for multiple conditions (readability + optimization)

-- Multi-condition example (CASE clearer)
SELECT 
    OrderID,
    TotalAmount,
    CASE 
        WHEN TotalAmount > 100000 AND OrderStatus = 'Completed' THEN 'Premium Completed'
        WHEN TotalAmount > 100000 AND OrderStatus = 'Processing' THEN 'Premium Processing'
        WHEN TotalAmount > 50000 THEN 'High Value'
        WHEN TotalAmount > 10000 THEN 'Medium'
        ELSE 'Small'
    END AS OrderCategory
FROM Orders;

















