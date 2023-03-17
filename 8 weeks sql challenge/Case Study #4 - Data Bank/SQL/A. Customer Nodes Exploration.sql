SET search_path = data_bank;

--How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) as Unique_nodes
From customer_nodes;

-- What is the number of nodes per region?
SELECT region_id,COUNT(node_id) as number_of_nodes
From customer_nodes
Group By region_id
Order By region_id;


-- How many customers are allocated to each region?
Select c.region_id,region_name,Count(customer_id) number_of_customers
From regions r
Inner Join customer_nodes c
On r.region_id = c.region_id
Group By c.region_id,region_name
Order By c.region_id;

--How many days on average are customers reallocated to a different node?
With diff_date as (
Select customer_id,node_id,start_date,end_date,
end_date - start_date as diff
From customer_nodes 
Where end_date != '9999-12-31'
Order By 1),

sum_diff as(
Select customer_id,node_id,Sum(diff) as sum_d From diff_date
Group By customer_id,node_id)

Select Round(Avg(sum_d),2) from sum_diff;


-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region
With diff_date as (
Select customer_id,region_name,node_id,start_date,end_date,
end_date - start_date as diff
From customer_nodes c
Inner join regions r
On r.region_id = c.region_id
Where end_date != '9999-12-31'
Order By 1),

sum_diff as(Select customer_id,region_name,node_id,Sum(diff) as sum_d From diff_date
Group By customer_id,node_id,region_name
Order By 1,3)

SELECT
	region_name,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY sum_d) AS "50th_perc",
	PERCENTILE_CONT(0.8) WITHIN GROUP(ORDER BY sum_d) AS "80th_perc",
	PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY sum_d) AS "95th_perc"
FROM sum_diff
Group By region_name



