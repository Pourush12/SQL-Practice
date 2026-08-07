-- Stored procedure with parameters
Create Procedure GetCustomerSummary @Country NVARCHAR(50)
AS
Begin
	select 
		Country,
		Count(*) as NrOfCustomers,
		AVG(COALESCE(Score,0)) AvgScore
	from Sales.Customers
	where Country = @Country
	group by Country
end

-- Execute the stored procedure
EXEC GetCustomerSummary @Country = 'USA'
EXEC GetCustomerSummary @Country = 'Germany'

-- Altering the SP
Alter Procedure GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
Begin
	select 
		Country,
		Count(*) as NrOfCustomers,
		AVG(COALESCE(Score,0)) AvgScore
	from Sales.Customers
	where Country = @Country
	group by Country
end

-- Execute the stored procedure
EXEC GetCustomerSummary @Country = 'USA'
EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary

-- Find the total Nr. of Orders and Total Sales and add this in previous stored procedure
Alter Procedure GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
Begin
	select 
		Country,
		Count(*) as NrOfCustomers,
		AVG(COALESCE(Score,0)) AvgScore
	from Sales.Customers
	where Country = @Country
	group by Country;

	select 
		Country,
		Count(*) TotalOrders,
		SUM(Sales) TotalSales
	from Sales.Orders so
	join Sales.Customers sc
	on sc.CustomerID = so.CustomerID
	where sc.Country = @Country
	group by Country;
end

-- Execute the stored procedure
EXEC GetCustomerSummary @Country = 'USA'
EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary

-- Variables
Alter Procedure GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
Begin

	DECLARE @TotalCustomers INT, @AvgScore FLOAT;
	select
		@TotalCustomers = Count(*),
		@AvgScore = AVG(COALESCE(Score,0))
	from Sales.Customers
	where Country = @Country

	PRINT 'Total Customers from '+@Country +':' + cast(@TotalCustomers as NVARCHAR);
	PRINT 'Average Score from ' +@Country +':'+cast(@AvgScore as NVARCHAR);

	select 
		Country,
		Count(*) TotalOrders,
		SUM(Sales) TotalSales
	from Sales.Orders so
	join Sales.Customers sc
	on sc.CustomerID = so.CustomerID
	where sc.Country = @Country
	group by Country;
end

-- Execute the stored procedure
EXEC GetCustomerSummary @Country = 'USA'
EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary

-- Control flow in Stored Procedure
Alter Procedure GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
Begin
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;
	-- Prepare & Cleanup Data
	if 
	begin
	end

	else 
	begin 
	end


	-- Generating Reports
	select
		@TotalCustomers = Count(*),
		@AvgScore = AVG(COALESCE(Score,0))
	from Sales.Customers
	where Country = @Country

	PRINT 'Total Customers from '+@Country +':' + cast(@TotalCustomers as NVARCHAR);
	PRINT 'Average Score from ' +@Country +':'+cast(@AvgScore as NVARCHAR);

	select 
		Country,
		Count(*) TotalOrders,
		SUM(Sales) TotalSales
	from Sales.Orders so
	join Sales.Customers sc
	on sc.CustomerID = so.CustomerID
	where sc.Country = @Country
	group by Country;
end
