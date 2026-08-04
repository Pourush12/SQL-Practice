-- Provide a view that combines details from orders, products, customers, and employees.
if OBJECT_ID('Sales.V_Combine','V') is not null
	drop view Sales.V_Combine
Go
Create View Sales.V_Combine as 
(	
	select 
		so.OrderID,
		so.OrderDate,
		sp.Product,
		sp.Category,
		COALESCE(sc.FirstName,'') + ' ' + COALESCE(sc.LastName,'') CustomerName,
		sc.Country CustomerCountry,
		COALESCE(se.FirstName,'') + ' ' + COALESCE(se.LastName,'') EmployeeName,
		se.Department,
		so.Sales,
		so.Quantity
	from Sales.Orders so
	left join Sales.Products sp
	on so.ProductID = sp.ProductID
	left join Sales.Customers sc
	on so.CustomerID = sc.CustomerID
	left join Sales.Employees se
	on so.SalesPersonID = se.EmployeeID
)

select *
from Sales.V_Combine

-- Provide a view for EU Sales Team that combines details from all tables and excludes date related to the USA
if OBJECT_ID('Sales.EU_Sales','V') is not null
	drop view Sales.EU_Sales
Go
Create View Sales.EU_Sales as 
(	
	select 
		so.OrderID,
		so.OrderDate,
		sp.Product,
		sp.Category,
		COALESCE(sc.FirstName,'') + ' ' + COALESCE(sc.LastName,'') CustomerName,
		sc.Country CustomerCountry,
		COALESCE(se.FirstName,'') + ' ' + COALESCE(se.LastName,'') EmployeeName,
		se.Department,
		so.Sales,
		so.Quantity
	from Sales.Orders so
	left join Sales.Products sp
	on so.ProductID = sp.ProductID
	left join Sales.Customers sc
	on so.CustomerID = sc.CustomerID
	left join Sales.Employees se
	on so.SalesPersonID = se.EmployeeID
	where sc.Country != 'USA'
)

select *
from Sales.EU_Sales