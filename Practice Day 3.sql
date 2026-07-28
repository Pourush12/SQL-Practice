use SalesDB

-- DATENAME()
select 
	OrderID,
	CreationTime,
	DATENAME(month,CreationTime) as DNMonth,
	DATENAME(WEEKDAY,CreationTime) as DNWeekDay,
	DATENAME(day,CreationTime) as DNDay, -- Return type here is string.
	DATENAME(year,CreationTime) as DNYear, -- Return type here is string.
	DATENAME(quarter,CreationTime) as DNQuarter -- Return type here is string.
from Sales.Orders

-- DATETRUNC()
select
	OrderID,
	CreationTime,
	DATETRUNC(year,CreationTime) as DTyear,
	DATETRUNC(MONTH,CreationTime) as DTMonth,
	DATETRUNC(DAY,CreationTime) as DTDay,
	DATETRUNC(HOUR,CreationTime) as DTHour,
	DATETRUNC(MINUTE,CreationTime) as DTMinute,
	DATETRUNC(SECOND,CreationTime) as DTSecond
from Sales.Orders

select
	Datetrunc(Month,CreationTime) as DTMonth,
	COUNT(*) as OrdersPerMonth
from Sales.Orders
group by Datetrunc(Month,CreationTime)


-- EOMONTH()
select
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) as EofMonth
from Sales.Orders

select
	datepart(year,OrderDate) as Year,
	count(*) as NoOfOrders
from Sales.Orders
group by datepart(year,OrderDate)

select
	datepart(year,OrderDate) as Year,
	datename(MONTH,OrderDate) as Month,
	count(*) as NoOfOrders
from Sales.Orders
group by datepart(year,OrderDate),datename(MONTH,OrderDate)

select *
from Sales.Orders
where DATEPART(month,OrderDate) = 2

-- Formating & Casting
-- Format()
select
	OrderId,
	CreationTime,
	FORMAT(CreationTime,'MM-dd-yyyy') as USA_Format,
	FORMAT(CreationTime,'dd-MM-yyyy') as Euro_Format,
	FORMAT(CreationTime,'dd') as dd,
	FORMAT(CreationTime, 'ddd') as ddd,
	FORMAT(CreationTime, 'dddd') as dddd,
	FORMAT(CreationTime,'MM') as MM,
	FORMAT(CreationTime,'MMM') as MMM,
	FORMAT(CreationTime,'MMMM') as MMMM
from Sales.Orders

select
	OrderID,
	CreationTime,
	'Day ' + Format(CreationTime,'ddd MMM') + ' Q' + DATENAME(quarter,CreationTime) + FORMAT(CreationTime,' yyyy hh:mm:ss tt') as CustomFormat
from Sales.Orders

select
	Format(OrderDate, 'MMM yy') as FormatedDate,
	COUNT(*) as NoOfOrders
from Sales.Orders
group by Format(OrderDate, 'MMM yy')

-- CONVERT()
select
	CONVERT(int,'123') as [String to Int Convert],
	CONVERT(date,'2026-07-28') as [String to Date Convert]

select
	CreationTime,
	CONVERT(Date,CreationTime) as [Datetime to Date Convert],
	CONVERT(varchar,CreationTime,32) as [USA Std. Style:32],
	CONVERT(varchar,CreationTime,34) as [EURO Std. Style:34]
from Sales.Orders

-- CAST()
select
	CAST('123' as int) as [String to Int],
	CAST(123 as varchar) as [Int to String],
	CAST('2026-07-28' as date) as [String to Date],
	CAST('2026-07-28' as datetime2) as [String to Datetime]
	
select
	CreationTime,
	CAST(CreationTime as date) as [Datetime to Date]
from Sales.Orders

-- DATEADD()
select
	OrderID,
	OrderDate,
	DATEADD(day,-10,OrderDate) as [10 Days before],
	DATEADD(MONTH,3,OrderDate) as [3 months Later],
	DATEADD(year,2,OrderDate) as [2 years Later]
from Sales.Orders

-- DATEDIFF
select 
	EmployeeID,
	BirthDate,
	DATEDIFF(year,BirthDate,GETDATE()) as [Age]
from Sales.Employees

select 
	OrderID,
	OrderDate,
	ShipDate,
	DATEDIFF(day,OrderDate,ShipDate) as [Shipping Duration]
from Sales.Orders

select
	Datename(MONTH,OrderDate) as MonthOfOrder,
	avg(DATEDIFF(day,OrderDate,ShipDate)) as [Avg Days for Shipping per month]
from Sales.Orders
group by Datename(MONTH,OrderDate)

select
	OrderID,
	OrderDate as CurrentOrderDate,
	LAG(OrderDate) Over(Order by OrderDate) as PreviousOrderDate,
	datediff(day,LAG(OrderDate) Over(Order by OrderDate),OrderDate) as NoOfDays
from Sales.Orders

-- ISDATE()
select
	ISDATE('123') as [ISDATE('123')],
	ISDATE('2026-07-28') as [ISDATE('2026-07-28')],
	ISDATE('20-07-2026') as [ISDATE('20-07-2026')],
	ISDATE('2026') as [ISDATE('2026')],
	ISDATE('08') as [ISDATE('08')]

select
	OrderDate,
	ISDATE(OrderDate) flag,
	case when ISDATE(OrderDate) = 1 then CAST(OrderDate as date) end as ConvertedDate
from
(
	select '2026-07-20' as OrderDate
	union
	select '2026-07-21'
	union
	select '2026-07-22'
	union 
	select '2026-07'
)t
where ISDATE(OrderDate) = 0

use MyDatabase
-- Null Functions
-- ISNULL() & COALESCE()

select
	id,
	Score,
	Avg(Score) OVER () AvgScore1,
	avg(coalesce(Score,0)) Over() AvgScore2
from customers

select
	5 + NULL,
	NULL + 'B'

use SalesDB

select 
	CustomerID,
	FirstName,
	LastName,
	(FirstName + ' ' + LastName) as [Full Name without Null Checking],
	(FirstName + ' ' + Coalesce(LastName,'')) as [Full Name With Null Checking],
	Score as OldScore,
	(Score + 10) as [Updated Score without Null Checking],
	(coalesce(Score,0) +10) as [Updated Score withou Null Checking]
from Sales.Customers

select 
	CustomerID,
	Score
from Sales.Customers
order by case when score is null then 1 else 0 end,Score

-- NULLIF()
select
	OrderID,
	Price,
	NULLIF(Price,-1) as [Price Cannot be negative]
From(
select
	1 as OrderID,
	90 as Price
union
select
	2,
	-1
)t

select
	OrderID,
	Original_Price,
	Discount_Price,
	case when NULLIF(Original_Price,Discount_Price) is Null then 0 else 1 end flag
From(
select
	1 as OrderID,
	150 as Original_Price,
	50 as Discount_Price
union
select
	2,
	250,
	250
)t

select 
	OrderID,
	Quantity,
	Sales,
	Sales/NULLIF(Quantity,0) as Price
from Sales.Orders

select 
	OrderID,
	ShipAddress,
	Case when ShipAddress is Null then 'TRUE' else 'FALSE' end NullFlag
from Sales.Orders

Select *
from Sales.Customers
where score is not null

select *
from Sales.Customers
select *
from Sales.Orders

select 
	sc.CustomerID,
	so.CustomerID,
	so.OrderID
from Sales.Customers sc
left join Sales.Orders so
on sc.CustomerID = so.CustomerID	
where so.CustomerID is Null

with Orders As(
	select 1 Id, 'A' Category Union
	select 2, NULL Union
	Select 3, '' Union
	select 4, ' '
) select
	Id,
	Category,
	dataLength(Category) LenCat
from Orders


