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


