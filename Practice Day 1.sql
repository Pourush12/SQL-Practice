select 
	country,
	count(id) as [Number of Customers],
	sum(score) as [Total Score]
from customers
group by country

select 
	country,
	avg(score) as [Average score]
from customers
where score != 0
group by country
having avg(score) > 430

select 
	distinct(country)
from customers

select top 3 *
from customers

select top 3 *
from customers
order by score desc

select top 2 *
from customers
order by score asc

select top 2 *
from orders
order by order_date desc

create table persons (
	id int not null, 
	person_name varchar(50) not null, 
	birth_date date, 
	phone varchar(15) not null,
	constraint pk_persons primary key (id)
)

alter table persons
add email varchar(50) not null

select *
from persons

alter table persons
drop column phone

select *
from persons

drop table persons

insert into customers (id,first_name,country,score)
values 
	(6,'Anna','India',Null),
	(7,'Sam',Null,100),
	(8,'USA','Max',Null),
	(9,'Andreas','Germany',Null),
	(10,'Sahra',Null,null)

delete customers 
where id > 5

select * from customers

select * from persons

insert into persons(id,person_name,birth_date,phone)
select
	id,
	first_name,
	NULL,
	'Unknown'
from customers

select * from persons

update customers
set score = 0
where id =6

select * 
from customers

update customers
set score = 0, country = 'UK'
where id = 10

update customers
set score = 0
where score is null

select *
from customers

delete from customers
where id > 5

select *
from customers

truncate table persons

select * from persons

-- Operators
select * 
from customers
where country = 'Germany'

select * 
from customers
where country != 'Germany'

select *
from customers
where score > 500

select *
from customers
where score >= 500

select *
from customers
where score < 500

select *
from customers
where score <= 500

select *
from customers
where country = 'USA' and score > 500

select *
from customers
where country = 'USA' or score > 500

select *
from customers
where not score < 500

select *
from customers
where score >= 500

select *
from customers
where score between 100 and 500

select *
from customers
where score >=100 and score <=500

select *
from customers
where country in ('Germany','USA')

select *
from customers
where first_name like '%M%'

select *
from customers
where first_name like '%n%'

select *
from customers
where first_name like '%r%'

select *
from customers
where first_name like '__r%'

-- Joins

-- No Join
select *
from customers

select *
from orders

-- Inner Join
select *
from customers c 
inner join orders o
on c.id = o.customer_id

select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
inner join orders o
on c.id = o.customer_id

-- Left Join
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
left join orders o
on c.id = o.customer_id

-- Right Join
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
right join orders o
on c.id = o.customer_id

-- Same can be done using the left join just replace the tables
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from orders o 
left join customers c
on c.id = o.customer_id

-- Full Join
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
full join orders o
on c.id = o.customer_id

-- Left Anti Join
select
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
left join orders o
on c.id = o.customer_id
where o.customer_id is null

-- Right Anti Join
select
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
right join orders o
on c.id = o.customer_id
where c.id is null

-- Same can be done using the left join just replace the tables
select
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from orders o
left join customers c
on c.id = o.customer_id
where c.id is null

-- Full Anti Join
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
full join orders o
on c.id	= o.customer_id
where c.id is null or o.customer_id is null

-- Inner Join but without inner join statement
-- 1
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
full join orders o
on c.id	= o.customer_id
where c.id is not null and o.customer_id is not null

-- 2
select 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
from customers c
left join orders o
on c.id	= o.customer_id
where o.customer_id is not null

-- Cross Join
select *
from customers c
cross join orders o

use SalesDB

-- Multiple Joins
select *
from Sales.Customers
select *
from Sales.Employees
select *
from Sales.Orders
select *
from Sales.Products

select 
	so.OrderID,
	sc.FirstName as [Customer First Name],
	sc.LastName as [Customer Last Name],
	sp.Product,
	so.Sales,
	sp.Price,
	se.FirstName as [Employee First Name],
	se.LastName as [Employee Last Name]
from Sales.Orders so
left join Sales.Customers sc on so.CustomerID = sc.CustomerID
left join Sales.Products sp on so.ProductID = sp.ProductID
left join Sales.Employees se on so.SalesPersonID = se.EmployeeID

