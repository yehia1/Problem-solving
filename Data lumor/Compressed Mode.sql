-- https://datalemur.com/questions/alibaba-compressed-mode
/*
You are trying to find the most common (aka the mode) number of items bought per order on Alibaba.

However, instead of doing analytics on all Alibaba orders, you have access to a summary table,
which describes how many items were in an order (item_count), and the number of orders that had that many items (order_occurrences).

In case of multiple item counts, display the item_counts in ascending order.
*/
SELECT item_count as item_count
FROM items_per_order
WHERE order_occurrences = (SELECT MAX(order_occurrences)
FROM items_per_order) 
