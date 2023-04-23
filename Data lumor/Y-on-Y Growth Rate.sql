-- https://datalemur.com/questions/yoy-growth-rate

/*
Assume you are given the table below containing information on user transactions for particular products.
Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.

Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).
*/

WITH curr_lag_cte as(
SELECT EXTRACT(year FROM transaction_date) as year,
product_id,spend as curr_year_spend,lag(spend,1) 
OVER(PARTITION BY product_id) as prev_year_spend
FROM user_transactions) 

SELECT year,product_id,curr_year_spend,prev_year_spend,
ROUND(100 *(curr_year_spend - prev_year_spend) / prev_year_spend,2)
FROM curr_lag_cte