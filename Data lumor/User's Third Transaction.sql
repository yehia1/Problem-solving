-- https://datalemur.com/questions

'''
This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on Uber transactions made by users.
 Write a query to obtain the third transaction of every user.
 Output the user id, spend and transaction date.
'''

WITH cte as(
SELECT user_id,spend,
RANK() over(PARTITION BY user_id ORDER BY transaction_date) rank,
transaction_date
FROM transactions )

SELECT user_id,spend,transaction_date
FROM cte
WHERE RANK = 3
