🔷 ADVANCED NUMBER/MATHEMATICAL FUNCTIONS

1. LOG / LOG10 / EXP - Logarithmic Functions
What it does: Mathematical calculations for data analysis
-- Price elasticity analysis (log-based)
SELECT 
    ProductName,
    Price,
    CAST(COUNT(*) AS DECIMAL) AS QuantitySold,
    LOG(Price) AS LogPrice,
    LOG(COUNT(*)) AS LogQuantity,
    LOG(Price) / LOG(COUNT(*)) AS ElasticityRatio
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Price;

-- Growth rate calculation (compound growth)
SELECT 
    OrderDate,
    TotalAmount,
    LAG(TotalAmount) OVER (ORDER BY OrderDate) AS PreviousAmount,
    CASE 
        WHEN LAG(TotalAmount) OVER (ORDER BY OrderDate) > 0
        THEN EXP(LOG(TotalAmount / LAG(TotalAmount) OVER (ORDER BY OrderDate)) / 12) - 1
        ELSE 0
    END AS MonthlyGrowthRate
FROM Orders
ORDER BY OrderDate;

-- Benford's Law analysis (fraud detection)
SELECT 
    LEFT(CAST(TotalAmount AS VARCHAR), 1) AS FirstDigit,
    LOG10(1 + 1.0 / CAST(LEFT(CAST(TotalAmount AS VARCHAR), 1) AS DECIMAL)) AS BenfordsLawProbability,
    COUNT(*) AS ActualCount,
    CAST(COUNT(*) AS DECIMAL) / (SELECT COUNT(*) FROM Orders) AS ActualProbability
FROM Orders
GROUP BY LEFT(CAST(TotalAmount AS VARCHAR), 1)
ORDER BY FirstDigit;






2. SQUARE / SQRT / POWER - Geometric Calculations
What it does: Mathematical operations
-- Distance calculation (2D space)
SELECT 
    ProductID,
    Price,
    Stock,
    SQRT(SQUARE(Price - 25000) + SQUARE(Stock - 150)) AS Distance
FROM Products;

-- Pythagorean theorem example
SELECT 
    SQRT(SQUARE(3) + SQUARE(4)) AS Hypotenuse;
-- Result: 5

-- Statistical variance and standard deviation prep
SELECT 
    ProductName,
    Price,
    AVG(Price) OVER () AS AvgPrice,
    SQUARE(Price - AVG(Price) OVER ()) AS SquaredDeviation
FROM Products;








3. DEGREES / RADIANS / Trigonometric Functions
What it does: Angle conversions and trigonometry
-- Angle calculations
SELECT 
    45 AS DegreeAngle,
    RADIANS(45) AS RadianValue,
    DEGREES(RADIANS(45)) AS BackToDegrees,
    SIN(RADIANS(45)) AS SineValue,
    COS(RADIANS(45)) AS CosineValue,
    TAN(RADIANS(45)) AS TangentValue;

-- Navigation/mapping calculations
SELECT 
    OrderID,
    CustomerID,
    RADIANS(CAST(ProductID AS DECIMAL) * 10) AS LocationAngle,
    ROUND(SIN(RADIANS(CAST(ProductID AS DECIMAL) * 10)), 3) AS LatitudeComponent,
    ROUND(COS(RADIANS(CAST(ProductID AS DECIMAL) * 10)), 3) AS LongitudeComponent
FROM Orders;

-- Circular statistics
SELECT 
    AVG(RADIANS(CAST(ProductID AS DECIMAL) * 10)) AS AvgAngle,
    DEGREES(AVG(RADIANS(CAST(ProductID AS DECIMAL) * 10))) AS AvgAngleDegrees
FROM Orders;








4. SIGN - Number Sign Detection
What it does: -1, 0, or 1 return করে based on sign
-- Profit/Loss detection
SELECT 
    OrderID,
    TotalAmount,
    TotalAmount - 50000 AS ProfitLoss,
    CASE SIGN(TotalAmount - 50000)
        WHEN 1 THEN 'Profit'
        WHEN -1 THEN 'Loss'
        WHEN 0 THEN 'Break-even'
    END AS Result
FROM Orders;

-- Growth direction
SELECT 
    CustomerID,
    TotalAmount,
    LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousAmount,
    SIGN(TotalAmount - LAG(TotalAmount) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS GrowthDirection
FROM Orders;




