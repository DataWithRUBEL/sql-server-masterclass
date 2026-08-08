1️⃣6️⃣ Row-by-Row Processing with CROSS APPLY
Unnesting/Expanding Data

-- Split comma-separated values
CREATE TABLE ProductTags (
    ProductID INT,
    TagsList NVARCHAR(MAX) -- 'Electronics,Premium,Bestseller'
);

INSERT INTO ProductTags VALUES 
(1, 'Electronics,Premium,Bestseller'),
(2, 'Accessories,Budget');

-- Split using STRING_SPLIT (SQL Server 2016+)
SELECT 
    pt.ProductID,
    TRIM(value) AS Tag
FROM ProductTags pt
CROSS APPLY STRING_SPLIT(pt.TagsList, ',') tags;

-- Alternative: Using CHARINDEX loop
WITH RECURSIVE TagSplit AS (
    SELECT 
        ProductID,
        CAST(1 AS INT) AS RowNum,
        LTRIM(SUBSTRING(TagsList, 1, CHARINDEX(',', TagsList + ',') - 1)) AS Tag,
        SUBSTRING(TagsList, CHARINDEX(',', TagsList + ',') + 1, LEN(TagsList)) AS Remainder
    FROM ProductTags
    
    UNION ALL
    
    SELECT 
        ProductID,
        RowNum + 1,
        LTRIM(SUBSTRING(Remainder, 1, CHARINDEX(',', Remainder + ',') - 1)),
        SUBSTRING(Remainder, CHARINDEX(',', Remainder + ',') + 1, LEN(Remainder))
    FROM TagSplit
    WHERE Remainder != ''
)
SELECT ProductID, Tag FROM TagSplit WHERE Tag != '';













