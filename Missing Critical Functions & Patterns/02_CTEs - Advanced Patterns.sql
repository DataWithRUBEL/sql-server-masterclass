2️⃣ CTEs - Advanced Patterns

Multi-level CTEs (Chained Dependencies)

-- CTE 1: Customer totals
-- CTE 2: Use CTE 1 results
-- CTE 3: Use CTE 2 results
WITH CustomerTotals AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        COUNT(o.OrderID) AS OrderCount,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
),
CustomerRanks AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingRank,
        PERCENT_RANK() OVER (ORDER BY TotalSpent DESC) AS SpendingPercentile
    FROM CustomerTotals
    WHERE TotalSpent > 0
),
CustomerSegments AS (
    SELECT 
        *,
        CASE 
            WHEN SpendingRank <= 3 THEN 'Top Tier'
            WHEN SpendingPercentile <= 0.25 THEN 'Premium'
            WHEN SpendingPercentile <= 0.50 THEN 'Mid-tier'
            ELSE 'Standard'
        END AS Segment
    FROM CustomerRanks
)
SELECT * FROM CustomerSegments
ORDER BY SpendingRank;








Recursive CTE (Hierarchical Data)
-- Generate employee hierarchy
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    ManagerID INT,
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'CEO', NULL, 'Executive', 500000),
(2, 'VP Sales', 1, 'Sales', 250000),
(3, 'VP Engineering', 1, 'Engineering', 280000),
(4, 'Sales Manager', 2, 'Sales', 100000),
(5, 'Engineer', 3, 'Engineering', 80000);

-- Recursive CTE: Build hierarchy
WITH EmployeeHierarchy AS (
    -- Anchor: Start with CEO
    SELECT 
        EmployeeID,
        EmployeeName,
        ManagerID,
        Department,
        Salary,
        0 AS HierarchyLevel,
        CAST(EmployeeName AS NVARCHAR(MAX)) AS HierarchyPath
    FROM Employees
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive: Add subordinates
    SELECT 
        e.EmployeeID,
        e.EmployeeName,
        e.ManagerID,
        e.Department,
        e.Salary,
        eh.HierarchyLevel + 1,
        eh.HierarchyPath + ' -> ' + e.EmployeeName
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT 
    REPLICATE('  ', HierarchyLevel) + EmployeeName AS EmployeeTree,
    HierarchyLevel,
    Department,
    Salary,
    HierarchyPath
FROM EmployeeHierarchy
ORDER BY HierarchyPath;

-- Result shows hierarchical structure with indentation







Recursive CTE: Date Range Generation
-- Generate all dates in 2024
WITH DateSequence AS (
    SELECT CAST('2024-01-01' AS DATE) AS DateValue
    
    UNION ALL
    
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < '2024-12-31'
)
SELECT 
    DateValue,
    DATEPART(QUARTER, DateValue) AS Quarter,
    DATENAME(MONTH, DateValue) AS MonthName,
    DATEPART(WEEK, DateValue) AS WeekNumber
FROM DateSequence
OPTION (MAXRECURSION 366); -- Safety limit for recursion depth







Recursive CTE: Factorials & Complex Math
-- Calculate factorials using recursion
WITH FactorialCTE AS (
    SELECT 1 AS N, 1 AS Factorial
    
    UNION ALL
    
    SELECT N + 1, (N + 1) * Factorial
    FROM FactorialCTE
    WHERE N < 10
)
SELECT * FROM FactorialCTE
OPTION (MAXRECURSION 11);

-- Result:
-- 1 | 1
-- 2 | 2
-- 3 | 6
-- 4 | 24
-- 5 | 120


