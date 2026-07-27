use SalesDB

-- Union

select 
	FirstName,
	LastName
from Sales.Customers
union
select
	FirstName,
	LastName
from Sales.Employees

-- Union all
select 
	FirstName,
	LastName
from Sales.Customers
union all
select
	FirstName,
	LastName
from Sales.Employees

-- Except
select
	FirstName,
	LastName
from Sales.Employees
except
select 
	FirstName,
	LastName
from Sales.Customers

-- Intersect
select
	FirstName,
	LastName
from Sales.Employees
intersect
select
	FirstName,
	LastName
from Sales.Customers

-- Combine information
select 
       'Orders' as SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
from Sales.Orders
union
select 
       'OrdersArchive' as SourceTable,
       [OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
from Sales.OrdersArchive
order by OrderID

-- Functions
use MyDatabase

-- Concat
select 
    first_name,
    country,
    CONCAT(first_name,'-',country) as [Name and Country]
from customers

-- Upper & Lower
select
    first_name,
    lower(first_name) as LowerCase,
    upper(first_name) as UpperCase
from customers

-- Trim
select
    first_name
from customers
where first_name != trim(first_name)

select
    first_name,
    len(first_name) as OriginalLen,
    trim(first_name) as TrimName,
    len(trim(first_name)) as TrimLen,
    (len(first_name) - len(trim(first_name))) as Flag
from customers
where len(first_name) != len(trim(first_name))

-- Replace
select
    '123-456-789' as PhoneNumber,
    REPLACE('123-456-789','-','/') as NewPhoneNumber

select
    'report.txt' as FileFormat,
    REPLACE('report.txt','.txt','.csv') as NewFileFormat

-- Len
select
    first_name,
    len(first_name) as NameLen
from customers

-- Left & Right
select
    first_name,
    left(trim(first_name),2) as First2Char,
    right(trim(first_name),2) as Last2Char
from customers

-- Substring
select
    first_name,
    SUBSTRING(trim(first_name),2,len(first_name)) as SubName
from customers

-- Round
select
    3.516,
    ROUND(3.516,2) as round2,
    Round(3.516,1) as round1,
    round(3.516,0) as round0

-- ABS
select
    -10,
    ABS(-10) as absNo

    
use SalesDB
-- Date and Time Functions

-- DAY, MONTH, YEAR
select
    OrderID,
    CreationTime,
    YEAR(CreationTime) as YearoftheDate,
    MONTH(CreationTime) as MonthoftheDate,
    DAY(CreationTime) as DayoftheDate
from Sales.Orders

-- DATEPART()
select
    OrderID,
    CreationTime,
    DATEPART(year,CreationTime) DPYear,
    DATEPART(month,CreationTime) DPMonth,
    DATEPART(day,CreationTime) DPDay,
    DATEPART(hour,CreationTime) DPHour,
    DATEPART(quarter,CreationTime) DPQuarter,
    DATEPART(week,CreationTime) DPWeek
from Sales.Orders