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

-- What is the closing balance for each customer at the end of the month?
With all_months as(
SELECT DISTINCT 
        customer_id,
        DATE_TRUNC('month', generate_series(
            (SELECT MIN(txn_date) FROM customer_transactions), 
            (SELECT MAX(txn_date) FROM customer_transactions), 
            '1 month'
        )) AS month
FROM customer_transactions),

closing_balance AS (
	SELECT
		a.customer_id,
		txn_amount,
		date_part('Month', month) AS txn_month,
		SUM(
			CASE
	        	WHEN txn_type = 'deposit' THEN txn_amount
	        	ELSE -txn_amount  -- Subtract transaction if not a deposit  
			END
		) AS transaction_amount
	FROM
  		all_months a
		Left Join customer_transactions c
 		On a.customer_id = c.customer_id
  		And a.month = DATE_TRUNC('month', c.txn_date)
	GROUP BY
		a.customer_id,
		txn_month,
		txn_amount
	ORDER BY
		a.customer_id
),

get_all_transactions_per_month as(
SELECT customer_id,
	       txn_month,
	       transaction_amount,
	       sum(transaction_amount) over(PARTITION BY customer_id ORDER BY txn_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance,
	       row_number() OVER (PARTITION BY customer_id,txn_month ORDER BY txn_month desc) AS rank
FROM closing_balance
ORDER BY 
		customer_id,
		txn_month)
        
Select customer_id,txn_month,closing_balance
From get_all_transactions_per_month
Where rank = 1
Order By customer_id,txn_month

-- What is the percentage of customers who increase their closing balance by more than 5%?
With all_months as(
SELECT DISTINCT 
        customer_id,
        DATE_TRUNC('month', generate_series(
            (SELECT MIN(txn_date) FROM customer_transactions), 
            (SELECT MAX(txn_date) FROM customer_transactions), 
            '1 month'
        )) AS month
FROM customer_transactions),

closing_balance AS (
	SELECT
		a.customer_id,
		txn_amount,
		date_part('Month', month) AS txn_month,
		SUM(
			CASE
	        	WHEN txn_type = 'deposit' THEN txn_amount
	        	ELSE -txn_amount  -- Subtract transaction if not a deposit  
			END
		) AS transaction_amount
	FROM
  		all_months a
		Left Join customer_transactions c
 		On a.customer_id = c.customer_id
  		And a.month = DATE_TRUNC('month', c.txn_date)
	GROUP BY
		a.customer_id,
		txn_month,
		txn_amount
	ORDER BY
		a.customer_id
),

get_all_transactions_per_month as(
SELECT customer_id,
	       txn_month,
	       transaction_amount,
	       sum(transaction_amount) over(PARTITION BY 			customer_id ORDER BY txn_month ROWS BETWEEN UNBOUNDED 			PRECEDING AND CURRENT ROW) AS closing_balance,
	       row_number() OVER (PARTITION BY customer_id, 		txn_month ORDER BY txn_month desc) AS rank
FROM closing_balance
ORDER BY 
		customer_id,
		txn_month),

leading_balance as (
Select customer_id,txn_month,closing_balance,
lead(closing_balance,1) over() as leading_balance
From get_all_transactions_per_month
Where rank = 1 
Order By customer_id,txn_month),


customer_percentage as (
Select customer_id,txn_month,
	100 * ((leading_balance - closing_balance)/closing_balance)
   as increase_percentage
From leading_balance)

Select 100 * (count(customer_id)) / (Select count(customer_id)
                                     From customer_percentage)
as number_of_increase_percentage
From customer_percentage 
Where increase_percentage > 5
