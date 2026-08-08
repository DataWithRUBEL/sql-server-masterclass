1️⃣4️⃣ Temp Tables vs Table Variables vs CTEs
Performance & Usage Comparison



-- Option 1: Temp Table (Physical table in tempdb)
CREATE TABLE #TempOrders (
    OrderID INT,
    CustomerID INT,
    TotalAmount DECIMAL(10,2),
    OrderDate DATE
);

INSERT INTO #TempOrders
SELECT OrderID, CustomerID, TotalAmount, OrderDate FROM Orders WHERE YEAR(OrderDate) = 2024;

SELECT * FROM #TempOrders WHERE TotalAmount > 50000;
DROP TABLE #TempOrders;

-- Option 2: Table Variable (Memory-based)
DECLARE @OrdersVar TABLE (
    OrderID INT,
    CustomerID INT,
    TotalAmount DECIMAL(10,2),
    OrderDate DATE
);

INSERT INTO @OrdersVar
SELECT OrderID, CustomerID, TotalAmount, OrderDate FROM Orders WHERE YEAR(OrderDate) = 2024;

SELECT * FROM @OrdersVar WHERE TotalAmount > 50000;

-- Option 3: CTE (No physical storage)
WITH RecentOrders AS (
    SELECT OrderID, CustomerID, TotalAmount, OrderDate
    FROM Orders
    WHERE YEAR(OrderDate) = 2024
)
SELECT * FROM RecentOrders WHERE TotalAmount > 50000;

-- Comparison:
-- Temp Table: Best for large datasets, index support, stats updates
-- Table Variable: Best for small-medium data, memory-efficient
-- CTE: Best for readability, recursion support, limited reuse within query






















