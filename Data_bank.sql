#How many different nodes make up the Data Bank network?
select * from customer_nodes limit 10;
select count(distinct(node_id)) as unique_node
from customer_nodes;
# count of distinct node ids in data bank
select node_id,count(node_id) 
from customer_nodes
group by node_id
order by count(node_id);

#How many nodes are there in each region?
select region_id,node_id,count(node_id)
from customer_nodes
natural join regions
group by region_id,node_id;
# natural join doest require to mention the common column

# using inner join-grouping node and region
select region_id, node_id,count(node_id)
from customer_nodes
inner join regions using(region_id)
group by region_id,node_id;

#How many customers are divided among the regions?
select region_id,count(customer_id)
from customer_nodes
inner join regions using (region_id)
group by region_id;

#Determine the total amount of transactions for each region name.
select region_name,sum(txn_amount)
from regions
natural join customer_transactions
natural join customer_nodes
group by region_name
order by sum(txn_amount) desc;

#How long does it take on an average to move clients to a new node?
select * from customer_nodes;
select end_date,count(end_date) from customer_nodes
group by end_date;
# end date has insigvalue 9999-12-31 so we need to exclude it
select round(avg(datediff(end_date,start_date)),2) as avg_days
from customer_nodes where end_date!='9999-12-31';

#What is the unique count and total amount for each transaction type?
select txn_type,count(txn_type),sum(txn_amount) from customer_transactions
group by txn_type;

#What is the average number and size of past deposits across all customers?
select round(count(customer_id)/(select count(distinct customer_id) from customer_transactions))
as avg_deposit_count from customer_transactions where txn_type='deposit';

#For each month - how many Data Bank customers make more than 1 deposit and at least either 1 purchase or 1 
#withdrawal in a single month?
select * from customer_transactions group by txn_type;
# with cte
with count_cust_cte as
(select customer_id,month(txn_date) as month_tranc,
sum(if(txn_type='deposit',1,0)) as deposit_count,
sum(if(txn_type='purchase',1,0)) as purchase_count,
sum(if(txn_type='withdrawl',1,0)) as withdrawl_count
from customer_transactions group by customer_id,month(txn_date))

select month_tranc,count(distinct customer_id) as cust_count
from count_cust_cte
where deposit_count>1
and(purchase_count=1 or withdrawl_count=1)
group by month_tranc;

