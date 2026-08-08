SAMPLE DATABASE SETUP (সব examples এ use হবে) 

## Create Tables

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100),
    Email NVARCHAR(100),
    Country NVARCHAR(50),
    RegistrationDate DATE,
    CreditLimit DECIMAL(10,2)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT,
    Supplier NVARCHAR(50)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    OrderStatus NVARCHAR(20)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

-- Sample Data Insert
INSERT INTO Customers (CustomerName, Email, Country, RegistrationDate, CreditLimit)
VALUES 
('Rubel Islam', 'rubel@email.com', 'Kuwait', '2022-01-15', 50000),
('Priya Sharma', 'priya@email.com', 'India', '2022-03-20', 75000),
('Omar Khan', 'omar@email.com', 'Bangladesh', '2022-02-10', 60000),
('Sarah Ahmed', 'sarah@email.com', 'Pakistan', '2022-04-05', 80000),
('Zara Ali', 'zara@email.com', 'UAE', '2022-05-12', 100000),
('Kabir Ali', 'kabir@email.com', 'USA', '2022-07-12', 300000)

INSERT INTO Products (ProductName, Category, Price, Stock, Supplier)
VALUES 
('Laptop', 'Electronics', 75000, 50, 'TechCorp'),
('Mouse', 'Electronics', 1200, 500, 'TechCorp'),
('Keyboard', 'Electronics', 3500, 300, 'TechCorp'),
('Monitor', 'Electronics', 25000, 75, 'ElectroGear'),
('Headphones', 'Electronics', 5500, 200, 'AudioMax');

INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, OrderStatus)
VALUES 
(1, '2024-01-10', 76200, 'Completed'),
(2, '2024-01-15', 25000, 'Pending'),
(1, '2024-02-05', 28500, 'Completed'),
(3, '2024-02-10', 75000, 'Processing'),
(2, '2024-02-20', 5500, 'Completed'),
(4, '2024-03-01', 103700, 'Pending'),
(5, '2024-03-05', 30500, 'Completed');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 1, 75000), (1, 2, 1, 1200),
(2, 4, 1, 25000),
(3, 3, 1, 3500), (3, 5, 5, 5000),
(4, 1, 1, 75000),
(5, 5, 1, 5500),
(6, 4, 1, 25000), (6, 3, 3, 3500), (6, 2, 50, 1200),
(7, 1, 1, 75000), (7, 5, 1, 5500);
