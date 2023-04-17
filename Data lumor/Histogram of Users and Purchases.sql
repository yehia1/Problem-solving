-- https://datalemur.com/questions/histogram-users-purchases

/*
Assume you are given the table on Walmart user transactions.
Based on a user's most recent transaction date, write a query to obtain the users and the number of products bought.

Output the user's most recent transaction date, user ID and the number of products sorted by the transaction date in chronological order.
*/

WITH date_rank_cte as (
SELECT transaction_date, user_id,
dense_rank() over(PARTITION BY user_id ORDER BY transaction_date DESC) rank
FROM user_transactions
ORDER BY transaction_date,user_id DESC)

SELECT transaction_date,user_id,COUNT(*)
FROM date_rank_cte
WHERE rank = 1
GROUP BY transaction_date, user_id
