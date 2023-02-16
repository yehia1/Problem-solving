SET search_path = pizza_runner;

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
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

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Select runner_id,
Round(Avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Group By runner_id
Order By runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
Select c.order_id,Count(pizza_id) as number_of_pizzas,
Round(Avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Where distance Is Not NULL
Group By c.order_id
Order BY number_of_pizzas Desc,minutes_delay Desc;

-- What was the average distance travelled for each customer?
Select customer_id,round(Avg(distance)) as distance
From cleaned_runner r
Inner Join cleaned_customer c
On c.order_id = r.order_id
Group By customer_id
Order By customer_id;

--What was the difference between the longest and shortest delivery times for all orders?
Select (Max(duration) - Min(duration)) as max_diff
From cleaned_runner;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
Select runner_id,
	Concat(Round(Avg(distance :: numeric / (duration :: Numeric / 60)),1),' KM\H') as speed
From cleaned_runner
Where distance Is Not Null
Group By runner_id
Order By runner_id;

-- What is the successful delivery percentage for each runner?
Select runner_id,
Concat(Round(success / (success+failures)*100),'%') 
as successful_percentage from
(Select runner_id,
    cast(sum(case
      when distance is null then 1
      else 0
      end )as numeric) as failures,
      cast(sum(case
      when distance is not null then 1
      else 0
      end) as numeric)as success
	From cleaned_runner
    group by runner_id) as sub
Order by runner_id

--or 
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