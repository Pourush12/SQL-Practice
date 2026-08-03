-- Show the employee hierarchy by displaying each employee's level within the organization
With CTE_Emp_Hierarchy as (
	select 
		EmployeeID,
		FirstName,
		ManagerID,
		1 as Lvl
	from Sales.Employees
	where ManagerID is NULL
	union all
	select
		se.EmployeeID,
		se.FirstName,
		se.ManagerID,
		Lvl + 1
	from Sales.Employees se
	inner join CTE_Emp_Hierarchy h on se.ManagerID = h.EmployeeID
) 
select *
from CTE_Emp_Hierarchy;

-- VIEW
-- Find the running total of sales for each month
Create View Sales.V_Monthly_Summary as 
(	select 
		DATETRUNC(month, OrderDate) as OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantity
	from Sales.Orders
	Group by DATETRUNC(month, OrderDate)
)
select
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER(Order by OrderMonth) as RunningTotal
from Sales.V_Monthly_Summary

drop view V_Monthly_Summary -- Deleted the dbo.view

if OBJECT_ID('Sales.V_Monthly_Summary','V') is not null
	drop view Sales.V_Monthly_Summary
Go
Create View Sales.V_Monthly_Summary as 
(	select 
		DATETRUNC(month, OrderDate) as OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantity
	from Sales.Orders
	Group by DATETRUNC(month, OrderDate)
)

