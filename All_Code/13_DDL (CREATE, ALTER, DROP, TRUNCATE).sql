🟢 LEVEL 13: DDL (CREATE, ALTER, DROP, TRUNCATE)

-- CREATE TABLE with constraints
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Department NVARCHAR(50),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    HireDate DATE DEFAULT GETDATE(),
    ManagerID INT FOREIGN KEY REFERENCES Employees(EmployeeID)
);

-- ALTER TABLE: Add column
ALTER TABLE Employees
ADD PhoneNumber NVARCHAR(15);

-- ALTER TABLE: Modify column
ALTER TABLE Employees
ALTER COLUMN EmployeeName NVARCHAR(150);

-- ALTER TABLE: Drop column
ALTER TABLE Employees
DROP COLUMN PhoneNumber;

-- ALTER TABLE: Add constraint
ALTER TABLE Employees
ADD CONSTRAINT CK_SalaryRange CHECK (Salary BETWEEN 20000 AND 500000);

-- DROP TABLE (删除整个表)
DROP TABLE Employees;

-- TRUNCATE (Delete all rows, keeps structure)
TRUNCATE TABLE OrderDetails;
-- Faster than DELETE, can't use WHERE clause

-- Constraints
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    UNIQUE (OrderDate, CustomerID) -- No duplicate orders same day
);






