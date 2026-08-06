-- How to refresh CTAS to get updated data -- we can use TSQL
if OBJECT_ID('Sales.MonthlyOrders','U') is not null
	Drop table Sales.MonthlyOrders
Go
select 
	Datename(month,OrderDate) as Month,
	COUNT(*) as TotalOrders
into Sales.MonthlyOrders
from Sales.Orders
group by Datename(month,OrderDate)

-- Temp Table
select *
into #Orders
from Sales.Orders

select *
from #Orders

delete from #Orders
where OrderStatus = 'Delivered'

select *
from #Orders

-- How to store the temp result to the DB
select *
into Sales.OrdersTest
from #Orders

select *
from Sales.OrdersTest

-- Stored Procedure
-- Step1: Write a Query
-- For US Customers Find the Total Number of Customers and the Average Score
select 
	Country,
	Count(*) as NrOfCustomers,
	AVG(COALESCE(Score,0)) AvgScore
from Sales.Customers
where Country = 'USA'
group by Country

-- Step2: Truning the query into a stored procedure
create procedure GetCustomerSummary as
begin
select 
	Country,
	Count(*) as NrOfCustomers,
	AVG(COALESCE(Score,0)) AvgScore
from Sales.Customers
where Country = 'USA'
group by Country
end

-- Step3: Execute the Stored procedure
EXEC GetCustomerSummary