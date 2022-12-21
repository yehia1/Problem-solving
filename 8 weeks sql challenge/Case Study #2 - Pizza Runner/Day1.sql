SET
  search_path = pizza_runner;

--How many pizzas were ordered?
SELECT count(order_id) as total_orders
from customer_orders;

--How many unique customer orders were made?
SELECT 
  COUNT(DISTINCT order_id) AS unique_order_count
FROM customer_orders;


--How many successful orders were delivered by each runner?
SELECT 
  runner_id, 
  COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE distance != 'null'
GROUP BY runner_id
order by runner_id;

-- How many of each type of pizza was delivered?
SELECT pizza_name,COUNT(c.pizza_id)
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
JOIN pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != 'null'
GROUP BY p.pizza_name;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT c.customer_id,pizza_name,COUNT(c.pizza_id)
FROM customer_orders c
inner join pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id,pizza_name
ORDER BY c.customer_id