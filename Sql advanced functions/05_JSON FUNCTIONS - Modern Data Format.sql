🔷 JSON FUNCTIONS - Modern Data Format
1. JSON_VALUE - Extract Scalar Value

What it does: JSON থেকে single value extract করে 

-- Extract from JSON string
DECLARE @json NVARCHAR(MAX) = N'{"CustomerID":1,"Name":"Rahul","Country":"India"}';

SELECT 
    JSON_VALUE(@json, '$.CustomerID') AS CustomerID,
    JSON_VALUE(@json, '$.Name') AS CustomerName,
    JSON_VALUE(@json, '$.Country') AS Country;

-- Store and query JSON data
CREATE TABLE CustomerProfiles (
    CustomerID INT,
    ProfileJSON NVARCHAR(MAX)
);

INSERT INTO CustomerProfiles VALUES 
(1, '{"Name":"Rahul Roy","Age":28,"City":"Delhi","Premium":true}'),
(2, '{"Name":"Priya Sharma","Age":32,"City":"Mumbai","Premium":false}');

SELECT 
    CustomerID,
    JSON_VALUE(ProfileJSON, '$.Name') AS Name,
    JSON_VALUE(ProfileJSON, '$.Age') AS Age,
    JSON_VALUE(ProfileJSON, '$.City') AS City,
    JSON_VALUE(ProfileJSON, '$.Premium') AS IsPremium
FROM CustomerProfiles;






2. JSON_QUERY - Extract Object/Array
What it does: JSON object বা array extract করে
-- Extract nested object
DECLARE @json NVARCHAR(MAX) = N'{
    "CustomerID":1,
    "Name":"Rahul",
    "Orders":[
        {"OrderID":1,"Amount":50000},
        {"OrderID":2,"Amount":75000}
    ]
}';

SELECT 
    JSON_VALUE(@json, '$.CustomerID') AS CustomerID,
    JSON_QUERY(@json, '$.Orders') AS OrdersList,
    JSON_QUERY(@json, '$.Orders[0]') AS FirstOrder;

-- Parse complex nested JSON
CREATE TABLE OrderRecords (
    RecordID INT,
    OrderJSON NVARCHAR(MAX)
);

INSERT INTO OrderRecords VALUES 
(1, N'{
    "OrderID":1,
    "Items":[
        {"ProductName":"Laptop","Quantity":1,"Price":75000},
        {"ProductName":"Mouse","Quantity":2,"Price":1200}
    ]
}');

SELECT 
    RecordID,
    JSON_VALUE(OrderJSON, '$.OrderID') AS OrderID,
    JSON_QUERY(OrderJSON, '$.Items') AS ItemsList
FROM OrderRecords;






3. JSON_MODIFY - Update JSON Data
What it does: JSON value update বা insert করে
-- Update JSON value
DECLARE @json NVARCHAR(MAX) = N'{"Name":"Rahul","Age":28}';

SELECT 
    @json AS OriginalJSON,
    JSON_MODIFY(@json, '$.Age', 29) AS UpdatedAge,
    JSON_MODIFY(@json, '$.City', 'Delhi') AS AddedCity;

-- Batch update JSON records
UPDATE CustomerProfiles
SET ProfileJSON = JSON_MODIFY(ProfileJSON, '$.Premium', 'true')
WHERE JSON_VALUE(ProfileJSON, '$.Age') > 30;

-- Add new field
SELECT 
    CustomerID,
    JSON_MODIFY(ProfileJSON, '$.UpdatedAt', CAST(GETDATE() AS NVARCHAR)) AS UpdatedProfile
FROM CustomerProfiles;





