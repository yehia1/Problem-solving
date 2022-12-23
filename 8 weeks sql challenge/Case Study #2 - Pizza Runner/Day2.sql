Set
	search_path = pizza_runner;
    
-- What was the maximum number of pizzas delivered in a single order?
Select order_id,count(pizza_id) as number_of_pizzas
From cleaned_customer c
group by order_id
order by number_of_pizzas desc
Limit 1;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,
	sum(case 
    	when exclusions is not null or extras is not null then 1
        else 0 END) as at_least_1_change,
    	sum(case 
    	when exclusions is null and extras is null then 1
        else 0 END) as No_Change
    from cleaned_customer c
    inner join cleaned_runner r 
    on c.order_id = r.order_id
    where distance != 0 
    group by customer_id
    order by customer_id;

--How many pizzas were delivered that had both exclusions and extras?
SELECT sum(case 
    	when exclusions is not null and extras is not null then 1
        else 0 END) as Both_extras_and_exclusions_del
    from cleaned_customer c
    inner join cleaned_runner r 
    on c.order_id = r.order_id
    where distance != 0;

-- What was the total volume of pizzas ordered for each hour of the day?
Select EXTRACT(HOUR FROM order_time)as hours,count(order_id) as total_orders
	From cleaned_customer
    group by hours
    order by hours;

-- What was the volume of orders for each day of the week?
Select to_char(order_time + INTERVAL '2 day','Day') as day_of_week, count(order_id) as total_orders -- adding 2 to the day because it's starts from monday
	From cleaned_customer
    group by day_of_week
    order by day_of_week;