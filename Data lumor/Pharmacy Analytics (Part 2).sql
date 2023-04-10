-- https://datalemur.com/questions/non-profitable-drugs
'''
CVS Health is trying to better understand its pharmacy sales, and how well different products are selling.
 Each drug can only be produced by one manufacturer.

Write a query to find out which manufacturer is associated with the drugs that were not profitable and how much money CVS lost on these drugs. 

Output the manufacturer, number of drugs and total losses.
 Total losses should be in absolute value. Display the results with the highest losses on top.

'''

SELECT manufacturer,
  COUNT(product_id) as drug_count,
  SUM(abs(total_sales - cogs)) as total_loss
FROM pharmacy_sales 
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss desc