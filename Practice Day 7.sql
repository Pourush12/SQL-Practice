-- Assign unique id's to the rows of the 'Order Archive' Tabel

select 
	ROW_NUMBER() OVER(Order by OrderID, OrderDate) UniqueID,
	*
from Sales.OrdersArchive

-- Identify duplicates rows in the table 'Order Archive' and return a clean resut without any duplicates
select *
from(
select 
	*,
	ROW_NUMBER() OVER(Partition by OrderID Order by CreationTime desc) as RowNumber
from Sales.OrdersArchive)t where RowNumber > 1

-- NTILE()
select
	OrderID,
	Sales,
	NTILE(1) OVER(Order by Sales DESC) OneBucket,
	NTILE(2) OVER(Order by Sales DESC) TwoBucket,
	NTILE(3) OVER(Order by Sales DESC) ThreeBucket,
	NTILE(4) OVER(Order by Sales DESC) FourBucket,
	NTILE(5) OVER(Order by Sales DESC) FiveBucket
from Sales.Orders

-- Segment all orders into 3 categories: high, medium and low sales
select
	OrderID,
	ProductID,
	Sales,
	Case
		when ThreeBucket = 1 then 'High Sales'
		when ThreeBucket = 2 then 'Medium Sales'
		when ThreeBucket = 3 then 'Low Sales'
		else 'N/A'
	end SalesCategory
from(
select
	*,
	NTILE(3) OVER(Order by Sales DESC) ThreeBucket
from Sales.Orders)t

-- In order to export the date, divide the orders into 2 groups
select 
	*,
	NTILE(2) OVER(Order by OrderID) Buckets
from Sales.Orders

-- Percentage based ranking
-- CUME_DIST() & PERCENT_RANK()
-- Find the products that fall witin the highest 40% of prices
select *
from(
select 
	*,
	CUME_DIST() OVER(Order by Price desc) PercentPrice
from Sales.Products)t where PercentPrice <= 0.4

