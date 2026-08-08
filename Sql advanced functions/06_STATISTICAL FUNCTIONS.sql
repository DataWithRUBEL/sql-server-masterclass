🔷 STATISTICAL FUNCTIONS
1. STDEV / STDEVP - Standard Deviation

What it does: Data  spread/variation measure 

-- Sample standard deviation (divide by N-1)
SELECT 
    AVG(Price) AS AvgPrice,
    STDEV(Price) AS SampleStdDev,
    STDEVP(Price) AS PopulationStdDev
FROM Products;

-- Price consistency analysis
SELECT 
    Category,
    COUNT(*) AS ProductCount,
    AVG(Price) AS AvgPrice,
    STDEV(Price) AS PriceVariation,
    CASE 
        WHEN STDEV(Price) < 5000 THEN 'Consistent'
        WHEN STDEV(Price) < 15000 THEN 'Moderate Variation'
        ELSE 'High Variation'
    END AS ConsistencyLevel
FROM Products
GROUP BY Category;

-- Outlier detection (prices beyond 2 standard deviations)
WITH PriceStats AS (
    SELECT 
        AVG(Price) AS AvgPrice,
        STDEV(Price) AS StdDev
    FROM Products
)
SELECT 
    p.ProductName,
    p.Price,
    ps.AvgPrice,
    ps.StdDev,
    (p.Price - ps.AvgPrice) / ps.StdDev AS ZScore,
    CASE 
        WHEN ABS((p.Price - ps.AvgPrice) / ps.StdDev) > 2 THEN 'Outlier'
        ELSE 'Normal'
    END AS IsOutlier
FROM Products p, PriceStats ps;







2. VAR / VARP - Variance
What it does: Standard deviation का square (variance)
-- Order amount variance
SELECT 
    DATEPART(YEAR, OrderDate) AS Year,
    DATEPART(MONTH, OrderDate) AS Month,
    COUNT(*) AS OrderCount,
    AVG(TotalAmount) AS AvgAmount,
    VAR(TotalAmount) AS SampleVariance,
    VARP(TotalAmount) AS PopulationVariance,
    SQRT(VAR(TotalAmount)) AS CalculatedStdDev
FROM Orders
GROUP BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate)
ORDER BY Year, Month;

-- Variability assessment
SELECT 
    CustomerID,
    COUNT(*) AS OrderCount,
    AVG(TotalAmount) AS AvgOrderValue,
    VAR(TotalAmount) AS OrderVariance,
    CASE
        WHEN VAR(TotalAmount) > 500000000 THEN 'Highly Variable'
        WHEN VAR(TotalAmount) > 100000000 THEN 'Moderate Variability'
        ELSE 'Consistent'
    END AS PurchasingPattern
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 2;
















