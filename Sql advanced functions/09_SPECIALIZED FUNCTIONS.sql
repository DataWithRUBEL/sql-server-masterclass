🔷 SPECIALIZED FUNCTIONS
1. CURRENT_USER / SESSION_USER / SYSTEM_USER - User Information

-- Track who is executing query
SELECT 
    CURRENT_USER AS CurrentUser,
    SESSION_USER AS SessionUser,
    SYSTEM_USER AS SystemUser,
    GETDATE() AS ExecutionTime;

-- Audit trail
INSERT INTO QueryAuditLog (ExecutedBy, ExecutedTime, QueryType)
VALUES (CURRENT_USER, GETDATE(), 'SELECT');

-- User-based filtering
SELECT * FROM Orders
WHERE SUSER_NAME() = 'sa'; -- Only if system admin






2. SOUNDEX / DIFFERENCE - Phonetic Matching
What it does: Similar sounding names find
-- Find similar customer names (phonetic)
SELECT 
    CustomerID,
    CustomerName,
    SOUNDEX(CustomerName) AS SoundexCode
FROM Customers;

-- Match similar names
SELECT 
    c1.CustomerName,
    c2.CustomerName,
    DIFFERENCE(c1.CustomerName, c2.CustomerName) AS SimilarityScore
FROM Customers c1
JOIN Customers c2 ON c1.CustomerID < c2.CustomerID
WHERE SOUNDEX(c1.CustomerName) = SOUNDEX(c2.CustomerName);

-- Typo correction
SELECT 
    CustomerName,
    'Rahul' AS SearchTerm,
    SOUNDEX(CustomerName) AS ActualSoundex,
    SOUNDEX('Rubel') AS SearchSoundex,
    DIFFERENCE(CustomerName, 'Rubel') AS MatchingScore
FROM Customers
WHERE SOUNDEX(CustomerName) = SOUNDEX('Rubel');










