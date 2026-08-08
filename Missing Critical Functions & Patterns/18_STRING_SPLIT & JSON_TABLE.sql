1️⃣8️⃣ STRING_SPLIT & JSON_TABLE - Parse Structured Data
Modern String/JSON Parsing

-- STRING_SPLIT (SQL Server 2016+)
DECLARE @Skills NVARCHAR(MAX) = 'SQL Server, Python, Power BI, Azure';

SELECT TRIM(value) AS Skill
FROM STRING_SPLIT(@Skills, ',');

-- With ordinal position
SELECT TRIM(value) AS Skill, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SkillRank
FROM STRING_SPLIT(@Skills, ',')
ORDER BY SkillRank;

-- JSON parsing
DECLARE @JsonArray NVARCHAR(MAX) = N'[
    {"Name":"Rahul","Skill":"SQL"},
    {"Name":"Priya","Skill":"Python"},
    {"Name":"Amit","Skill":"Power BI"}
]';

SELECT 
    JSON_VALUE(value, '$.Name') AS Name,
    JSON_VALUE(value, '$.Skill') AS Skill
FROM OPENJSON(@JsonArray) json_table;












