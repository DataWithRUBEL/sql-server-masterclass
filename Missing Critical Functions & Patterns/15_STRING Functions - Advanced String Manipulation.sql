1️⃣5️⃣ STRING Functions - Advanced String Manipulation
CHARINDEX with Multiple Searches

-- Find second occurrence of character
DECLARE @Text NVARCHAR(100) = 'Data_Analysis_Skills';
DECLARE @SearchChar NVARCHAR(1) = '_';

SELECT 
    @Text AS Text,
    CHARINDEX(@SearchChar, @Text, 1) AS FirstOccurrence,
    CHARINDEX(@SearchChar, @Text, CHARINDEX(@SearchChar, @Text, 1) + 1) AS SecondOccurrence;

-- Extract text between delimiters
SELECT 
    Email,
    SUBSTRING(Email, 1, CHARINDEX('@', Email) - 1) AS Username,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS Domain
FROM Customers;

-- Find last occurrence
SELECT 
    ProductName,
    LEN(ProductName) - CHARINDEX('_', REVERSE(ProductName)) + 1 AS LastUnderscorePosition
FROM Products;










