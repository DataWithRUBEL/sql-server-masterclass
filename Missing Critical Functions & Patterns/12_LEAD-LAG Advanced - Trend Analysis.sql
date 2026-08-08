1️⃣2️⃣ LEAD/LAG Advanced - Trend Analysis
Growth Rate Calculations

-- Month-over-month growth
SELECT 
    DATEPART(YEAR, OrderDate) AS Year,
    DATEPART(MONTH, OrderDate) AS Month,
    DATENAME(MONTH, OrderDate) AS MonthName,
    SUM(TotalAmount) AS MonthlySales,
    LAG(SUM(TotalAmount)) OVER (ORDER BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate)) AS PreviousMonthSales,
    SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate)) AS MoMChange,
    CAST(100.0 * (SUM(TotalAmount) - LAG(SUM(TotalAmount)) OVER (ORDER BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate))) / 
        LAG(SUM(TotalAmount)) OVER (ORDER BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate)) AS DECIMAL(5,2)) AS MoMGrowthPercent
FROM Orders
GROUP BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate), DATENAME(MONTH, OrderDate)
ORDER BY Year, Month;

-- Customer repeat purchase analysis
SELECT 
    CustomerID,
    OrderID,
    OrderDate,
    TotalAmount,
    LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PreviousOrderDate,
    DATEDIFF(DAY, LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) AS DaysBetweenOrders,
    CASE 
        WHEN DATEDIFF(DAY, LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) IS NULL THEN 'First Order'
        WHEN DATEDIFF(DAY, LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) < 30 THEN 'Within 1 Month'
        WHEN DATEDIFF(DAY, LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate), OrderDate) < 90 THEN 'Within 3 Months'
        ELSE 'After 3 Months'
    END AS RepeatBehavior
FROM Orders
ORDER BY CustomerID, OrderDate;

























