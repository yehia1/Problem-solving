- https://datalemur.com/questions/alibaba-compressed-mean
'''
You are trying to find the mean number of items bought per order on Alibaba, rounded to 1 decimal place.

However, instead of doing analytics on all Alibaba orders, you have access to a summary table, which describes how many items were in an order (item_count),
 and the number of orders that had that many items (order_occurrences).
'''

SELECT ROUND(SUM(item_count * order_occurrences) :: Numeric /
SUM(order_occurrences),1) as mean
FROM items_per_order