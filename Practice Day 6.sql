-- Windows aggregate functions

-- Count()
-- Find the total number of orders
select
	 count(*) as TotalOrders
from Sales.Orders

-- Find the total number of orders additionally provide details such as orderid & orderdate
select 
	OrderID,
	OrderDate,
	Count(*) over() as TotalSales
from Sales.Orders

-- Find the total number of orders or each customer additionally provide details such as orderid & orderdate
select
	OrderID,
	OrderDate,
	CustomerID,
	Count(*) over() as TotalSales,
	count(*) over(partition by CustomerID) as [Total Orders per customer]
from Sales.Orders

-- Find the total number of customers additionally provide all customer's details
select
	*,
	COUNT(*) over() as TotalNoOfCustomers
from Sales.Customers

-- Find the total number of scores for the customers additionally provide all customer details
select
	*,
	COUNT(*) over() as TotalNoOfCustomers,
	count(Score) Over() as TotalNoOfScore
from Sales.Customers

-- Check whether the table 'Order' contains any duplicate rows
select 
	OrderID,
	Count(*) over(partition by OrderID) Flag
from Sales.Orders

select 
	OrderID,
	Flag
from (select 
	OrderID,
	count(*) over(partition by OrderID) Flag
from Sales.OrdersArchive)t
where Flag > 1 

-- SUM()
-- Find the total sales across all order and the total sales for each product additionally provide details such as orderid and orderdate
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) Over() TotalSales,
	SUM(Sales) Over(partition by ProductID) TotalSalesPerProduct
from Sales.Orders

-- Find the percentage contribution of each product's sales to the total sales
select 
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) over() TotalSales,
	round(cast (sales as float) / sum(sales) over() *100,2) as PercentageContribution
from Sales.Orders

select
	ProductID,
	round((cast(SalesPerProduct as float)/TotalSales)*100,2) as PercentageContribution 
from(
select
	ProductID,
	SUM(Sales) as SalesPerProduct,
	Sum(sum(Sales)) over() as TotalSales
from Sales.Orders
group by ProductID)t

-- Average()
-- Find the average sales across all orders and the average sales for each product additionally provide details such as orderid and orderdate
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) Over() as AverageSales,
	AVG(Sales) Over(partition by ProductID) as AverageSalesPerProduct
from Sales.Orders

-- Find the average scores of customers additionally provide details such as CustomerID and LastName
select 
	*,
	AVG(Score) Over() as AverageScoreWithNull,
	Coalesce(Score,0) UpdatedScore,
	AVG(Coalesce(Score,0)) Over() as AverageScoreWithoutNull
from Sales.Customers

-- Find all orders where sales are higher than the average sales across all orders
select *
from(
select
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) Over() AverageSales
from Sales.Orders)t 
where Sales>AverageSales

-- MIN() & MAX()
-- Find the highest & lowest sales across all orders and the highest and lowest sales for each product additionally provide details such as orderid & orderdate
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) over() MinSalesAcrossAllOrders,
	MAX(Sales) over() MaxSalesAcrossAllOrders,
	MIN(Sales) over(Partition by ProductID) MinSalesPerProduct,
	MAX(Sales) over(Partition by ProductID) MaxSalesPerProduct
from Sales.Orders

-- Show the employees who have the highest salaries
select *
from(
Select 
	EmployeeID,
	Salary,
	MAX(Salary) Over() MaxSalary
from Sales.Employees)t where Salary = MaxSalary

-- Calculate the deviation of each sale from both the min and max sales amount
select
	OrderID,
	OrderDate,
	ProductID,
	Min(Sales) Over() MinSales,
	abs(Sales - Min(Sales) Over()) MinDevSales,
	Sales,
	abs(Max(Sales) Over() - Sales) MaxDevSales,
	Max(Sales) Over() MaxSales
from Sales.Orders

-- Running & Rolling Total can be done using frame clause
-- Example question by me
select	
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) Over(Order By OrderID rows between unbounded preceding and current row) as [Running Total],
	SUM(Sales) Over(Order by OrderID rows between 2 preceding and current row) as [Rolling Total last 3 orders Sales]
from Sales.Orders

-- Calculate the moving average of sales for each product over time
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER(partition by productid ) avgbyprod,
	AVG(Sales) OVER(partition by productid order by orderdate) movingaverage 
from Sales.Orders

select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) over(Partition by ProductID order by OrderDate rows between unbounded preceding and current row) as [Avg Sales]
from Sales.Orders

-- Calculate moving average of sales for each product over time, including only the next order
select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	Avg(Sales) over(partition by ProductID order by OrderDate rows between current row and 1 following) as [Rolling Avg]
from Sales.Orders

-- Windows Ranking Functions

-- ROW_NUMBER()
-- Rank the orders based on their sales from highest to lowest
select 
	OrderID,
	Sales,
	ROW_NUMBER() Over(Order by Sales Desc) as RankingBySales
from Sales.Orders 

-- RANK()
-- Rank the orders based on their sales from highest to lowest
select 
	OrderID,
	Sales,
	RANK() Over(Order by Sales Desc) as RankingBySales
from Sales.Orders 

-- DENSE_RANK()
-- Rank the orders based on their sales from highest to lowest
select 
	OrderID,
	Sales,
	DENSE_RANK() Over(Order by Sales Desc) as RankingBySales
from Sales.Orders 

-- Find the top highest sales for each product
select *
from(
select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(Partition by ProductID Order by Sales Desc) RankSalesPerProduct
from Sales.Orders)t where RankSalesPerProduct = 1

-- Find the lowest 2 customers based on their total sales
select *
from(
select
	CustomerID,
	SUM(Sales) as TotalSales,
	ROW_NUMBER() OVER(Order by SUM(Sales)) as RankTotalSales
from Sales.Orders
Group by CustomerID)t where RankTotalSales in (1,2)