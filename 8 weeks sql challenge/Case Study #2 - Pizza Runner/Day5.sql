SET search_path = pizza_runner;

--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
Select concat(sum(price), '$') as Total_money_earned from
(Select c.order_id,
	case 
    	when pizza_id = 1 then 12
        when pizza_id = 2 then 10
        end as price
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
	where distance is not null) as sub1;
    
    
-- What if there was an additional $1 charge for any pizza extras?
with extras as(
  	SELECT
	count(extras) as e from
 	(Select
	Unnest(string_to_array(extras,',')) as extras
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
    where distance is not null)as sub2),
profit as(
  	Select sum(price) as Total_money_earned from
(Select c.order_id,
	case 
    	when pizza_id = 1 then 12
        when pizza_id = 2 then 10
        end as price
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
	where distance is not null) as sub1)

select 
    concat(Total_money_earned + e, '$') Total_money_earned from
  	profit, extras

--The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
DROP TABLE IF EXISTS runner_rating;   
Create table runner_rating(
  "id" Serial primary key,
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "runner_id" INTEGER,
  "rating" INTEGER
  );
  Insert into runner_rating(
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
        Round(avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay,
        r.duration,
        Concat(Round(cast(avg(distance / (duration/60)) as numeric),1),' KM\H') as speed,
        count(c.pizza_id)
from runner_rating rr 
inner join cleaned_customer c
on c.order_id = rr.order_id
inner join cleaned_runner r
on c.order_id = r.order_id
group by 1,2,3,4,5,6,8;

-- 
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
   sum(TO_NUMBER(distance, '99D9')*0.3) as expense
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
group by expense;

--If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
INSERT INTO
  pizza_names ("pizza_id", "pizza_name")
VALUES
  (3, 'Supreme');
INSERT INTO
	pizza_recipes ("pizza_id", "toppings")
VALUES
  (3, '1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');


           


           

