SET search_path = pizza_runner;

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT
  number_of_week,
  number_of_registrations
FROM
  (
    SELECT
      'Week ' || RANK () OVER (
        ORDER BY
          Extract('week'from registration_date) desc
      ) number_of_week,
      Extract('week'from registration_date) AS week,
      COUNT(runner_id) AS number_of_registrations
    FROM
      runners
    GROUP BY
      week
  ) AS count_weeks;

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Select runner_id,
Round(avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
from cleaned_runner r
inner join cleaned_customer c
on c.order_id = r.order_id
group by runner_id
order by runner_id;

-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
Select c.order_id,count(pizza_id) as number_of_pizzas,
Round(avg(DATE_PART('minute', pickup_time - order_time))) as minutes_delay
from cleaned_runner r
inner join cleaned_customer c
on c.order_id = r.order_id
where distance is not NULL
group by c.order_id
ORDER BY number_of_pizzas desc;


-- What was the average distance travelled for each customer?
Select customer_id,round(avg(distance)) as distance
from cleaned_runner r
inner join cleaned_customer c
on c.order_id = r.order_id
group by customer_id
order by customer_id;

--What was the difference between the longest and shortest delivery times for all orders?
Select (max(duration) - min(duration)) as max_diff
from cleaned_runner;

-- What was the average speed for each runner for each delivery and do you notice any trend for these values?
Select runner_id,
	Concat(Round(cast(avg(distance / (duration/60)) as numeric),1),' KM\H') as speed
    from cleaned_runner
    where distance is not Null
    group by runner_id
    order by runner_id;
    
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
    order by runner_id
