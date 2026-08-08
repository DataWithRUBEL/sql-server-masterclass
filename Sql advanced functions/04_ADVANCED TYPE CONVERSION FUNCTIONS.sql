🔷 ADVANCED TYPE CONVERSION FUNCTIONS
1. TRY_CAST / TRY_CONVERT - Safe Type Conversion

What it does: Conversion fail করলে NULL return করে instead of error


-- Safe number conversion
SELECT 
    '12345' AS StringValue,
    TRY_CAST('12345' AS INT) AS ConvertedInt,
    TRY_CAST('12345ABC' AS INT) AS InvalidConversion;
-- Result: 12345, 12345, NULL

-- Clean data import
SELECT 
    CustomerID,
    Email,
    TRY_CAST(Email AS VARCHAR(100)) AS SafeEmail,
    TRY_CAST(CreditLimit AS DECIMAL(10,2)) AS SafeCreditLimit
FROM Customers;

-- Data quality check
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN TRY_CAST(TotalAmount AS DECIMAL) IS NULL THEN 1 ELSE 0 END) AS InvalidAmounts,
    SUM(CASE WHEN TRY_CAST(OrderDate AS DATE) IS NULL THEN 1 ELSE 0 END) AS InvalidDates
FROM Orders;

-- Cleaning mixed data types
SELECT 
    ProductID,
    ISNULL(TRY_CAST(Stock AS INT), 0) AS CleanedStock,
    ISNULL(TRY_CAST(Price AS DECIMAL(10,2)), 0) AS CleanedPrice
FROM Products;





2. TRY_PARSE / PARSE - Culture-aware Parsing
What it does: Culture-specific number/date parsing

-- Parse with specific culture
SELECT 
    '12.34' AS GermanDecimal,
    TRY_PARSE('12.34' AS DECIMAL USING 'de-DE') AS ParsedGerman,
    TRY_PARSE('12.34' AS DECIMAL USING 'en-US') AS ParsedEnglish;

-- Date parsing with culture
SELECT 
    '25/03/2024' AS IndianDateFormat,
    TRY_PARSE('25/03/2024' AS DATE USING 'en-IN') AS ParsedIndian,
    TRY_PARSE('25/03/2024' AS DATE USING 'en-US') AS ParsedAmerican;

-- Multi-region data handling
SELECT 
    Email,
    TRY_PARSE(Email AS VARCHAR) AS SafeParse,
    CASE 
        WHEN TRY_PARSE(Email AS VARCHAR) IS NOT NULL THEN 'Valid'
        ELSE 'Invalid'
    END AS ValidationStatus
FROM Customers;





