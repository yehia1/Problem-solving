SET search_path = foodie_fi;

-- How many customers has Foodie-Fi ever had?
Select count(distinct customer_id) as number_of_customers from subscriptions;

-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
Select
extract(month from start_date)as month,count(customer_id) 
from subscriptions
where plan_id = 0 
group by 1
order by month;

-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
Select 
p.plan_id,plan_name,count(customer_id)
from plans p 
inner join subscriptions s 
on p.plan_id = s.plan_id
where start_date >='2020-01-01'
group by p.plan_id,plan_name
order by p.plan_id;

-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select count(customer_id) as total_customers,
	Concat(Round(count(customer_id) :: numeric / (Select count(distinct customer_id)from subscriptions),3) *100,'%') as percentage
    from subscriptions
    where plan_id = 4;
    
-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
with trial as (
Select customer_id, plan_id,start_date
from subscriptions
where plan_id = 0 ),
churn as(
  Select customer_id, plan_id,start_date
from subscriptions
where plan_id = 4)

select
	count(DATE_PART('day',c.start_date :: timestamp - t.start_date :: timestamp)) as number_of_customers,
    concat(Round(count(DATE_PART('day',c.start_date :: timestamp - t.start_date :: timestamp)) :: numeric/ (Select count(distinct customer_id) as number_of_customers from subscriptions),2)*100,'%')

    from trial t
    inner join churn c 
    on t.customer_id = c.customer_id
    where DATE_PART('day',c.start_date :: timestamp - t.start_date :: timestamp) = 7;

-- What is the number and percentage of customer plans after their initial free trial?
Select next_plan,count(next_plan) as total_ranscations,
Concat(Round(100 * count(next_plan) :: Numeric / (Select count(distinct customer_id) as number_of_customers from subscriptions),1),'%')
from(
SELECT 
  customer_id, 
  plan_id, 
  LEAD(plan_id, 1) OVER( -- Offset by 1 to retrieve the immediate row's value below 
    PARTITION BY customer_id 
    ORDER BY plan_id) as next_plan
FROM subscriptions) sub1
where next_plan is not null
group by next_plan
order by next_plan

--What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
with next_plan as (
SELECT 
  customer_id, 
  plan_id, 
  start_date,
  LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
FROM subscriptions
WHERE start_date <= '2020-12-31')

 SELECT plan_id, COUNT(DISTINCT customer_id) AS customers
    FROM next_plan
    WHERE (next_date IS NOT NULL AND (start_date < '2020-12-31' AND next_date > '2020-12-31'))
      OR (next_date IS NULL AND start_date < '2020-12-31')
    GROUP BY plan_id;
    
-- How many customers have upgraded to an annual plan in 2020?
Select count(distinct customer_id) as total_annual
from subscriptions
where plan_id = 3 and start_date >= '2020-01-01' and start_date 
< '2020-12-31';

--How many days on average does it take for a customer to an annual plan ?
Select Round(avg(DATE_PART('day', next_date :: timestamp - start_date :: timestamp))) as average_days_to_annual
from
(Select customer_id,plan_id,
LEAD(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) as next_plan,
start_date,
LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
from subscriptions) sub1
where next_plan = 3;

--Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
WITH trial_plan AS 
(SELECT 
  customer_id, 
  start_date AS trial_date
FROM foodie_fi.subscriptions
WHERE plan_id = 0
),
-- Filter results to customers at pro annual plan = 3
annual_plan AS
(SELECT 
  customer_id, 
  start_date AS annual_date
FROM foodie_fi.subscriptions
WHERE plan_id = 3
),
-- Sort values above in buckets of 12 with range of 30 days each
bins AS 
(SELECT 
  WIDTH_BUCKET(ap.annual_date - tp.trial_date, 0, 360, 12) AS avg_days_to_upgrade
FROM trial_plan tp
JOIN annual_plan ap
  ON tp.customer_id = ap.customer_id)
  
SELECT 
  ((avg_days_to_upgrade - 1) * 30 || ' - ' || (avg_days_to_upgrade) * 30) || ' days' AS breakdown, 
  COUNT(*) AS customers
FROM bins
GROUP BY avg_days_to_upgrade
ORDER BY avg_days_to_upgrade;


--How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
Select count(customer_id) as number_of_downgrades
from(
SELECT customer_id,start_date,
	plan_id,Lead(plan_id,1) over(partition by customer_id
                               order by plan_id) as next_plan
    from subscriptions) sub
    where next_plan = 1 and plan_id = 2


