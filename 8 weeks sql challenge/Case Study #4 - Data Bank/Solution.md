# 🏦 Case Study #4 - Data Bank
## Customer Nodes Exploration
### 1.How many unique nodes are there on the Data Bank system?
```
SELECT COUNT(DISTINCT node_id) as Unique_nodes
From customer_nodes;
```
| unique_nodes |
| ------------ |
| 5            |
### 2.What is the number of nodes per region?
```
SELECT region_id,COUNT(node_id) as number_of_nodes
From customer_nodes
Group By region_id
Order By region_id;
```
| region_id | number_of_nodes |
| --------- | --------------- |
| 1         | 770             |
| 2         | 735             |
| 3         | 714             |
| 4         | 665             |
| 5         | 616             |
### 3.How many customers are allocated to each region?
```
Select c.region_id,region_name,Count(customer_id) number_of_customers
From regions r
Inner Join customer_nodes c
On r.region_id = c.region_id
Group By c.region_id,region_name
Order By c.region_id;
```
| region_id | region_name | number_of_customers |
| --------- | ----------- | ------------------- |
| 1         | Australia   | 770                 |
| 2         | America     | 735                 |
| 3         | Africa      | 714                 |
| 4         | Asia        | 665                 |
| 5         | Europe      | 616                 |
### 4.How many days on average are customers reallocated to a different node?
```
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
```
| average |
| ----- |
| 23.57 |
### 5.What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
```
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
```
| region_name | 50th_perc | 80th_perc         | 95th_perc         |
| ----------- | --------- | ----------------- | ----------------- |
| Africa      | 22        | 35                | 54                |
| America     | 22        | 34                | 53.69999999999999 |
| Asia        | 22        | 34.60000000000002 | 52                |
| Australia   | 21        | 34                | 51                |
| Europe      | 23        | 34                | 51.39999999999998 |
***
## B. Customer Transactions
### 1.What is the unique count and total amount for each transaction type?
```
Select txn_type,Count(distinct txn_amount),Sum(txn_amount)
From customer_transactions
Group by txn_type;
```
| txn_type   | count | sum     |
| ---------- | ----- | ------- |
| deposit    | 929   | 1359168 |
| purchase   | 815   | 806537  |
| withdrawal | 804   | 793003  |
### 2.What is the average total historical deposit counts and amounts for all customers?
```
Select Count(*) count_of_deposits,
	Round(Avg(txn_amount),2) as avergae_amount
From customer_transactions
Where txn_type = 'deposit';
```
| count_of_deposits | avergae_amount |
| ----------------- | -------------- |
| 2671              | 508.86         |
### 3.For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
```
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
```
| month | customer_count |
| ----- | -------------- |
| 1     | 158            |
| 2     | 240            |
| 3     | 263            |
| 4     | 86             |

### What is the closing balance for each customer at the end of the month?
stupid hard question i took almost alot of thinkin to solve this question I searched for solution and i found some one isn't complete but i made it better From this [linkl](https://github.com/iweld/8-Week-SQL-Challenge/blob/main/Case%20Study%204%20-%20Data%20Bank/questions_and_answers.md)
I made him generate all the months balance.
```
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

```
| customer_id | txn_month | closing_balance |
| ----------- | --------- | --------------- |
| 1           | 1         | 312             |
| 1           | 2         | 312             |
| 1           | 3         | -640            |
| 1           | 4         | -640            |
| 2           | 1         | 549             |
| 2           | 2         | 549             |
| 2           | 3         | 610             |
| 2           | 4         | 610             |
| 3           | 1         | 144             |
| 3           | 2         | -821            |
### What is the percentage of customers who increase their closing balance by more than 5%?
I used this to calculate the number of customers who increase the colosing balance for each month for each customer who increase by 5% at least in one month using the last huge query 
```
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
```

| number_of_increase_percentage |
| ------------------------ |
| 33                      |