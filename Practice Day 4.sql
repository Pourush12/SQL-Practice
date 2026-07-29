-- CASE Statement // Data type of each result must be matching
/*
CASE
WHEN Condition1 Then result1
WHEN Condition2 Then result2
...
WHEN Conditionn Then resultn
ELSE result
END
*/
select
	SalesCategory,
	SUM(Sales) as [Total Sales by Category]
From (
select 
	OrderID,
	Sales,
	Case
		When Sales > 50 then 'High'
		when Sales > 20 and Sales <=50 then 'Medium'
		else 'Low'
	end as SalesCategory
from Sales.Orders
)t group by SalesCategory
Order by SUM(Sales) desc

select
	EmployeeID,
	Gender,
	Case
		When Gender = 'M' then 'Male'
		When Gender = 'F' then 'Female'
		else 'Unknown'
	end as FullGender
from Sales.Employees

select 
	CustomerID,
	Country,
	CASE
		WHEN Country = 'Germany' then 'DE'
		WHEN Country = 'USA' then 'US'
		else 'N/A'
	END as CountryAbv
from Sales.Customers

select 
	CustomerID,
	LastName,
	Score,
	CASE
		WHEN Score is null then 0
		else Score
	END as UpdatedScore,
	AVG(Score) Over() as [AVG of Score before taking care of NULL],
	AVG(CASE
		WHEN Score is null then 0
		else Score
	END) Over() as [AVG of Score after taking care of NULL]
from Sales.Customers

Select 
	CustomerID,
	LastName,
	UpdatedScore,
	AVG(UpdatedScore) OVER() 
From (select 
	CustomerID,
	LastName,
	Score,
	CASE
		WHEN Score is null then 0
		else Score
	END as UpdatedScore
from Sales.Customers
) t

-- Count How many times each customer made an order with sales greater than 30

select
	CustomerID,
	SUM(Case when Sales > 30 then 1 else 0 end) as [No of times sales higher than 30],
	count(*) TotalOrders
from Sales.Orders
group by CustomerID

select
	CustomerID,
	SUM(Flag) as [No of times sales higher than 30]
from(
select
	OrderID,
	CustomerID,
	Sales,
	CASE
		 WHEN Sales > 30 then 1
		 else 0
	END as Flag
from Sales.Orders
)t Group by CustomerID

use MyDatabase
-- Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)

-- Find the total number of orders
select 
	COUNT(*) as TotalNoOfOrders
from Orders

-- Find the total Sales of all orders
select
	SUM(Sales) as TotalSales
from orders

-- Find the Average Sales of all orders
select 
	AVG(Sales) as AvgSales
from orders

-- Find the highest and lowest sales of all orders
select
	MAX(sales) as HighestSales,
	MIN(sales) as LowestSales
from orders

use SalesDB
-- Windows Functions // Very Very imp

-- find the total sales across all orders
select 
	SUM(Sales) TotalSales
from Sales.Orders

-- find the total sales for each product
select
	ProductID,
	SUM(Sales) SalesPerProeduct
from Sales.Orders
group by ProductID

-- Find the total sales for each product additionally provide details such as order id, order date
select
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(partition by productid) as [Total Sales by Product]
from Sales.Orders

