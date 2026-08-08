🔟 CAST vs CONVERT - Type Conversion Variants
Functional Differences


-- CAST (ANSI standard, simpler syntax)
SELECT 
    CAST(TotalAmount AS INT) AS AmountAsInt,
    CAST('2024-03-15' AS DATE) AS StringToDate,
    CAST(123 AS VARCHAR(10)) AS NumberToString
FROM Orders;

-- CONVERT (SQL Server specific, with style parameter for dates)
SELECT 
    CONVERT(INT, TotalAmount) AS AmountAsInt,
    CONVERT(DATE, '2024-03-15', 101) AS StringToDate, -- mm/dd/yyyy
    CONVERT(VARCHAR(10), OrderDate, 103) AS DateAsString -- dd/mm/yyyy
FROM Orders;

-- Style codes for CONVERT
-- 101: mm/dd/yyyy (USA)
-- 103: dd/mm/yyyy (Europe)
-- 111: yyyy/mm/dd (ISO)
-- 120: yyyy-mm-dd hh:mm:ss (ISO 8601)

-- Real-world: Formatted date output
SELECT 
    OrderDate,
    CONVERT(VARCHAR(10), OrderDate, 103) AS DateEU,        -- 15/03/2024
    CONVERT(VARCHAR(10), OrderDate, 101) AS DateUS,        -- 03/15/2024
    CONVERT(VARCHAR(20), OrderDate, 120) AS DateISO,       -- 2024-03-15 10:30:00
    CONVERT(VARCHAR(30), OrderDate, 'dd MMMM yyyy') AS DateReadable -- 15 March 2024
FROM Orders;

-- Performance: CAST slightly faster but CONVERT more versatile














