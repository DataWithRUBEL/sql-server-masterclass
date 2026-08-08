🟢 LEVEL 19: DATA WAREHOUSE SQL

Star Schema

-- Fact Table (Transaction data, foreign keys to dimensions)
CREATE TABLE FactSales (
    SalesID INT PRIMARY KEY,
    DateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    CustomerKey INT FOREIGN KEY REFERENCES DimCustomer(CustomerKey),
    ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(10,2)
);

-- Dimension Tables (Master data)
CREATE TABLE DimCustomer (
    CustomerKey INT PRIMARY KEY,
    CustomerID INT,
    CustomerName NVARCHAR(100),
    Country NVARCHAR(50),
    CreditLimit DECIMAL(10,2)
);

CREATE TABLE DimProduct (
    ProductKey INT PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    Year INT,
    Month INT,
    Quarter INT,
    DayOfWeek NVARCHAR(10)
);





Slowly Changing Dimension (SCD Type 2)
-- Track history of customer credit limit changes
CREATE TABLE DimCustomer_SCD (
    CustomerSK INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    CustomerName NVARCHAR(100),
    CreditLimit DECIMAL(10,2),
    EffectiveDate DATE,
    EndDate DATE,
    IsCurrent BIT DEFAULT 1
);

-- When credit limit changes:
UPDATE DimCustomer_SCD
SET EndDate = GETDATE(), IsCurrent = 0
WHERE CustomerID = 1 AND IsCurrent = 1;

INSERT INTO DimCustomer_SCD (CustomerID, CustomerName, CreditLimit, EffectiveDate, IsCurrent)
VALUES (1, 'Rahul Roy', 75000, GETDATE(), 1);



Bronze → Silver → Gold Pipeline
-- BRONZE (Raw data)
-- Minimal transformation, incremental load
SELECT * FROM Orders_Raw;

-- SILVER (Cleaned, deduplicated)
-- Data quality checks, standardization
CREATE TABLE Orders_Silver AS
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    TotalAmount,
    CASE 
        WHEN OrderStatus IS NULL THEN 'Unknown'
        ELSE OrderStatus
    END AS OrderStatus
FROM Orders_Raw
WHERE OrderID IS NOT NULL AND CustomerID IS NOT NULL;

-- GOLD (Aggregated, business-ready)
-- KPIs, summaries for reporting
CREATE TABLE Orders_Summary_Gold AS
SELECT 
    DATEPART(YEAR, OrderDate) AS Year,
    DATEPART(MONTH, OrderDate) AS Month,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalRevenue,
    AVG(TotalAmount) AS AvgOrderValue
FROM Orders_Silver
GROUP BY DATEPART(YEAR, OrderDate), DATEPART(MONTH, OrderDate);












