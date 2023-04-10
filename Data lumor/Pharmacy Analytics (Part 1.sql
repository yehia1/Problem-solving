-- https://datalemur.com/questions/top-profitable-drugs

SELECT drug ,sum(total_sales	- cogs)
FROM pharmacy_sales
GROUP BY drug
ORDER BY 2 DESC
LIMIT 3