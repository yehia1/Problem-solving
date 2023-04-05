-- https://datalemur.com/questions/sql-avg-review-ratings
'''
Given the reviews table, write a query to get the average stars for each product every month.

The output should include the month in numerical value, product id, and average star rating rounded to two decimal places.
 Sort the output based on month followed by the product id.

'''

SELECT EXTRACT(month FROM submit_date) as month, product_id,
  Round(AVG(stars),2)
FROM reviews
GROUP BY month,product_id
ORDER BY month,product_id
