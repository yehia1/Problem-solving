set search_path = pizza_runner;

-- How many pizzas were ordered?
Select Count(order_id) as total_orders
From customer_orders;

-- How many unique customer orders were made?
SELECT 
  COUNT(DISTINCT order_id) AS unique_order_count
FROM customer_orders;

-- How many successful orders were delivered by each runner?
SELECT 
  runner_id, 
  COUNT(order_id) AS successful_orders
FROM runner_orders
WHERE distance != 'null'
GROUP BY runner_id
ORDER by runner_id;

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
ORDER BY c.customer_id;

-- What was the maximum number of pizzas delivered in a single order?
with max_nums_of_pizzas as (
Select order_id,Count(pizza_id) as number_of_pizzas
From cleaned_customer c
Group By order_id
Order By number_of_pizzas)

Select Max(number_of_pizzas) as max_nums_of_pizzas
From max_nums_of_pizzas;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,
	Sum(Case 
    	When exclusions is not null or extras is not null then 1
        Else 0 END) as at_least_1_change,
    Sum(case 
    	When exclusions is null and extras is null then 1
        Else 0 END) as No_Change
From cleaned_customer c
Inner Join cleaned_runner r 
On c.order_id = r.order_id
Where distance != 0 
Group by customer_id
Order by customer_id;

-- How many pizzas were delivered that had both exclusions and extras?
SELECT 
	Sum(Case 
    	When exclusions is not null and extras is not null then 1
        Else 0 END) as Both_extras_and_exclusions_pizza
From cleaned_customer c
Inner join cleaned_runner r 
On c.order_id = r.order_id
Where distance != 0;

-- What was the total volume of pizzas ordered for each hour of the day?
Select EXTRACT(HOUR FROM order_time)as hours,
		Count(order_id) as total_orders
From cleaned_customer
Group By hours
Order By hours;

-- What was the volume of orders for each day of the week?
Select to_char(order_time + INTERVAL '2 day','Day') as day_of_week, -- adding 2 to the day because it's starts from monday
    Count(order_id) as total_orders
From cleaned_customer
Group By day_of_week
Order By day_of_week;