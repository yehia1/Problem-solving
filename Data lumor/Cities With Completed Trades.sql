-- https://datalemur.com/questions/completed-trades

'''
You are given the tables below containing information on Robinhood trades and users.
 Write a query to list the top three cities that have the most completed trade orders in descending order.

Output the city and number of orders.
'''

SELECT city,COUNT(order_id) total_orders
FROM trades t
JOIN users u 
ON u.user_id = t.user_id
WHERE status = 'Completed'
GROUP BY city
ORDER BY COUNT(order_id) DESC
limit 3