🟢 LEVEL 7: CASE EXPRESSION

-- Simple CASE (Compare single value)
SELECT 
    ProductName,
    Price,
    CASE Price
        WHEN 75000 THEN 'Premium'
        WHEN 25000 THEN 'MidRange'
        ELSE 'Budget'
    END AS PriceCategory
FROM Products;

-- Searched CASE (Multiple conditions)
SELECT 
    CustomerName,
    CreditLimit,
    CASE 
        WHEN CreditLimit >= 80000 THEN 'Gold'
        WHEN CreditLimit >= 60000 THEN 'Silver'
        WHEN CreditLimit >= 40000 THEN 'Bronze'
        ELSE 'Standard'
    END AS CustomerTier
FROM Customers;

-- Nested CASE
SELECT 
    OrderID,
    OrderStatus,
    TotalAmount,
    CASE OrderStatus
        WHEN 'Completed' THEN 
            CASE 
                WHEN TotalAmount > 50000 THEN 'High Value Completed'
                ELSE 'Normal Completed'
            END
        WHEN 'Pending' THEN 'Awaiting Processing'
        ELSE 'In Progress'
    END AS StatusCategory
FROM Orders;

-- CASE for conditional calculations
SELECT 
    OrderID,
    TotalAmount,
    CASE 
        WHEN TotalAmount > 100000 THEN TotalAmount * 0.15 -- 15% discount
        WHEN TotalAmount > 50000 THEN TotalAmount * 0.10  -- 10% discount
        ELSE TotalAmount * 0.05                            -- 5% discount
    END AS DiscountAmount
FROM Orders;

