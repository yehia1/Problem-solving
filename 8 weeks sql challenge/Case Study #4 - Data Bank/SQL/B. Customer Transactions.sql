SET search_path = data_bank;

-- What is the unique count and total amount for each transaction type?
Select txn_type,Count(distinct txn_amount),Sum(txn_amount)
From customer_transactions
Group by txn_type;

-- What is the average total historical deposit counts and amounts for all customers?
Select Count(*) count_of_deposits,
	Round(Avg(txn_amount),2) as avergae_amount
From customer_transactions
Where txn_type = 'deposit';

--For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
WITH monthly_transactions AS (
  SELECT 
    customer_id, 
    Extract(month from txn_date) AS month,
    SUM(CASE WHEN txn_type = 'deposit' THEN 0 ELSE 1 END) AS deposit_count,
    SUM(CASE WHEN txn_type = 'purchase' THEN 0 ELSE 1 END) AS purchase_count,
    SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS withdrawal_count
  FROM customer_transactions
  GROUP BY customer_id, month
 )

SELECT
  month,
  COUNT(DISTINCT customer_id) AS customer_count
FROM monthly_transactions
WHERE deposit_count > 1 
  AND (purchase_count > 1 OR withdrawal_count > 1)
GROUP BY month
ORDER BY month;