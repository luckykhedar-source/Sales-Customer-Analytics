USE SalesAnalysis;
GO

-- ============================================
-- DATA VALIDATION
-- ============================================

-- Check total records in each table
SELECT COUNT(*) AS TotalCustomers
FROM Customers;
--1000

SELECT COUNT(*) AS TotalProducts
FROM Products;
--200

SELECT COUNT(*) AS TotalOrders
FROM Orders;
--10000

SELECT COUNT(*) AS TotalEmployees
FROM Sales_Employees;
--50

-- Check duplicate Customer IDs
SELECT
    CustomerID,
    COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;
--0

-- Check duplicate Product IDs
SELECT
    ProductID,
    COUNT(*) AS DuplicateCount
FROM Products
GROUP BY ProductID
HAVING COUNT(*) > 1;
--0

-- Check duplicate Order IDs
SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;
--0

-- Check NULL values in important Customer columns
SELECT *
FROM Customers
WHERE CustomerID IS NULL
   OR CustomerName IS NULL;
--0

-- Check NULL values in important Product columns
SELECT *
FROM Products
WHERE ProductID IS NULL
   OR ProductName IS NULL;
--0

-- Check invalid foreign keys: Orders → Customers
SELECT o.*
FROM Orders o
LEFT JOIN Customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;


-- Check invalid foreign keys: Orders → Products
SELECT o.*
FROM Orders o
LEFT JOIN Products p
    ON o.ProductID = p.ProductID
WHERE p.ProductID IS NULL;


-- Check invalid foreign keys: Orders → Employees
SELECT o.*
FROM Orders o
LEFT JOIN Sales_Employees e
    ON o.EmployeeID = e.EmployeeID
WHERE e.EmployeeID IS NULL;