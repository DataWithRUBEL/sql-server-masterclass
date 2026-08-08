3️⃣ PIVOT & UNPIVOT - Data Reshaping
PIVOT - Wide Format (Crosstab)

-- Sales by country and month (wide format)
SELECT 
    DATENAME(MONTH, o.OrderDate) AS Month,
    c.Country,
    SUM(o.TotalAmount) AS Sales
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY DATENAME(MONTH, o.OrderDate), MONTH(o.OrderDate), c.Country
ORDER BY MONTH(o.OrderDate);

-- Convert to PIVOT
SELECT 
    Month,
    [India] AS India_Sales,
    [Bangladesh] AS Bangladesh_Sales,
    [Pakistan] AS Pakistan_Sales,
    [UAE] AS UAE_Sales
FROM (
    SELECT 
        DATENAME(MONTH, o.OrderDate) AS Month,
        c.Country,
        SUM(o.TotalAmount) AS Sales
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    GROUP BY DATENAME(MONTH, o.OrderDate), c.Country
) SourceData
PIVOT (
    SUM(Sales)
    FOR Country IN ([India], [Bangladesh], [Pakistan], [UAE])
) PivotTable;

-- Multi-level PIVOT
SELECT 
    Year,
    [Electronics] AS Electronics,
    [Accessories] AS Accessories
FROM (
    SELECT 
        DATEPART(YEAR, o.OrderDate) AS Year,
        p.Category,
        COUNT(o.OrderID) AS OrderCount
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY DATEPART(YEAR, o.OrderDate), p.Category
) SourceData
PIVOT (
    SUM(OrderCount)
    FOR Category IN ([Electronics], [Accessories])
) PivotTable;








UNPIVOT - Long Format (Normalization)
-- Raw data in wide format
CREATE TABLE SalesWide (
    Quarter INT,
    Q1_Sales DECIMAL(10,2),
    Q2_Sales DECIMAL(10,2),
    Q3_Sales DECIMAL(10,2),
    Q4_Sales DECIMAL(10,2)
);

INSERT INTO SalesWide VALUES (2024, 100000, 120000, 110000, 150000);

-- Convert to UNPIVOT (long format)
SELECT 
    Quarter,
    QuarterName,
    Sales
FROM SalesWide
UNPIVOT (
    Sales FOR QuarterName IN (Q1_Sales, Q2_Sales, Q3_Sales, Q4_Sales)
) UnpivotedTable;

-- Result:
-- 2024 | Q1_Sales | 100000
-- 2024 | Q2_Sales | 120000
-- 2024 | Q3_Sales | 110000
-- 2024 | Q4_Sales | 150000

-- Practical: Normalize customer preferences
CREATE TABLE CustomerPreferencesWide (
    CustomerID INT,
    Preference_Email BIT,
    Preference_Phone BIT,
    Preference_SMS BIT,
    Preference_Whatsapp BIT
);

SELECT 
    CustomerID,
    PreferenceType,
    IsPreferred
FROM CustomerPreferencesWide
UNPIVOT (
    IsPreferred FOR PreferenceType IN (
        Preference_Email, 
        Preference_Phone, 
        Preference_SMS, 
        Preference_Whatsapp
    )
) NormalizedPreferences
WHERE IsPreferred = 1; -- Only preferred channels



















