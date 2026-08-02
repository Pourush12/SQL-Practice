-- Windows Value Functions
-- LEAD(expr, offset, default value) over(partition by clm_name order by clm_name)
-- Analyze the month-over-month (MoM) performance by finding the percentage change in sales between the current and previous month
select
	*,
	CurrentMonthSales - PreviousMonthSales as MOM_Change,
	round(cast(CurrentMonthSales - PreviousMonthSales as float)/PreviousMonthSales * 100,2) as MOM_PrecentChange 
from(
select 
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER(Order by MONTH(OrderDate)) PreviousMonthSales
from Sales.Orders
Group By MONTH(OrderDate))t

select
	*,
	round((cast(ThisMonthSales as float) - PreviousMonthSales)/ThisMonthSales * 100,2) as PrecentageSalesChange
from(
select
	DATEpart(MONTH,OrderDate) Months,
	SUM(Sales) ThisMonthSales,
	LAG(SUM(Sales),1,0) OVER(Order by DATEpart(MONTH,OrderDate)) PreviousMonthSales
from Sales.Orders
group by DATEpart(MONTH,OrderDate))t

-- Customer Retention Analysis: Measure customer's behaviour and loyalty to help businesses build strong relationships with customers.
-- Analyze customer loyalty by ranking customers based on the average number of days between orders
select 
	CustomerID,
	AVG(DaysUntilNextOrder) as AvgDaysPerOrder,
	RANK() OVER(Order by COALESCE(AVG(DaysUntilNextOrder),999999)) LoyaltyRanking
from(
select
	OrderID,
	ProductID,
	CustomerID,
	OrderDate,
	LEAD(OrderDate) OVER(Partition by CustomerID Order by OrderDate) as NextOrder,
	DATEDIFF(DAY,OrderDate,LEAD(OrderDate) OVER(Partition by CustomerID Order by OrderDate)) DaysUntilNextOrder
from Sales.Orders)t
group by CustomerID

select 
	CustomerID,
	AVG(COALESCE(DATEDIFF(DAY,LastOrderDate,OrderDate),0)) as AvgDaysPerOrder,
	RANK() OVER(Order by AVG(COALESCE(DATEDIFF(DAY,LastOrderDate,OrderDate),0))) LoyaltyRanking
from(
select
	OrderID,
	ProductID,
	CustomerID,
	OrderDate,
	LAG(OrderDate) OVER(Partition by CustomerID Order by OrderDate) as LastOrderDate
from Sales.Orders)t
group by CustomerID

-- FIRST_VALUE() and LAST_VALUE()
-- Find the lowest and highest sales for each product
select
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(Partition by ProductID Order by Sales) as LowestSales,
	--LAST_VALUE(Sales) OVER(Partition by ProductID Order by Sales rows between current row and unbounded following) as HighestSales
	-- Instead of using LAST_VALUE() we can go ahead and change the order type in FIRST_VALUE() itself
	FIRST_VALUE(Sales) OVER(Partition by ProductID Order by Sales Desc) as HighestSales,
	-- MIN/MAX functions can also be used to gather these details
	MIN(Sales) OVER(Partition by ProductID) LowestSales1,
	MAX(Sales) OVER(Partition by ProductID) HighestSales1
from Sales.Orders

 -- Find the difference in sales between current and the lowest sales
 select
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(Partition by ProductID Order by Sales) as LowestSales,
	(Sales - FIRST_VALUE(Sales) OVER(Partition by ProductID Order by Sales)) DifferenceBetweenSales
from Sales.Orders

-- Advanced SQL

-- INFORMATON SCHEMA
select *
from INFORMATION_SCHEMA.COLUMNS

-- SUBQUERY
-- RESULT TYPES

-- SCALAR SUBQUERY
select
	SUM(Sales)
from Sales.Orders

-- ROW SUBQUERY
select
	CustomerID
from Sales.Orders

-- TABLE SUBQUERY
select
	OrderID,
	OrderDate
from Sales.Orders

-- LOCATION/CLAUSES

-- Subquery in from clause
-- Find the products that have price higher than the average price of all products
select * -- MAIN QUERY
from
	(select -- SUB QUERY
		*,
		AVG(Price) OVER() as AVGPRICE
	from Sales.Products)t
where Price > AVGPRICE

-- Rank the customers based on their total amount of sales
select
	*,
	RANK() OVER(Order by TotalSales desc) CustomerRank
from(
select 
	CustomerID,
	SUM(Sales) TotalSales
from Sales.Orders
Group by CustomerID)t

-- Subequery in Select Clause
-- Show the product ID's, product names, prices and the total number of orders

select 
	ProductID,
	Product,
	Price,
	(select COUNT(*) from Sales.Orders) TotalOrders
from Sales.Products

-- Subequry in Join Clause
-- Show all customer details and find the total orders for each customer
select
	sc.*,
	st.TotalOrders
from Sales.Customers sc
left join (
select 
	CustomerID,
	Count(*) as TotalOrders
from Sales.Orders
group by CustomerID)st
on sc.CustomerID = st.CustomerID

-- Subquery in Where Clause
-- Comparison Operators
-- Find the products that have a price higher than the average price of all products
select *
from Sales.Products
where Price > (select avg(Price) from Sales.Products)

-- Logical Operators
-- IN Operator / NOT IN Operator
-- Show the details of orders made by customer in germany
select *
from Sales.Orders
where CustomerID in (select CustomerID from Sales.Customers where Country = 'Germany')

-- Show the details of orders made by customer not from germany
select *
from Sales.Orders
where CustomerID not in (select CustomerID from Sales.Customers where Country = 'Germany')

-- ANY / ALL Operator
-- Find female employees whose salaries are greater than the salaries of any male employees
select *
from Sales.Employees
Where Gender = 'F' and Salary > ANY(Select Salary from Sales.Employees where Gender = 'M')

-- Find the female employees whose salaries are greater than the salaries of all male employees
select *
from Sales.Employees
Where Gender = 'F' and Salary > ALL(Select Salary from Sales.Employees where Gender = 'M')

-- NON-CORRELATED / CORRELATED Subqueries
-- Show all customer details and find the total orders for each customer
select 
	*,
	(Select count(*) from Sales.Orders so where so.CustomerID = sc.CustomerID) TotalSales -- Correlated subquery
from Sales.Customers sc

-- EXISTS Operator
-- Show the details of orders made by customers in germany
select *
from Sales.Orders so
where exists(
	Select * from Sales.Customers sc where Country = 'Germany' and sc.CustomerID = so.CustomerID
)

-- Common Table Expression (CTE)

-- Standalone CTE
-- Step1: Find the total Sales Per Customer
with CTE_TotalSales as(
select
	CustomerID,
	SUM(Sales) TotalSales
from Sales.Orders
group by CustomerID)
select 
	sc.CustomerID,
	sc.FirstName,
	sc.LastName,
	CTEts.TotalSales
from Sales.Customers sc
left join CTE_TotalSales CTEts
on sc.CustomerID = CTEts.CustomerID

-- Multiple Standalone CTE's
-- Step2: Find the last order date for each customer
with CTE_TotalSales as(
select
	CustomerID,
	SUM(Sales) TotalSales
from Sales.Orders
group by CustomerID)
, CTE_LastOrderDate as (
	select
		CustomerID,
		MAX(OrderDate) as LastOrderDate
	from Sales.Orders
	Group by CustomerID
)
select 
	sc.CustomerID,
	sc.FirstName,
	sc.LastName,
	CTEts.TotalSales,
	CTElod.LastOrderDate
from Sales.Customers sc
left join CTE_TotalSales CTEts on sc.CustomerID = CTEts.CustomerID
left join CTE_LastOrderDate CTElod on sc.CustomerID = CTElod.CustomerID

-- NESTED CTE
-- Step3: Rank Customers based on Total Sales Per Customer
with CTE_TotalSales as(-- Step1
	select
		CustomerID,
		SUM(Sales) TotalSales
	from Sales.Orders
	group by CustomerID)
, CTE_LastOrderDate as (-- Step2
	select
		CustomerID,
		MAX(OrderDate) as LastOrderDate
	from Sales.Orders
	Group by CustomerID
), CTE_RankSales as (-- Step3
	select 
		CustomerID,
		TotalSales,
		RANK() OVER(Order by TotalSales Desc) RankSales
	from CTE_TotalSales
)
select 
	sc.CustomerID,
	sc.FirstName,
	sc.LastName,
	CTEts.TotalSales,
	CTElod.LastOrderDate,
	CTErs.RankSales
from Sales.Customers sc
left join CTE_TotalSales CTEts on sc.CustomerID = CTEts.CustomerID
left join CTE_LastOrderDate CTElod on sc.CustomerID = CTElod.CustomerID
left join CTE_RankSales CTErs on sc.CustomerID = CTErs.CustomerID

-- Segment customers based on their total sales
with CTE_TotalSales as(-- Step1
	select
		CustomerID,
		SUM(Sales) TotalSales
	from Sales.Orders
	group by CustomerID)
, CTE_LastOrderDate as (-- Step2
	select
		CustomerID,
		MAX(OrderDate) as LastOrderDate
	from Sales.Orders
	Group by CustomerID
), CTE_RankSales as (-- Step3
	select 
		CustomerID,
		TotalSales,
		RANK() OVER(Order by TotalSales Desc) RankSales
	from CTE_TotalSales
), CTE_Customer_Segments as (-- Step4
	select
		CustomerID,
		CASE When TotalSales > 100 Then 'High Sales'
			 When TotalSales > 60 Then 'Medium Sales'
			 ELSE 'Low Sales'
		END as Segments
	from CTE_TotalSales
)
select 
	sc.CustomerID,
	sc.FirstName,
	sc.LastName,
	CTEts.TotalSales,
	CTElod.LastOrderDate,
	CTErs.RankSales,
	CTEcs.Segments
from Sales.Customers sc
left join CTE_TotalSales CTEts on sc.CustomerID = CTEts.CustomerID
left join CTE_LastOrderDate CTElod on sc.CustomerID = CTElod.CustomerID
left join CTE_RankSales CTErs on sc.CustomerID = CTErs.CustomerID
left join CTE_Customer_Segments CTEcs on sc.CustomerID = CTEcs.CustomerID

-- Recursive CTE
-- Generate a Sequence of Numbers from 1 to 20
With CTE_Recursive as (
	Select 
		1 as Number
	Union all
	select
		Number + 1
	from CTE_Recursive
	where Number < 20
)
select *
from CTE_Recursive

-- Show the employee hierarchy by displaying each employee's level within the organization
with Hierarchy as (
	select 
		EmployeeID,
		FirstName,
		ManagerID,
		1 as Level
	from Sales.Employees
	where ManagerID is NULL
	union all
	select
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		2 as Level
	from Sales.Employees e
	inner join Hierarchy h
	on e.ManagerID = h.ManagerID
)select *
from Hierarchy