-- https://datalemur.com/questions/sql-highest-grossing

/*
Assume you are given the table containing information on Amazon customers and their spending on products in various categories.

Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.
*/


With spending_cte as (
SELECT category,product,SUM(spend) as total_spend,
  RANK() OVER(PARTITION BY category 
  ORDER BY SUM(spend) DESC) as RANK
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY 1,2)

SELECT category,product,total_spend
FROM spending_cte 
WHERE rank <=2

