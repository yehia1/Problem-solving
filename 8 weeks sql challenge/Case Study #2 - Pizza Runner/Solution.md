# 🍕 Case Study #2: Pizza Runner
## Cleaning the data 
Making a temp tables that is cleaned 
and make some changes on the data like the delivery duration.
```
Create TEMP TABLE cleaned_customer as
 SELECT 
 	order_id,
    customer_id,
    pizza_id,
    CASE
    	WHEN exclusions LIKE '' or exclusions LIKE 'null' THEN NULL
        ELSE exclusions
        END AS exclusions,
 	CASE
    	WHEN extras LIKE '' or extras LIKE 'null' THEN NULL
        ELSE extras
        END AS extras,
    order_time
 FROM pizza_runner.customer_orders;
 
Create TEMP TABLE cleaned_runner as
	SELECT
    	order_id,
        runner_id,
        Cast(CASE
        	WHEN pickup_time LIKE '' 
            or pickup_time LIKE 'null' THEN NULL
            ELSE pickup_time
            END as TIMESTAMP) as pickup_time,
        Cast(CASE
        	WHEN distance LIKE '' 
            or distance LIKE 'null' THEN NULL
            WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
            Else distance
            END as Float) as distance,
        CAST(CASE
        	WHEN duration LIKE '' 
            or duration LIKE 'null' THEN NULL
            WHEN duration LIKE '%mins'
            THEN TRIM('mins' FROM duration)
            WHEN duration LIKE '%minutes'
            THEN TRIM('minutes' FROM duration)
            WHEN duration LIKE '%minute'
            THEN TRIM('minute' FROM duration)
            Else duration
            END as Float) as duration,
        CASE
        	WHEN cancellation LIKE 'NAN' 
            or cancellation LIKE 'null'
            or cancellation LIKE '' THEN NULL
            ELSE cancellation
            END as cancellation
FROM pizza_runner.runner_orders;
```
***
## A. Pizza Metrics
### How many pizzas were ordered?
```
Select Count(order_id) as total_orders
From customer_orders;
```
| total_orders |
| ------------ |
| 14           |
### How many unique customer orders were made?
```
SELECT 
  COUNT(DISTINCT order_id) AS unique_order_count
FROM customer_orders;
```
| unique_order_count |
| ------------------ |
| 10                 |
### How many successful orders were delivered by each runner?
```
SELECT pizza_name,COUNT(c.pizza_id)
FROM customer_orders AS c
JOIN runner_orders AS r
  ON c.order_id = r.order_id
JOIN pizza_names AS p
  ON c.pizza_id = p.pizza_id
WHERE r.distance != 'null'
GROUP BY p.pizza_name;
```
| pizza_name | number_of_pizza_delivered |
| ---------- | ------------------------- |
| Meatlovers | 9                         |
| Vegetarian | 3                         |
### How many Vegetarian and Meatlovers were ordered by each customer?
```
SELECT c.customer_id,pizza_name,
	COUNT(c.pizza_id) as number_of_pizza_ordered
FROM customer_orders c
Inner join pizza_names p
ON c.pizza_id = p.pizza_id
GROUP BY c.customer_id,pizza_name
ORDER BY c.customer_id;
```
| customer_id | pizza_name | number_of_pizza_ordered |
| ----------- | ---------- | ----------------------- |
| 101         | Meatlovers | 2                       |
| 101         | Vegetarian | 1                       |
| 102         | Meatlovers | 2                       |
| 102         | Vegetarian | 1                       |
| 103         | Meatlovers | 3                       |
| 103         | Vegetarian | 1                       |
| 104         | Meatlovers | 3                       |
| 105         | Vegetarian | 1                       |
### What was the maximum number of pizzas delivered in a single order?
```
with max_nums_of_pizzas as (
Select order_id,Count(pizza_id) as number_of_pizzas
From cleaned_customer c
Group By order_id
Order By number_of_pizzas)

Select Max(number_of_pizzas) as max_nums_of_pizzas
From max_nums_of_pizzas;
```
| max_nums_of_pizzas |
| ------------------ |
| 3                  |
### For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
```
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
```
| customer_id | at_least_1_change | no_change |
| ----------- | ----------------- | --------- |
| 101         | 0                 | 2         |
| 102         | 0                 | 3         |
| 103         | 3                 | 0         |
| 104         | 2                 | 1         |
| 105         | 1                 | 0         |
### How many pizzas were delivered that had both exclusions and extras?
```
SELECT 
	Sum(Case 
    	When exclusions is not null and extras is not null then 1
        Else 0 END) as Both_extras_and_exclusions_pizza
From cleaned_customer c
Inner join cleaned_runner r 
On c.order_id = r.order_id
Where distance != 0;
```
| both_extras_and_exclusions_pizza |
| -------------------------------- |
| 1                                |
### What was the total volume of pizzas ordered for each hour of the day?
```
Select EXTRACT(HOUR FROM order_time)as hours,
		Count(order_id) as total_orders
From cleaned_customer
Group By hours
Order By hours;
```
| hours | total_orders |
| ----- | ------------ |
| 11    | 1            |
| 13    | 3            |
| 18    | 3            |
| 19    | 1            |
| 21    | 3            |
| 23    | 3            |
### What was the volume of orders for each day of the week?
adding 2 to the day because it's starts from monday
```
Select to_char(order_time + INTERVAL '2 day','Day') as day_of_week, 
    Count(order_id) as total_orders
From cleaned_customer
Group By day_of_week
Order By day_of_week;
```
| day_of_week | total_orders |
| ----------- | ------------ |
| Friday      | 5            |
| Monday      | 5            |
| Saturday    | 3            |
| Sunday      | 1            |
***
## B. Runner and Customer Experience
### How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```
With Week_registration as 
(SELECT 'Week ' || RANK () OVER (
        ORDER BY
          Extract('week'From registration_date) desc
      ) number_of_week,
      Extract('week'From registration_date) AS week,
      COUNT(runner_id) AS number_of_registrations
FROM runners
GROUP BY week)

Select number_of_week,number_of_registrations
From Week_registration;
```
| number_of_week | number_of_registrations |
| -------------- | ----------------------- |
| Week 1         | 2                       |
| Week 2         | 1                       |
| Week 3         | 1                       |
### What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
```
Select runner_id,
	Round(Avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Group By runner_id
Order By runner_id;
```
| runner_id | minutes_delay |
| --------- | ------------- |
| 1         | 15            |
| 2         | 23            |
| 3         | 10            |
### Is there any relationship between the number of pizzas and how long the order takes to prepare?
```
Select c.order_id,Count(pizza_id) as number_of_pizzas,
	Round(Avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Where distance Is Not NULL
Group By c.order_id
Order BY number_of_pizzas Desc,minutes_delay Desc;
```
| order_id | number_of_pizzas | minutes_delay |
| -------- | ---------------- | ------------- |
| 4        | 3                | 29            |
| 3        | 2                | 21            |
| 10       | 2                | 15            |
| 8        | 1                | 20            |
| 2        | 1                | 10            |
| 7        | 1                | 10            |
| 1        | 1                | 10            |
| 5        | 1                | 10            |
### What was the average distance travelled for each customer?
```
Select customer_id,round(Avg(distance)) as distance
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Group By customer_id
Order By customer_id;
```
| customer_id | distance |
| ----------- | -------- |
| 101         | 20       |
| 102         | 17       |
| 103         | 23       |
| 104         | 10       |
| 105         | 25       |
### What was the difference between the longest and shortest delivery times for all orders?
```
Select (Max(duration) - Min(duration)) as max_diff
From cleaned_runner;
```
| max_diff |
| -------- |
| 30       |
### What was the average speed for each runner for each delivery and do you notice any trend for these values?
```
Select runner_id,
	Concat(Round(Avg(distance :: numeric / (duration :: Numeric / 60)),1),' KM\H') as speed
From cleaned_runner
Where distance Is Not Null
Group By runner_id
Order By runner_id;
```
| runner_id | speed     |
| --------- | --------- |
| 1         | 45.5 KM\H |
| 2         | 62.9 KM\H |
| 3         | 40.0 KM\H |
### What is the successful delivery percentage for each runner?
```
With Successful_delivers as(           
Select runner_id, Count(order_id) delivered_orders
From cleaned_runner
Where distance != 0
Group By runner_id
Order By runner_id),

total as (Select runner_id, Count(order_id) Total_orders
From cleaned_runner
Group By runner_id
Order By runner_id)

Select s.runner_id, Round(100 *delivered_orders :: Numeric / Total_orders,1) as successful_delivery_percentage
From total t
Inner Join Successful_delivers s
On s.runner_id = t.runner_id;
```
| runner_id | successful_delivery_percentage |
| --------- | ------------------------------ |
| 1         | 100.0                          |
| 2         | 75.0                           |
| 3         | 50.0                           |
***
## C. Ingredient Optimisation
This section got a lot of next level problems and more difficult than previous problems
### What are the standard ingredients for each pizza
```
Select pizza_name,
	string_agg(topping_name,',')ingredients
From pizza_toppings,pizza_names n
Inner Join pizza_recipes r
On r.pizza_id = n.pizza_id
Where topping_id In
(Select UNNEST(String_to_array(toppings,',') :: int[])
From pizza_recipes)
Group By pizza_name
```
| pizza_name | ingredients                                                                                          |
| ---------- | --------------------------------------------------------------------------------------------------- |
| Meatlovers | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Onions,Pepperoni,Peppers,Salami,Tomatoes,Tomato Sauce |
| Vegetarian | Bacon,BBQ Sauce,Beef,Cheese,Chicken,Mushrooms,Onions,Pepperoni,Peppers,Salami,Tomatoes,Tomato Sauce |
### What was the most common exclusion
```
With number_of_exclusions as (
Select t.topping_name,
	Count(t.topping_name) as count_of_exclusions 
From
pizza_toppings t,pizza_recipes r
Inner Join pizza_names n 
On n.pizza_id = r.pizza_id
Inner Join cleaned_customer c
On c.pizza_id = r.pizza_id
Where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(exclusions, ',') ::  int [])
      	)
Group By t.topping_name)

Select topping_name,count_of_exclusions
From number_of_exclusions
Where count_of_exclusions = (Select max(count_of_exclusions) From number_of_exclusions)
```
| topping_name | count_of_exclusions |
| ------------ | ------------------- |
| Cheese       | 4                   |
### What was the most common extras?
```
With number_of_extras as (
Select t.topping_name,
	Count(t.topping_name) as count_of_extras 
From
pizza_toppings t,pizza_recipes r
Inner Join pizza_names n 
On n.pizza_id = r.pizza_id
Inner Join cleaned_customer c
On c.pizza_id = r.pizza_id
Where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(extras, ',') ::  int [])
      	)
Group By t.topping_name)

Select topping_name,count_of_extras
From number_of_extras
Where count_of_extras = (Select max(count_of_extras) From number_of_extras)
```
| topping_name | count_of_extras |
| ------------ | --------------- |
| Bacon        | 4               |
### Generate an order item for each record in the customers_orders table in the format of one of the following:
 - Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```
With pizza_topping_cte as(
Select order_id,pizza_name,
    Case
    When exclusions Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(exclusions, ','):: int [])
    	)
    Then topping_name
    End as exclusions,
    Case
    When extras Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
    	)
    Then topping_name
    End as extras
From pizza_toppings as t,
cleaned_customer as c
JOIN pizza_names as n 
ON c.pizza_id = n.pizza_id
GROUP BY c.order_id,pizza_name,
exclusions,extras,topping_id,topping_name)

Select order_id,
	Concat(pizza_name,' ',
	Case 
	When Count(extras) > 0 Then '- Extra '
	Else '' End,
    String_agg(extras,', '),' ',
    Case
	When Count(exclusions) > 0 Then '- Exclude '
	Else '' End,
	String_agg(exclusions,', ')) AS Pizza_information
From pizza_topping_cte
Group By order_id,pizza_name
```
| order_id | pizza_information                                               |
| -------- | --------------------------------------------------------------- |
| 1        | Meatlovers                                                      |
| 2        | Meatlovers                                                      |
| 3        | Meatlovers                                                      |
| 3        | Vegetarian                                                      |
| 4        | Meatlovers  - Exclude Cheese                                    |
| 4        | Vegetarian  - Exclude Cheese                                    |
| 5        | Meatlovers - Extra Bacon                                        |
| 6        | Vegetarian                                                      |
| 7        | Vegetarian - Extra Bacon                                        |
| 8        | Meatlovers                                                      |
| 9        | Meatlovers - Extra Bacon, Chicken - Exclude Cheese              |
| 10       | Meatlovers - Extra Bacon, Cheese - Exclude BBQ Sauce, Mushrooms |
### Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
This solution is without extras and exclusions.
```
With toppings_counts_cte as(       
Select order_id,pizza_name,topping_name,
	Count(topping_name) as counts
From pizza_toppings t,cleaned_customer c 
Inner Join pizza_recipes r
On c.pizza_id = r.pizza_id
Inner Join pizza_names n
On c.pizza_id = n.pizza_id
Where topping_id in (
   Select 
      UNNEST(string_to_array(r.toppings,',') :: int[])
      )
Group By order_id,pizza_name,topping_name)

Select order_id,
     		Concat(pizza_name,': ',string_agg(Case
      		When counts > 1 
      		Then '2x' || topping_name 
      		Else topping_name End,','))
From toppings_counts_cte
Group By order_id,pizza_name 
```
| order_id | concat                                                                                     |
| -------- | ------------------------------------------------------------------------------------------ |
| 1        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 2        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 3        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 3        | Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes                          |
| 4        | Meatlovers: 2xBBQ Sauce,2xBacon,2xBeef,2xCheese,2xChicken,2xMushrooms,2xPepperoni,2xSalami |
| 4        | Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes                          |
| 5        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 6        | Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes                          |
| 7        | Vegetarian: Cheese,Mushrooms,Onions,Peppers,Tomato Sauce,Tomatoes                          |
| 8        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 9        | Meatlovers: BBQ Sauce,Bacon,Beef,Cheese,Chicken,Mushrooms,Pepperoni,Salami                 |
| 10       | Meatlovers: 2xBBQ Sauce,2xBacon,2xBeef,2xCheese,2xChicken,2xMushrooms,2xPepperoni,2xSalami |
### What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
```
With pizza_ingredints as(
	Select order_id,
    	Case
		When exclusions Is Not null And t.topping_id IN
			(Select 
			UNNEST(STRING_TO_ARRAY(exclusions, ',') :: int [])
			)
		Then topping_name
		End As exclusions,
		Case
		When extras Is Not null And t.topping_id IN
			(Select 
			UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
			)
		Then topping_name
		End As extras,
		Case
			When topping_id In
			(Select 
			UNNEST(STRING_TO_ARRAY(toppings, ',') :: int [])
			)
			Then topping_name 
			Else null End As toppings
	From pizza_toppings as t,
	cleaned_customer as c
	JOIN pizza_names as n 
	ON c.pizza_id = n.pizza_id
	Join pizza_recipes r 
	On r.pizza_id = c.pizza_id
	Order By order_id)

Select order_id,(Count(extras) + Count(toppings) - Count(exclusions) 
 ) as toppings_count
From pizza_ingredints
Group By order_id
Order By toppings_count desc
```
| order_id | toppings_count |
| -------- | -------------- |
| 4        | 19             |
| 10       | 16             |
| 3        | 14             |
| 9        | 9              |
| 5        | 9              |
| 1        | 8              |
| 2        | 8              |
| 8        | 8              |
| 7        | 7              |
| 6        | 6              |
***
## D. Pricing and Ratings
This problems is like the previous problems but got more concern about the income and profit
### If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
```
with pizza_price as(
Select c.order_id,
	Case 
    	When pizza_id = 1 then 12
        When pizza_id = 2 then 10
        End as price
    From cleaned_customer c
    Inner Join cleaned_runner r
    On c.order_id = r.order_id
	Where distance Is Not null)

Select concat(Sum(price), '$') As Total_money_earned
From pizza_price
```
| total_money_earned |
| ------------------ |
| 138$               |
### What if there was an additional $1 charge for any pizza extras? 
- Add cheese is $1 extra
```
with extras as(
  SELECT Count(extras) as extras From
 	(Select
	Unnest(string_to_array(extras,',')) as extras
    From cleaned_customer c
    Inner Join cleaned_runner r
    On c.order_id = r.order_id
    Where distance Is Not null)as sub2),

profit as(
  Select Sum(price) as Total_money_earned From
    (Select c.order_id,
	Case 
    	when pizza_id = 1 Then 12
        when pizza_id = 2 Then 10
        end as price
    From cleaned_customer c
    Inner join cleaned_runner r
    On c.order_id = r.order_id
	Where distance Is Not null) as sub1)


Select 
    Concat(Total_money_earned + extras, ' $') Total_money_earned From
  	profit, extras
```
| total_money_earned |
| ------------------ |
| 142 $              |
### Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas
```
DROP TABLE IF EXISTS runner_rating;   
Create Table runner_rating(
  "id" Serial Primary Key,
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "runner_id" INTEGER,
  "rating" INTEGER
  );
  Insert Into runner_rating(
    "order_id","customer_id","runner_id","rating")
    Values
  ('1', '101', '1', '5'),
  ('2', '101', '1', '5'),
  ('3', '102', '1', '4'),
  ('4', '103', '2', '5'),
  ('5', '104', '3', '5'),
  ('7', '105', '2', '4'),
  ('8', '102', '2', '4'),
  ('10', '104', '1', '5');
  
Select rr.customer_id,rr.order_id,rr.runner_id,
		rr.rating,c.order_time,r.pickup_time,
        Round(Avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay,
        r.duration,
        Concat(Round(Cast(Avg(distance / (duration/60)) as numeric),1),' KM\H') As speed,
        Count(c.pizza_id) pizza_count
From runner_rating rr 
Inner Join cleaned_customer c
On c.order_id = rr.order_id
Inner Join cleaned_runner r
On c.order_id = r.order_id
Group By 1,2,3,4,5,6,8;
```
| customer_id | order_id | runner_id | rating | order_time               | pickup_time              | minutes_delay | duration | speed     | pizza_count |
| ----------- | -------- | --------- | ------ | ------------------------ | ------------------------ | ------------- | -------- | --------- | ----------- |
| 101         | 1        | 1         | 5      | 2020-01-01T18:05:02.000Z | 2020-01-01T18:15:34.000Z | 10            | 32       | 37.5 KM\H | 1           |
| 101         | 2        | 1         | 5      | 2020-01-01T19:00:52.000Z | 2020-01-01T19:10:54.000Z | 10            | 27       | 44.4 KM\H | 1           |
| 102         | 3        | 1         | 4      | 2020-01-02T23:51:23.000Z | 2020-01-03T00:12:37.000Z | 21            | 20       | 40.2 KM\H | 2           |
| 102         | 8        | 2         | 4      | 2020-01-09T23:54:33.000Z | 2020-01-10T00:15:02.000Z | 20            | 15       | 93.6 KM\H | 1           |
| 103         | 4        | 2         | 5      | 2020-01-04T13:23:46.000Z | 2020-01-04T13:53:03.000Z | 29            | 40       | 35.1 KM\H | 3           |
| 104         | 5        | 3         | 5      | 2020-01-08T21:00:29.000Z | 2020-01-08T21:10:57.000Z | 10            | 15       | 40.0 KM\H | 1           |
| 104         | 10       | 1         | 5      | 2020-01-11T18:34:49.000Z | 2020-01-11T18:50:20.000Z | 15            | 10       | 60.0 KM\H | 2           |
| 105         | 7        | 2         | 4      | 2020-01-08T21:20:29.000Z | 2020-01-08T21:30:45.000Z | 10            | 25       | 60.0 KM\H | 1           |
### If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
```
WITH profit AS (
  SELECT
    pizza_name,
  CASE
    WHEN pizza_name = 'Meatlovers' THEN COUNT(pizza_name) * 12
    ELSE COUNT(pizza_name) * 10
    END AS profit
  FROM
    pizza_runner.customer_orders AS c
    JOIN pizza_runner.pizza_names AS n ON c.pizza_id = n.pizza_id
    JOIN pizza_runner.runner_orders AS r ON c.order_id = r.order_id
  WHERE
    pickup_time != 'null'
    AND distance != 'null'
    AND duration != 'null'
  GROUP BY
    1
),
expenses AS (
  SELECT
   Sum(TO_NUMBER(distance, '99D9')*0.3) as expense
  FROM
    pizza_runner.runner_orders
    WHERE
     pickup_time != 'null'
     AND distance != 'null'
     AND duration != 'null'
    ) 
SELECT
  SUM(profit) - expense AS net_profit_in_dollars
FROM
  profit,
  expenses
Group By expense;
```

| net_profit_in_dollars |
| --------------------- |
| 94.44                 |
***
## Bonus Question
If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
```
INSERT INTO
  pizza_names ("pizza_id", "pizza_name")
VALUES
  (3, 'Supreme');
INSERT INTO
	pizza_recipes ("pizza_id", "toppings")
VALUES
  (3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
  
Select * From pizza_names
```
| pizza_id | pizza_name | toppings                              |
| -------- | ---------- | ------------------------------------- |
| 1        | Meatlovers | 1, 2, 3, 4, 5, 6, 8, 10               |
| 2        | Vegetarian | 4, 6, 7, 9, 11, 12                    |
| 3        | Supreme    | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 |
