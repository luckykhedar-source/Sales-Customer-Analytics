-- SQL Sales & Customer Analytics Case Study
-- SQL Server database setup
CREATE DATABASE SalesAnalysis;
GO
USE SalesAnalysis;
GO

CREATE TABLE Customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    CustomerSegment VARCHAR(30),
    SignupDate DATE
);

CREATE TABLE Products (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(150),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    Brand VARCHAR(50),
    UnitPrice DECIMAL(12,2),
    UnitCost DECIMAL(12,2)
);

CREATE TABLE Sales_Employees (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Region VARCHAR(30),
    State VARCHAR(50),
    JoiningDate DATE
);

CREATE TABLE Orders (
    OrderID VARCHAR(15) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(10),
    ProductID VARCHAR(10),
    EmployeeID VARCHAR(10),
    Quantity INT,
    Discount DECIMAL(5,2),
    PaymentMethod VARCHAR(30),
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES Sales_Employees(EmployeeID)
);

-- Import the four CSV files using SQL Server Import/Export Wizard:
-- Customers.csv -> Customers
-- Products.csv -> Products
-- Sales_Employees.csv -> Sales_Employees
-- Orders.csv -> Orders
