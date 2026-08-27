USE SalesAnalysis;
GO

-- ============================================
-- SALES & PROFIT CALCULATIONS
-- ============================================

-- Calculate order-level Gross Sales, Discount, Net Sales and Profit
select
	c.CustomerID,
	c.CustomerName,
	count(distinct o.OrderID) as TotalOrders,
	sum(o.Quantity) as TotalQty,
	sum(p.UnitPrice * o.Quantity) as GrossSales,
	sum((p.UnitPrice * o.Quantity) * o.Discount) as DiscountAmount,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) as NetSales,
	sum(p.UnitCost * o.Quantity) as TotalCost,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) -
		(p.UnitCost * o.Quantity)) as Profit
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products p 
	on o.ProductID = p.ProductID
group by
	c.CustomerID,
	c.CustomerName
order by
	c.CustomerID

-- ============================================
-- CUSTOMER PERFORMANCE
-- ============================================

-- Customer-wise Sales and Profit Analysis
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(o.Quantity) AS TotalQty,
    SUM(o.Quantity * p.UnitPrice) AS TotalSales,
    SUM((p.UnitPrice - p.UnitCost) * o.Quantity) AS TotalProfit
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN Products p
    ON o.ProductID = p.ProductID
GROUP BY
    c.CustomerID,
    c.CustomerName;

-- Top 10 Customers based on Net Sales
select top 10
	c.CustomerID,
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) as NetSales
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products p 
	on o.ProductID = p.ProductID
group by
	c.CustomerID,
	c.CustomerName
order by 
	NetSales desc

-- ============================================
-- CATEGORY PERFORMANCE
-- ============================================

-- Category-wise Sales and Profit Analysis
select
	p.Category,
	count(distinct o.OrderID) as TotalOrders,
	sum(o.Quantity) as TotalQty,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) as NetSales,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) -
		(p.UnitCost * o.Quantity)) as Profit
from Orders o
join Products p 
	on o.ProductID = p.ProductID
group by 
	p.Category

-- ============================================
-- STATE PERFORMANCE
-- ============================================

-- State-wise Sales and Profit Analysis
select
	c.State,
	count(distinct c.CustomerID) as TotalCustomers,
	count(distinct o.OrderID) as TotalOrders,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity )* o.Discount) as NetSales,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) -
		(p.UnitCost * o.Quantity)) as Profit
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products p 
	on o.ProductID = p.ProductID
group by
	c.State

-- ============================================
-- EMPLOYEE PERFORMANCE
-- ============================================

-- Employee-wise Sales and Profit Analysis
select
	e.EmployeeID,
	e.EmployeeName,
	count(distinct o.OrderID) as TotalOrders,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) as NetSales,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity) * o.Discount) -
		(p.UnitCost * o.Quantity)) as Profit
from Orders o
join Sales_Employees e 
	on o.EmployeeID = e.EmployeeID
join Products p 
	on o.ProductID = p.ProductID
group by
	e.EmployeeID,
	e.EmployeeName
order by
	e.EmployeeName

-- Segment wise Nest Sales
select
	c.CustomerSegment,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) as NetSales
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products  p 
	on o.ProductID = p.ProductID
group by
	c.CustomerSegment
order by
	NetSales desc

-- Product Category Generates Highest Profit
select
	p.Category,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) -
		(p.UnitCost * o.Quantity)) as Profit
from Orders o
join Products  p 
	on o.ProductID = p.ProductID
group by
	p.Category
order by
	Profit desc

-- State generates Highest Net Sales
select
	c.State,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) as NetSales
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products  p 
	on o.ProductID = p.ProductID
group by
	c.State
order by
	NetSales desc

-- Sales Employee generates Highest Net Sales
select
	e.EmployeeID,
	e.EmployeeName,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) as NetSales
from Orders o
join Sales_Employees e 
	on o.EmployeeID = e.EmployeeID
join Products  p 
	on o.ProductID = p.ProductID
group by
	e.EmployeeID,
	e.EmployeeName
order by
	NetSales desc

-- Top 10 Customer by Net Sales, Each Customer Generates Profit
select top 10
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount) as NetSales,
	sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount)-
		(p.UnitCost * o.Quantity)) as Profit,
	rank() over(partition by c.CustomerName
		order by sum(((p.UnitPrice * o.Quantity) -
		(p.UnitPrice * o.Quantity)* o.Discount)-
		(p.UnitCost * o.Quantity)) desc) as Rank
from Orders o
join Customers c 
	on o.CustomerID = c.CustomerID
join Products  p 
	on o.ProductID = p.ProductID
group by
	c.customerName
order by
	NetSales desc