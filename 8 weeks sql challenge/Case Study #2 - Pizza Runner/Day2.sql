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

-- What was the total volume of pizzas ordered for each hour of the day?

-- What was the volume of orders for each day of the week?
