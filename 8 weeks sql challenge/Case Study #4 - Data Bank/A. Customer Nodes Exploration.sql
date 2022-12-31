SET search_path = data_bank;

--How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) as Unique_nodes
From customer_nodes;

-- What is the number of nodes per region?
SELECT region_id,COUNT(node_id) as number_of_nodes
From customer_nodes
Group by region_id
order by region_id;


-- How many customers are allocated to each region?
Select c.region_id,region_name,count(customer_id) number_of_customers
from regions r
inner join customer_nodes c
on r.region_id = c.region_id
group by c.region_id,region_name
order by c.region_id;

--How many days on average are customers reallocated to a different node?
With diff_date as (
Select customer_id,node_id,start_date,end_date,
end_date - start_date as diff
from customer_nodes 
where end_date != '9999-12-31'
order by 1),

sum_diff as(
Select customer_id,node_id,sum(diff) as sum_d from diff_date
group by customer_id,node_id)

Select round(avg(sum_d),2) from sum_diff;


-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region
With diff_date as (
Select customer_id,region_name,node_id,start_date,end_date,
end_date - start_date as diff
from customer_nodes c
inner join regions r
on r.region_id = c.region_id
where end_date != '9999-12-31'
order by 1),

sum_diff as(Select customer_id,region_name,node_id,sum(diff) as sum_d from diff_date
group by customer_id,node_id,region_name
order by 1,3)

SELECT
	region_name,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY sum_d) AS "50th_perc",
	PERCENTILE_CONT(0.8) WITHIN GROUP(ORDER BY sum_d) AS "80th_perc",
	PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY sum_d) AS "95th_perc"
FROM sum_diff
group by region_name



