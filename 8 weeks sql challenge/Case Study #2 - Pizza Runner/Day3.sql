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
order by runner_id
      