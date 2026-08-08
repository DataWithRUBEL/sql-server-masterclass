🔷 ADVANCED STRING FUNCTIONS

1. CHARINDEX - String Position খুঁজে পাওয়া
What it does: একটি string কোথায় আছে সেটা find করে (position return করে)


-- Email থেকে domain extract করা
SELECT 
    Email,
    CHARINDEX('@', Email) AS AtSymbolPosition,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain
FROM Customers;



-- Case-insensitive search (by default)
SELECT 
    CustomerName,
    CHARINDEX('RUB', CustomerName) AS FoundAt -- 1 (case-insensitive)
FROM Customers
WHERE CustomerName = 'Rubel Islam';

-- Find first space in name
SELECT 
    CustomerName,
    SUBSTRING(CustomerName, 1, CHARINDEX(' ', CustomerName) - 1) AS FirstName,
    SUBSTRING(CustomerName, CHARINDEX(' ', CustomerName) + 1, LEN(CustomerName)) AS LastName
FROM Customers;


-- Practical: Extract product variant
SELECT 
    ProductName,
    CASE 
        WHEN CHARINDEX('-', ProductName) > 0 
        THEN SUBSTRING(ProductName, CHARINDEX('-', ProductName) + 1, LEN(ProductName))
        ELSE 'No Variant'
    END AS Variant
FROM Products;






2. PATINDEX - Pattern Matching (Wildcards)
What it does: CHARINDEX এর advanced version, wildcards support করে
-- Product names starting with 'M'
SELECT 
    ProductName,
    PATINDEX('M%', ProductName) AS MatchesPattern
FROM Products
WHERE PATINDEX('M%', ProductName) > 0;

-- Result shows 1 (found at position 1) for Mouse, Monitor

-- Find numbers in product name
SELECT 
    ProductName,
    PATINDEX('%[0-9]%', ProductName) AS HasNumber
FROM Products
WHERE PATINDEX('%[0-9]%', ProductName) > 0;

-- Extract email domain pattern
SELECT 
    Email,
    SUBSTRING(Email, 1, PATINDEX('%@%', Email) - 1) AS Username,
    SUBSTRING(Email, PATINDEX('%@%', Email) + 1, LEN(Email)) AS Domain
FROM Customers;

-- Validate email format
SELECT 
    Email,
    CASE 
        WHEN PATINDEX('%[a-z]%@%[a-z]%.%[a-z]%', LOWER(Email)) > 0
        THEN 'Valid Format'
        ELSE 'Invalid Format'
    END AS EmailValidation
FROM Customers;






3. STUFF - Insert/Replace String
What it does: String এর মধ্যে একটি অংশ delete করে নতুন string insert করে
-- Phone number formatting
SELECT 
    CustomerID,
    '1234567890' AS RawPhone,
    STUFF('1234567890', 4, 0, '-') AS Step1,
    STUFF(STUFF('1234567890', 4, 0, '-'), 8, 0, '-') AS FormattedPhone;

-- Result: 123-456-7890

-- Practical: Format customer contact
SELECT 
    CustomerName,
    '9876543210' AS PhoneRaw,
    STUFF(STUFF('9876543210', 1, 0, '+91-'), 13, 0, '') AS FormattedPhone
FROM Customers
LIMIT 2;

-- Credit card masking (Security)
SELECT 
    CustomerID,
    '1234567890123456' AS CardNumber,
    STUFF('1234567890123456', 1, 12, 'XXXX-XXXX-XXXX-') AS MaskedCard;

-- Result: XXXX-XXXX-XXXX-3456

-- Product code generation
SELECT 
    ProductID,
    ProductName,
    STUFF(CONVERT(VARCHAR, ProductID), 1, 0, 'PROD-') AS ProductCode,
    STUFF(STUFF(CONVERT(VARCHAR, ProductID), 1, 0, 'PROD-'), 10, 0, '-' + LEFT(Category, 3)) AS FullProductCode
FROM Products;

-- Result: PROD-1-ELE, PROD-2-ACC







4. REVERSE - String Reverse করা
What it does: String টা উল্টো করে দেয়
-- Check if name is palindrome
SELECT 
    CustomerName,
    REVERSE(CustomerName) AS ReversedName,
    CASE 
        WHEN LOWER(CustomerName) = LOWER(REVERSE(CustomerName))
        THEN 'Palindrome'
        ELSE 'Not Palindrome'
    END AS IsPalindrome
FROM Customers;

-- Extract last N characters
SELECT 
    Email,
    SUBSTRING(REVERSE(Email), 1, 8) AS ReversedDomain,
    SUBSTRING(Email, LEN(Email) - 7, 8) AS LastEightChars
FROM Customers;

-- Useful for: Data validation, pattern detection
SELECT 
    ProductName,
    REVERSE(ProductName) AS BackwardsName
FROM Products;






5. REPLICATE - String Repeat করা
What it does: String কে N বার repeat করে
-- Report formatting
SELECT 
    ProductName,
    REPLICATE('*', 10) AS Rating10,
    REPLICATE('*', CAST(ROUND(Price / 10000, 0) AS INT)) AS PriceVisual
FROM Products;

-- Result:
-- Mouse | ********** | *
-- Keyboard | ********** | (blank)
-- Laptop | ********** | *******

-- Generate separator lines
SELECT 
    'Order Report',
    REPLICATE('-', 50) AS Separator;

-- CSV generation with padding
SELECT 
    CONCAT(
        CustomerID,
        REPLICATE(',', 3),
        CustomerName,
        REPLICATE(',', 3),
        Country
    ) AS CSVLine
FROM Customers;








6. SPACE - Space Characters যুক্ত করা
What it does: Specified number of spaces return করে
-- Pretty printing reports
SELECT 
    'Customer ID:' + SPACE(5) + CAST(CustomerID AS VARCHAR),
    'Name:' + SPACE(10) + CustomerName,
    'Country:' + SPACE(5) + Country
FROM Customers LIMIT 1;

-- Formatted output
SELECT 
    CustomerName + SPACE(20) AS NameColumn,
    Country + SPACE(15) AS CountryColumn,
    CAST(CreditLimit AS VARCHAR) AS CreditLimit
FROM Customers;








7. TRANSLATE - Multiple Character Replacement
What it does: Multiple characters একসাথে replace করে (SQL Server 2017+)
-- Phone number cleaning (remove dashes, spaces, parentheses)
SELECT 
    '(123) 456-7890' AS PhoneRaw,
    TRANSLATE('(123) 456-7890', '()- ', '') AS PhoneClean;

-- Result: 1234567890

-- Remove special characters from product names
SELECT 
    ProductName,
    TRANSLATE(ProductName, '!@#$%^&*()[]{}', '') AS CleanedName
FROM Products;

-- Email normalization
SELECT 
    Email,
    LOWER(TRANSLATE(Email, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')) AS NormalizedEmail
FROM Customers;

-- Currency formatting
SELECT 
    CAST(TotalAmount AS VARCHAR) AS Amount,
    TRANSLATE(CAST(TotalAmount AS VARCHAR), '.,', '.,') AS Formatted
FROM Orders;














