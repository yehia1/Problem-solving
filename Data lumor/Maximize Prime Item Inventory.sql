-- https://datalemur.com/questions/prime-warehouse-storage
/*
Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse.
It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse.
Output the item type with prime_eligible followed by not_prime and the maximum number of items that can be stocked.

Effective April 3rd 2023, we added some new assumptions to the question to provide additional clarity.

Assumptions:

Prime and non-prime items have to be stored in equal amounts, regardless of their size or square footage.
This implies that prime items will be stored separately from non-prime items in their respective containers, but within each container, all items must be in the same amount.
Non-prime items must always be available in stock to meet customer demand, so the non-prime item count should never be zero.
Item count should be whole numbers (integers).

*/
WITH sum_count_cte as(
SELECT item_type,SUM(square_footage) as total_sqft,
COUNT(*) as item_count
FROM inventory
GROUP BY item_type),

prime_items as(
SELECT item_type,total_sqft,
Floor(500000/total_sqft) as prime_combined_count_fill_storage,
Floor(500000/total_sqft) *item_count as items_prime
FROM sum_count_cte
WHERE item_type = 'prime_eligible')

SELECT item_type,
  CASE 
    WHEN item_type = 'prime_eligible'
      THEN (SELECT items_prime FROM prime_items)
    WHEN item_type = 'not_prime'
      THEN Floor((500000 - 
            (SELECT total_sqft * prime_combined_count_fill_storage FROM prime_items)) 
                / total_sqft) *item_count
      END AS item_count
FROM sum_count_cte
ORDER BY item_count DESC
