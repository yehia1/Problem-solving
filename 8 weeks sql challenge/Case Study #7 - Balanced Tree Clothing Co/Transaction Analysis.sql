SET search_path = balanced_tree;

--How many unique transactions were there?
Select count(distinct txn_id) unique_transactions from sales;

-- What is the average unique products purchased in each transaction?
Select count(prod_id) / count(distinct txn_id) as average_products_per_transcation from sales;


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
select
             percentile_cont(0.25) within group (order by revenue) as p_25,
             percentile_cont(0.5) within group (order by revenue) as p_50,
             percentile_cont(0.75) within group (order by revenue) as p_75
      from revenue
      
