SET search_path = balanced_tree;

--How many unique transactions were there?
Select Count(distinct txn_id) unique_transactions from sales;

-- What is the average unique products purchased in each transaction?
Select Count(prod_id) / Count(distinct txn_id) as average_products_per_transcation from sales;


-- What are the 25th, 50th and 75th percentile values for the revenue per transaction?
WITH revenue AS(
    SELECT
      txn_id,
      SUM(qty * price) AS revenue
    FROM
      sales
    GROUP BY
      txn_id
  )
Select
             percentile_cont(0.25) within group (order by revenue) as p_25,
             percentile_cont(0.5) within group (order by revenue) as p_50,
             percentile_cont(0.75) within group (order by revenue) as p_75
From revenue
      
--What is the average discount value per transaction?
With transcation_discount as(
Select Distinct txn_id,
	Sum(discount :: Numeric / 100 * price * qty) discounts
From sales s
Group By txn_id)
    
SELECT Round(Avg(discounts),2) as average_disconts FROM transcation_discount;

--What is the percentage split of all transactions for members vs non-members?
with members as(
Select Round(100 *Count(member):: Numeric
/(Select Count(txn_id) From sales)) as members_percentage From sales
Where member = 't'),

non_members as(
Select Round(100 *Count(member):: Numeric
/(Select Count(txn_id) From sales)) as non_members_percentage From sales
Where member = 'f')  


select members_percentage,non_members_percentage
from members,non_members;

--What is the average revenue for member transactions and non-member transactions?
Select (Select Avg(price * qty)From sales Where member = 't')
avg_members_revenue,
		(Select Avg(price * qty)From sales Where member = 'f' )
avg_non_members_revenue
From sales
Limit 1
	
