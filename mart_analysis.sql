select * from weekly_sales limit 10;
#Add a week_number as the second column for each week_date value, for
#example any value from the 1st of January to 7th of January will be 1, 8th to
#14th will be 2, etc.
create table clean_weekly_sales as
select week_date, week(week_date) as week_number,
month(week_date) as month_number,
year(week_date) as calander_year,
region,platform,
case
when segment=null then 'unknown'
else segment
end as segment,
case
when right(segment,1)='1' then 'young_adult'
when right(segment,1)='2' then 'middle_aged'
when right(segment,1) in ('3','4') then 'retirees'
else 'unknown'
end as age_band,
case
when left(segment,1)='C' then 'couple'
when left(segment,1)='F' then 'families'
else 'unknown'
end as demographics,
customer_type,transactions,sales,
round(sales/transactions,2) as avg_tranc
from weekly_sales;
# right(column name,position from the right)-this tells if 1 then the columns 1st postion from right
select * from clean_weekly_sales;

#1. Which week numbers are missing from the dataset?
# usually a year has 52 weeks but when we have a count of 12*4 =48. so need to find out which week is missing
create table seq100(x int not null auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
select * from seq100;
# now only 50 are entered so enter another 52
insert into seq100 select X+50 from seq100;
# inserting another 50 row num
select * from seq100;
# now create table seq 52 as we have only 52 weeks
create table seq52(select X from seq100 limit 52);
select * from seq52;
# so the result should be the week numbers that are not there in sales week
select X  as week_num from seq52
where X not in (select distinct week_number from clean_weekly_sales);
# this gives the only week numbers that are not in clean weekly sales
 
select distinct week_number from clean_weekly_sales
order by week_number asc;
select distinct week_number from clean_weekly_sales;

## 2.How many total transactions were there for each year in the dataset?
select * from clean_weekly_sales;
select calander_year,
sum(transactions) as total_transactions
from clean_weekly_sales
group by calander_year
order by calander_year asc;

# count of transactions
select calander_year,
count(transactions) as total_transactions
from clean_weekly_sales
group by calander_year
order by calander_year asc;
## 3.What are the total sales for each region for each month?
select * from clean_weekly_sales;
select region,month_number,
sum(sales) as total_sales from clean_weekly_sales
group by region,month_number
order by total_sales desc;

## 4.What is the total count of transactions for each platform
select * from clean_weekly_sales;
select platform ,
count(transactions) as total_tran
from clean_weekly_sales
group by platform;

## 5.What is the percentage of sales for Retail vs Shopify for each month?
with cte_monthly_platform_sales as(
select month_number,calander_year,platform,
sum(sales) as monthly_sales
from clean_weekly_sales
group by month_number,calander_year,platform)

select month_number,calander_year,
round(100*max(case when platform='Retail' then monthly_sales else null end)/sum(monthly_sales),2)
as retail_percent,
round(100*max(case when platform='Shopify' then monthly_sales else null end)/sum(monthly_sales),2)
as shopify_percent
from cte_monthly_platform_sales
group by month_number,calander_year; 

## 6.What is the percentage of sales by demographic for each year in the dataset?
select * from clean_weekly_sales;
select demographics,calander_year,
sum(sales) as yearly_sales,
round(100*sum(sales)/sum(sum(sales)) over (PARTITION BY demographics),2) as percentage
from clean_weekly_sales
group by demographics,calander_year
order by demographics,calander_year;

## 7.Which age_band and demographic values contribute the most to Retail sales?
select age_band,demographics,
sum(sales) as total_sales
from clean_weekly_sales
where platform='Retail'
group by age_band,demographics
order by total_sales desc;


