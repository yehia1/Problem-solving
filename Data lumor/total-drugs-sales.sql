-- https://datalemur.com/questions/total-drugs-sales

SELECT manufacturer, '$'|| ROUND(SUM(total_sales)/1000000)|| ' million' as sale
FROM pharmacy_sales 
GROUP BY manufacturer
ORDER BY sum(total_sales) desc
