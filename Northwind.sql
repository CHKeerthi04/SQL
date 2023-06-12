select * from orders;
# how many unique order id are there
select count(distinct OrderID) from orders;
#ship vis-distinct count
select count(distinct ShipVia) from orders;
#ship city wise number of orders
select ShipCity,
 count(OrderId) as freq from orders 
group by ShipCity 
order by freq desc limit 5;
select ShipCity,
 count(OrderId) as freq 
 from orders 
 group by ShipCity 
 order by freq asc limit 5;

# Ship regionwise number of oredrs-top 10
select ShipRegion, count(orderID) as freq from orders 
group by ShipRegion 
order by freq desc limit 10;

# Ship regionwise number of oredrs-Bottom 10
select ShipRegion,
count(OrderID) as freq from orders 
group by ShipRegion 
order by freq asc limit 10;

## Ship country wise number of orders-top 10
select ShipCountry,count(OrderID) as Freq from orders 
group by ShipCountry 
order by Freq desc limit 10;

select ShipCountry,count(OrderID) as Freq from orders 
group by ShipCountry 
order by Freq asc limit 10;



#DESCRIPTIVE STATESTICS OF Frieght- Count,avg,minmax,stddev

select count(Freight), 
min(Freight),
max(Freight),
avg(Freight),
stddev(Freight) from orders;


#Create a new variable called orderdays based on required and shiped date

# FORMAT-Alter table , table name, add column, column name,type,length
#Calculation-update tablename set column columnnames =formula

alter table orders 
add column OrderDays bigint;

select * from orders;

update orders 
set OrderDays=datediff(ShippedDate,RequiredDate);

select min(OrderDays),
max(OrderDays),
avg(OrderDays),
std(OrderDays) from orders;

# create new 3 variable called early(less than 0) delay(greater then 0)
alter table orders 
add column deliverystatus char(12);

update orders set 
 deliverystatus = case when 
 OrderDays=0 then 'ontime' 
 when OrderDays<0 then 'early' else 'delay' end;
 
select deliverystatus,
 count(deliverystatus) from orders 
 group by deliverystatus;


# table- ORDERDETAILS

alter table `order details` add column Sales float(8);

update `order details` set Sales=UnitPrice*Quantity*(1-Discount);

select 
	min(Sales),
	max(Sales),
    round(avg(Sales)),
    round(std(Sales),2) 
from `order details`;


select * from `order details`;

# Customer country wise total sales
select country, round(sum(Sales)) as Totalsales from `order details`
natural join customers
natural join orders
group by Country order by TotalSales desc;

# Customer country wise avg sales desc

select country, round(avg(sales)) as avgsales from `order details`
natural join customers
natural join orders
group by Country order by avgsales desc;

# customer citywise total sales desc
select City, round(sum(Sales)) as Totalsales from `order details`
natural join customers
natural join orders
group by City 
order by Totalsales desc;

## customer citywise avg sales desc
select City, round(sum(Sales)) as avgsales from `order details`
natural join customers
natural join orders
group by City 
order by avgsales desc;

# top 20 customer company wise total sales
select CompanyName, round(sum(Sales)) as totalsales from `order details`
natural join customers
natural join orders
group by CompanyName
order by totalsales desc
limit 20;

## bottom 20 customer company wise total sales

select CompanyName, round(sum(Sales)) as totalsales from `order details`
natural join customers
natural join orders
group by CompanyName
order by totalsales asc
limit 20; 

#employee wise total sales


alter table employees drop Fullname;
#employee wise total sales
alter table employees add column Fullname varchar(25);
update employees set Fullname = concat_ws(FirstName,' ',LastName);

select Fullname, round(sum(Sales)) as totalsales from `order details`
natural join orders
natural join employees
group by Fullname
order by totalsales desc;

select * from employees;

#countrywise sales of each employee
select Fullname, customers.Country,(sum(Sales)) as totalsales from `order details`
natural join employees
natural join orders
join customers using (CustomerID)
group by Fullname
order by totalsales desc;

#19)# top 10 customers company name based on totalsales
select CompanyName,CustomerID,round(sum(Sales),2) as totalsales from customers
natural join orders
natural join `order details`
group by CompanyName
order by totalsales desc limit 10;

#20)Top 5 Customer companyname in USA based on TotalSales
select CustomerID,CompanyName,Country,round(sum(Sales),2) as totalsales from customers
natural join orders
natural join `order details`
where Country='USA'
group by CompanyName
order by totalsales desc limit 5;

#Year wise TotalSales (use ShippedDate from orders table)
select ShippedDate from orders;
select year(ShippedDate) as years,round(sum(Sales),2) as totalsales from orders
natural join `order details`
group by years
order by totalsales desc;

#Year, Quarter, Month wise TotalSales
select 
year(ShippedDate) as Y,
quarter(ShippedDate) as Q,
month(ShippedDate) as M ,
round(sum(Sales),2) as totalsales from orders
natural join `order details`
group by Y,M,Q
order by Q asc;

# 23) Calculate New Variable Purchases = 
#(UnitsinStock+UnitsonOder)*UnitPrice in products table
alter table products add column Purchases int(30);
update products set 
Purchases=(UnitsInStock+UnitsOnOrder)*UnitPrice;

# 24) Country Wise Purchases-customers
select Country,sum(Purchases) as total from products
natural join `order details`
natural join orders
natural join customers
group by Country
order by total desc;

select Country,sum(Purchases) as total from products
natural join suppliers
group by Country
order by total desc;

#25) Top 10 Purchase Company from France

select CompanyName,sum(Purchases) as totalpurchases from products
natural join suppliers
where Country='France'
group by CompanyName
order by totalpurchases desc;

# 26) Discountinued=1 means product discontinued. Identify productname
# that are discontinued and unitsinstock & unitsonorder
select ProductName,UnitsInStock,UnitsOnOrder,Discontinued from products
where Discontinued=1
group by ProductName;

# 27) Costliest and Cheapest unitprice
select max(UnitPrice) as costliest,
min(UnitPrice) as cheapest from products;

# 28) Costliest and Cheapest productname from Purchases
select ProductName,
max(Purchases) as maxpurchses,
min(Purchases) as minpurchses from products
order by ProductName desc;

# 29) Costliest and Cheapest productname sold to Customers
select CustomerID, ProductName,max(Purchases),min(Purchases) from products
natural join `order details`
natural join orders
natural join customers;

# 30) Create a report showing all customers from Germany, Mexico & Spain
# containing ContactName, City,Address.
select ContactName,City,Address,country from customers
where Country in ('Germany','Mexico','Spain');

# 31) Create a report showing all cities starting with F or M or L 
# contain contactname, city, address. Like F%
select ContactName,City,Address from customers
where city like 'F%'or city like'M%'or city like'L%'
order by city asc;

#32) Create a report OrderId, Requireddate,Shippeddate where shippeddate
# is greater than requireddate.
select OrderID,ShippedDate,RequiredDate from orders
where ShippedDate>RequiredDate
order by OrderID asc;

# 33) Create a report from employees table showing yearswithcompany as
# on 1996 containing conactenation of First & Last name, hireddate
alter table employees add column yearswithcompany int(20);
update employees set yearswithcompany=1996-year(HireDate);

select HireDate,FullName,yearswithcompany from employees;

# 34) Create a report of all orders in Q3 of 1995 containing orderid, shippeddate, Freight.
select OrderID,ShippedDate,Freight,
year(ShippedDate) as Year,
quarter(ShippedDate) as Qrtr from orders
where year(ShippedDate)=1995 and quarter(ShippedDate)= 3;




# 35) Create a report of Top 10 Freight with Orderid, shippeddate, country, companyname from customers
select OrderID,ShippedDate,Country,CompanyName,sum(Freight) from orders
natural join customers
group by CompanyName
order by sum(Freight) desc
limit 10;

# 36) Create a report of Top 20 customer companyname based on totalfreight
select CompanyName,sum(Freight) from customers
natural join orders
group by CompanyName
order by sum(Freight) desc
limit 20;

# 37) Create a Report of Top 5 companyname and country that ordered categoryname Confections
select CompanyName,Country,CategoryName,sum(Purchases) from categories
natural join `order details`
natural join products
natural join orders
natural join customers
where CategoryName='Confections'
group by CompanyName
order by sum(Purchases) desc
limit 5;

# 38) Create a Report of Top 5 companyname and country that supplied categoryname Confections
select CompanyName,Country,CategoryName,sum(Purchases) from categories
natural join suppliers
natural join products
where CategoryName='Confections'
group by CompanyName
order by sum(Purchases) desc
limit 5;

# 39) Create a report where Categorynamewise number of products with unit price greather 20.
select CategoryID,count(ProductID),UnitPrice from products
where UnitPrice>20
group by CategoryID
order by count(ProductID) desc;