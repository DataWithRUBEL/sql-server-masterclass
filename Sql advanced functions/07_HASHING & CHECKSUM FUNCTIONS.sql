🔷 HASHING & CHECKSUM FUNCTIONS
1. HASHBYTES - Data Hashing (Security)

What it does: Sensitive data को hash करता है (encryption नहीं, one-way)

-- Hash email for privacy
SELECT 
    CustomerID,
    Email,
    HASHBYTES('SHA2_256', Email) AS EmailHash,
    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', Email), 2) AS EmailHashHex
FROM Customers;

-- Detect duplicate emails (compare hashes)
SELECT 
    Email,
    HASHBYTES('SHA2_256', Email) AS EmailHash,
    COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Email, HASHBYTES('SHA2_256', Email)
HAVING COUNT(*) > 1;

-- De-identify customer data
SELECT 
    HASHBYTES('SHA2_256', CAST(CustomerID AS VARCHAR)) AS CustomerKey,
    HASHBYTES('SHA2_256', CustomerName) AS NameHash,
    Country
FROM Customers
WHERE HASHBYTES('SHA2_256', Email) = HASHBYTES('SHA2_256', 'rahul@email.com');

-- Different hash algorithms
SELECT 
    'SampleText' AS Text,
    HASHBYTES('MD5', 'SampleText') AS MD5Hash,
    HASHBYTES('SHA1', 'SampleText') AS SHA1Hash,
    HASHBYTES('SHA2_256', 'SampleText') AS SHA256Hash,
    HASHBYTES('SHA2_512', 'SampleText') AS SHA512Hash;






2. CHECKSUM_AGG - Row-level Change Detection
What it does: Rows का collective checksum (detect changes)
-- Track data changes
SELECT 
    CHECKSUM_AGG(CHECKSUM(*)) AS DataChecksum
FROM Products;

-- Detect if products changed
DECLARE @OldChecksum BIGINT = (SELECT CHECKSUM_AGG(CHECKSUM(*)) FROM Products);
-- ... wait some time or make changes ...
DECLARE @NewChecksum BIGINT = (SELECT CHECKSUM_AGG(CHECKSUM(*)) FROM Products);

SELECT 
    CASE WHEN @OldChecksum = @NewChecksum THEN 'No Changes' ELSE 'Data Changed' END AS ChangeStatus;

-- Find modified records between audits
CREATE TABLE ProductAudit (
    AuditID INT IDENTITY,
    ProductID INT,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2),
    RecordChecksum INT,
    AuditDate DATETIME
);

INSERT INTO ProductAudit (ProductID, ProductName, Price, RecordChecksum, AuditDate)
SELECT ProductID, ProductName, Price, CHECKSUM(ProductID, ProductName, Price), GETDATE()
FROM Products;

-- Detect changes
SELECT 
    p.ProductID,
    p.ProductName,
    p.Price,
    pa.Price AS OldPrice,
    CASE WHEN CHECKSUM(p.ProductID, p.ProductName, p.Price) != pa.RecordChecksum 
         THEN 'Modified' ELSE 'Unchanged' END AS Status
FROM Products p
JOIN ProductAudit pa ON p.ProductID = pa.ProductID;






