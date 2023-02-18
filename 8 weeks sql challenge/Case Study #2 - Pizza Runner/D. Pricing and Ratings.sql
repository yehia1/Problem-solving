set search_path = pizza_runner;

--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
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

--What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
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

--
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

-- Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
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

-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
--E. Bonus Questions
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