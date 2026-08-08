🔷 ADVANCED DATE FUNCTIONS
1. DATEFROMPARTS / DATETIMEFROMPARTS - Date Construct করা
What it does: Year, Month, Day থেকে date তৈরি করে 


-- Generate date from components
SELECT 
    DATEFROMPARTS(2024, 3, 15) AS ConstructedDate;

-- Result: 2024-03-15

-- Reconstruct date from existing columns
SELECT 
    CustomerID,
    RegistrationDate,
    DATEFROMPARTS(YEAR(RegistrationDate), 3, 15) AS BirthdayThisYear
FROM Customers;

-- Generate all dates in a range
WITH DateRange AS (
    SELECT 
  DATEFROMPARTS(2024, 1, 1) AS StartDate
)
SELECT 
    DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, StartDate) AS DateSequence
FROM DateRange
CROSS JOIN (SELECT TOP 365 * FROM (SELECT 1) AS t CROSS JOIN (SELECT TOP 365 * FROM (SELECT 1) AS x) AS x2) AS Numbers;

-- Quarterly date generation
SELECT 
    DATEFROMPARTS(2024, 1, 1) AS Q1Start,
    DATEFROMPARTS(2024, 4, 1) AS Q2Start,
    DATEFROMPARTS(2024, 7, 1) AS Q3Start,
    DATEFROMPARTS(2024, 10, 1) AS Q4Start;









2. SYSDATETIME vs GETDATE - Current DateTime
What it does: SYSDATETIME gives more precision

-- GETDATE returns datetime (accurate to 3.33ms)
SELECT GETDATE() AS CurrentDateTime;

-- SYSDATETIME returns datetime2 (accurate to 100ns)
SELECT SYSDATETIME() AS HighPrecisionTime;

-- Practical comparison
SELECT 
    GETDATE() AS StandardTime,
    SYSDATETIME() AS HighPrecisionTime,
    DATEDIFF(NANOSECOND, GETDATE(), SYSDATETIME()) AS NanosecondDifference;

-- Log entry timestamp (use SYSDATETIME for precision)
SELECT 
    OrderID,
    SYSDATETIME() AS ExactProcessedTime,
    'Order Processed' AS LogMessage
FROM Orders
WHERE OrderStatus = 'Pending';







3. EOMONTH - End of Month খুঁজে পাওয়া
What it does: Month এর last date return করে
-- Payment due date (End of next month)
SELECT 
    OrderID,
    OrderDate,
    EOMONTH(OrderDate) AS InvoiceDueDate,
    EOMONTH(OrderDate, 1) AS PaymentDueDate
FROM Orders;

-- Result:
-- 1 | 2024-01-10 | 2024-01-31 | 2024-02-29

-- Month-end sales report
SELECT 
    DATEPART(YEAR, OrderDate) AS Year,
    DATEPART(MONTH, OrderDate) AS Month,
    EOMONTH(OrderDate) AS MonthEnd,
    COUNT(*) AS OrdersCount,
    SUM(TotalAmount) AS MonthlyRevenue
FROM Orders
GROUP BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate), EOMONTH(OrderDate)
ORDER BY Year, Month;

-- Aged receivables (>30, >60, >90 days)
SELECT 
    OrderID,
    OrderDate,
    DATEDIFF(DAY, OrderDate, GETDATE()) AS DaysOverdue,
    CASE
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) > 90 THEN 'Critical'
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) > 60 THEN 'Urgent'
        WHEN DATEDIFF(DAY, OrderDate, GETDATE()) > 30 THEN 'Follow-up'
        ELSE 'Current'
    END AS AgingBucket
FROM Orders
WHERE OrderStatus != 'Completed'
ORDER BY DaysOverdue DESC;






4. GETUTCDATE - UTC Time
What it does: UTC timezone এ current date return করে
-- Server local time vs UTC
SELECT 
    GETDATE() AS LocalServerTime,
    GETUTCDATE() AS UTCTime,
    DATEDIFF(HOUR, GETUTCDATE(), GETDATE()) AS ServerTimezoneDifferenceHours;

-- Global order timestamp (use UTC)
SELECT 
    OrderID,
    GETUTCDATE() AS CreatedUTC,
    GETDATE() AS CreatedLocal
FROM Orders LIMIT 1;

-- Convert UTC to local
SELECT 
    GETUTCDATE() AS UTCTime,
    DATEADD(HOUR, 5, GETUTCDATE()) AS IndianStandardTime,
    DATEADD(HOUR, 8, GETUTCDATE()) AS BangladeshStandardTime;








5. DATEFIRST and DATEPART with Week
What it does: Week calculations with different start days
-- Get week number (ISO standard)
SELECT 
    OrderDate,
    DATEPART(WEEK, OrderDate) AS WeekNumber,
    DATEPART(ISOWK, OrderDate) AS ISOWeekNumber,
    DATENAME(WEEKDAY, OrderDate) AS DayOfWeek
FROM Orders;

-- Sales by week
SELECT 
    DATEPART(ISOWK, OrderDate) AS WeekNumber,
    DATEPART(YEAR, OrderDate) AS Year,
    SUM(TotalAmount) AS WeeklyRevenue,
    COUNT(*) AS OrderCount,
    AVG(TotalAmount) AS AvgOrderValue
FROM Orders
GROUP BY DATEPART(YEAR, OrderDate), DATEPART(ISOWK, OrderDate)
ORDER BY Year, WeekNumber;










