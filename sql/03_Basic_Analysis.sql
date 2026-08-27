USE SalesAnalysis;
GO

-- ============================================
-- BASIC DATA EXPLORATION
-- ============================================

-- View Customers
SELECT TOP 10 *
FROM Customers;

-- View Products
SELECT TOP 10 *
FROM Products;

-- View Orders
SELECT TOP 10 *
FROM Orders;

-- ============================================
-- DISTINCT VALUES
-- ============================================

-- Unique Cities
SELECT DISTINCT City
FROM Customers;

-- Unique Categories
SELECT DISTINCT Category
FROM Products;

-- ============================================
-- AGGREGATE ANALYSIS
-- ============================================

-- Total Customers
SELECT COUNT(*) AS TotalCustomers
FROM Customers;

-- Average Customer Age
SELECT AVG(Age) AS AverageAge
FROM Customers;

-- ============================================
-- GROUP BY ANALYSIS
-- ============================================

-- State-wise Customers
SELECT
    State,
    COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY State
ORDER BY TotalCustomers DESC;

-- Category-wise Products
SELECT
    Category,
    COUNT(*) AS TotalProducts
FROM Products
GROUP BY Category
ORDER BY TotalProducts DESC;

-- Bussiness Related

select top 10 *
from Customers
order by 
	Age desc

select top 5 *
from Products
where Category = 'Electronics'
order by UnitPrice desc

select top 10 *
from Orders
order by OrderDate desc

select *
from Customers
where City = 'Delhi'
and Gender = 'Female'
and Age > 30

/* Where Filters Individual rows before grouping 
Whereas Having filters grouped or aggregate result after groupby.
Where generally cannot be used with aggregate condition like count, avg, sum, while 
having designed for filtering aggregate results.*\
