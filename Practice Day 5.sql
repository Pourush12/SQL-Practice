-- Window Functions

-- Find the total sales across all orders additionally provide details such as order id & order date
select 
	OrderID,
	OrderDate,
	Sales,
	sum(Sales) over() as [Total Sales]
from Sales.Orders

-- Find the total sales for each product additionally provide details such as order id & order date
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	sum(Sales) over(partition by ProductID) as [Total sales per product]
from Sales.Orders

-- Find the total sales across all orders and find the total sales for each product additionally provide details such as order id, order date
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	sum(Sales) over() as [Total Sales],
	sum(Sales) over(partition by ProductID) as [Total sales per product]
from Sales.Orders

-- Find the total sales for each product combination of product and order status
select
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	sum(sales) over(partition by ProductID,OrderStatus) as [Sales by Combination]
from Sales.Orders

-- Rank each order based on their sales from highest to lowest, additionally provide details such as order id & order date
select 
	OrderID,
	OrderDate,
	Sales,
	rank() over(order by Sales desc) as [Rank of the Sales]
from Sales.Orders

-- Find the total sales for each order status only for two products 101 and 102
select 
	OrderID,
	ProductID,
	OrderStatus,
	Sales,
	sum(Sales) Over(partition by OrderStatus)
from Sales.Orders
where ProductID in (101,102)

-- Rank the customers based on their total Sales
select 
	CustomerID,
	sum(Sales) TotalSales,
	Rank() Over(Order by sum(Sales) desc) as [ranks of customer based on the sales]
from Sales.Orders
group by CustomerID

