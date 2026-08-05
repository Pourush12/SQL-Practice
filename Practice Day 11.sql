-- Create Table as Select (CTAS)
-- Table that shows total number of orders each month
select 
	Datename(month,OrderDate) as Month,
	COUNT(*) as TotalOrders
into Sales.MonthlyOrders
from Sales.Orders
group by Datename(month,OrderDate)

select *
from Sales.MonthlyOrders