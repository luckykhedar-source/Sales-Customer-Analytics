USE SalesAnalysis;
GO
 
-- ============================================
-- WINDOW FUNCTIONS
-- ============================================

-- Top 3 Customers Within Each State
with CustomerSales as(
select
	c.State,
	c.CustomerID,
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales
from Orders o 
join Products p
	on o.ProductID = p.ProductID
join Customers c
	on o.CustomerID = c.CustomerID
group by
	c.State,
	c.CustomerID,
	c.CustomerName
) 
select * from(
select
	*,
	rank() over(partition by State
		order by NetSales desc) as rn
from CustomerSales
)t
where rn <= 3

-- Top 3 Products Within Each Category
with ProductSales as (
select
	p.Category,
	p.ProductID,
	p.ProductName,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales
from Orders o 
join Products p
	on o.ProductID = p.ProductID
group by
	p.Category,
	p.ProductID,
	p.ProductName
) 
select * from(
select
	*,
	dense_rank() over(partition by Category
		order by NetSales desc) as rn
from ProductSales
)t
where rn <= 3


-- Customer Ranking by Net Sales
select
	c.CustomerID,
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales,
	row_number() over(order by sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) desc) as rn
from Orders o
join Products p 
	on o.ProductID = p.ProductID
join Customers c
	on o.CustomerID = c.CustomerID
group by
	c.CustomerID,
	c.CustomerName

-- ============================================
-- TIME SERIES ANALYSIS
-- ============================================

-- Monthly Net Sales
with MonthlySales as (
select
	year(o.OrderDate) as year,
	month(o.OrderDate) as month,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales
from Orders o
join Products p
	on o.ProductID = p.ProductID
group by
	year(o.OrderDate),
	month(o.OrderDate)
)
select
	*
from MonthlySales
order by 
	year,
	month

-- Running Total of Monthly Sales
with RunningMonthlySales as (
select
	Year(o.OrderDate) as Year,
	Month(o.OrderDate) as Month,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales
from Orders o
join Products p
	on o.ProductID = p.ProductID
group by
	Year(o.OrderDate),
	Month(o.OrderDate)
)
select
	Year,
	Month,
	NetSales,
	sum(NetSales) over(order by Year, Month
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) as RunningSales
from RunningMonthlySales

-- Previous Month Sales
with MonthlySales as(
select
	Year(o.OrderDate) as Year,
	Month(o.OrderDate) as Month,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales
from Orders o
join Products p
	on o.ProductID = p.ProductID
group by
	Year(o.OrderDate),
	Month(o.OrderDate)
)
select
	Year,
	Month,
	NetSales,
	lag(NetSales) over(
		order by Year, Month ) as Prev_Month
from MonthlySales

-- Month-over-Month Growth
with Mom as (
select
	year(o.OrderDate) as year,
	month(o.OrderDate) as month,
	sum((p.UnitPrice * o.Quantity) * (1 - o.Discount)) as NetSales,
	lag(sum((p.UnitPrice * o.Quantity) * (1-o.Discount)))
		over(order by year(o.OrderDate), month(o.OrderDate)) as prev_month
from Orders o
join Products p
	on o.ProductID = p.ProductID
group by
	year(o.OrderDate),
	month(o.OrderDate)
)
select
	year,
	month,
	NetSales,
	prev_month,
	cast(
		((NetSales - prev_month) * 100.0)
		/ NULLIF(prev_month,0) 
		as decimal(10,2) ) as MoMGrowth
from MoM
order by
	year, month

-- ============================================
-- ADVANCED BUSINESS ANALYSIS
-- ============================================

-- Customers Above Average Sales
with CustomerSales as(
select
	c.CustomerID,
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity)*(1-o.Discount)) as NetSales
from Orders o
join Customers c
	on o.CustomerID = c.CustomerID
join Products p
	on o.ProductID = p.ProductID
group by
	c.CustomerID,
	c.CustomerName
)
select
	CustomerID,
	CustomerName,
	NetSales
from CustomerSales
where NetSales > (
select avg(NetSales)
from CustomerSales 
)

-- Second Highest Selling Product
select * from(
select
	p.ProductID,
	p.ProductName,
	sum((p.UnitPrice * o.Quantity) * (1-o.Discount)) as NetSales,
	dense_rank() over(
		order by sum((p.UnitPrice * o.Quantity)*(1-o.Discount)) desc)
		as rn
from Orders o
join Products p
	on o.ProductID = p.ProductID
group by 
	p.ProductID,
	p.ProductName
)t
where rn = 2


-- Top Customer in Every State
select * from(
select
	c.State,
	c.CustomerID,
	c.CustomerName,
	sum((p.UnitPrice * o.Quantity) * (1-o.Discount)) as NetSales,
	row_number() over(partition by c.State
		order by sum((p.UnitPrice * o.Quantity) * (1-o.Discount)) desc )
		as rn
from Orders o
join Customers c
	on o.CustomerID = c.CustomerID
join Products p
	on o.ProductID = p.ProductID
group by
	c.State,
	c.CustomerID,
	c.CustomerName
)t
where rn = 1
