Set
	search_path = pizza_runner;
    
-- What was the maximum number of pizzas delivered in a single order?
Select order_id,count(pizza_id) as number_of_pizzas
From customer_orders c
group by order_id
order by number_of_pizzas desc
Limit 1

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?


--How many pizzas were delivered that had both exclusions and extras?

-- What was the total volume of pizzas ordered for each hour of the day?

-- What was the volume of orders for each day of the week?