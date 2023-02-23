# 🥑 Case Study #2: - Foodie-Fi

## A. Customer Journey
| customer_id | plan_name     | start_date               |
| ----------- | ------------- | ------------------------ |
| 1           | trial         | 2020-08-01T00:00:00.000Z |
| 1           | basic monthly | 2020-08-08T00:00:00.000Z |
| 2           | trial         | 2020-09-20T00:00:00.000Z |
| 2           | pro annual    | 2020-09-27T00:00:00.000Z |
| 11          | trial         | 2020-11-19T00:00:00.000Z |
| 11          | churn         | 2020-11-26T00:00:00.000Z |
| 13          | trial         | 2020-12-15T00:00:00.000Z |
| 13          | basic monthly | 2020-12-22T00:00:00.000Z |
| 13          | pro monthly   | 2021-03-29T00:00:00.000Z |
| 15          | trial         | 2020-03-17T00:00:00.000Z |
| 15          | pro monthly   | 2020-03-24T00:00:00.000Z |
| 15          | churn         | 2020-04-29T00:00:00.000Z |
| 16          | trial         | 2020-05-31T00:00:00.000Z |
| 16          | basic monthly | 2020-06-07T00:00:00.000Z |
| 16          | pro annual    | 2020-10-21T00:00:00.000Z |
| 18          | trial         | 2020-07-06T00:00:00.000Z |
| 18          | pro monthly   | 2020-07-13T00:00:00.000Z |
| 19          | trial         | 2020-06-22T00:00:00.000Z |
| 19          | pro monthly   | 2020-06-29T00:00:00.000Z |
| 19          | pro annual    | 2020-08-29T00:00:00.000Z |
- **Customer 1** used the `trial` for 7 days then he subscribed for `basic monthly` 
- **Customer 2** used his `trial` for 7 days then he subscribed for `pro annual`
- **Customer 11** used the `trail` then he didn't get conviced and he `churned`.
- **Customer 13** For first he used the `trial` then he subscribed for the `basic monthly` for 3 months then he upgraded for `pro monthly`
- **Customer 15**: He tried the trial after 7 days he applied for `pro monthly`
then he `churned` after one month
- **Customer 16** He used the `trial` and after that he subscribed for `basic monthly` after 4 months he gone for `pro annual`
- **Customer 18** He used the `trial` then he gone for `pro monthly` after 7 days
- **Customer 19** He first used the `trial`he applied for `pro monthly` and after 2 months he used the `pro annual`
***
## B. Data Analysis Questions
### How many customers has Foodie-Fi ever had?
```
SET search_path = foodie_fi;

Select Count(distinct customer_id) as number_of_customers 
From subscriptions;
```

| number_of_customers |
| ------------------- |
| 1000                |
### What is the monthly distribution of `trial` plan `start_date` values for our dataset - use the start of the month as the group by value
```
Select
	Extract(month from start_date)as month,
	Count(customer_id) number_of_customers
From subscriptions
Where plan_id = 0 
Group by month
Order By month;
```
| month | number_of_customers |
| ----- | ------------------- |
| 1     | 88                  |
| 2     | 68                  |
| 3     | 94                  |
| 4     | 81                  |
| 5     | 88                  |
| 6     | 79                  |
| 7     | 89                  |
| 8     | 88                  |
| 9     | 87                  |
| 10    | 79                  |
| 11    | 75                  |
| 12    | 84                  |
### What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`
```
Select 
	p.plan_id,plan_name,
    Count(customer_id) as number_of_customers
From plans p 
Inner Join subscriptions s 
On p.plan_id = s.plan_id
Where Extract(year From start_date) > 2020
Group By p.plan_id,plan_name
Order By p.plan_id;
```
| plan_id | plan_name     | number_of_customers |
| ------- | ------------- | ------------------- |
| 1       | basic monthly | 8                   |
| 2       | pro monthly   | 60                  |
| 3       | pro annual    | 63                  |
| 4       | churn         | 71                  |
### What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
```
select count(customer_id) as total_customers,
	Concat(
      Round( 100 *
        Count(customer_id) :: numeric /
        	(Select count(distinct customer_id)From subscriptions),1),'%') as percentage
From subscriptions
Where plan_id = 4;
```
| total_customers | percentage |
| --------------- | ---------- |
| 307             | 30.7%      |
### How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
Idea  of using 2 cte 1 for the `free-trial` and the other for the `churn`
then subtract the churn date from free trial date if the subtraction is 7.
```
with trial as (
Select customer_id, plan_id,start_date
From subscriptions
Where plan_id = 0 ),

churn as(
  Select customer_id, plan_id,start_date
From subscriptions
Where plan_id = 4)

Select
	Count(
      DATE_PART('day',c.start_date :: timestamp - t.start_date :: timestamp)) as number_of_churned,
  Concat(
    Round(100 *
      count(DATE_PART('day',c.start_date :: timestamp - t.start_date :: 		timestamp)) :: numeric /
      (Select count(distinct customer_id)from subscriptions),2),'%') as churned_after_free_percentage
From trial t
Inner join churn c 
On t.customer_id = c.customer_id
Where DATE_PART('day',c.start_date :: timestamp - t.start_date :: timestamp) = 7;
```
| number_of_churned | churned_after_free_percentage |
| ----------------- | ----------------------------- |
| 92                | 9.20%                         |
### What is the number and percentage of customer plans after their initial free trial?
This code i use the `Lead function` for first time which is used for the next plan or next date for subscribtions
```
SET search_path = foodie_fi;

With next_plan as(
SELECT 
  customer_id, 
  plan_id, 
  LEAD(plan_id, 1) OVER( -- Offset by 1 to retrieve the immediate row's value below 
    PARTITION BY customer_id 
    ORDER BY plan_id
	) as next_plan
FROM subscriptions)

Select next_plan,
	Count(next_plan) as total_transcations,
	Concat(
      Round(100 * Count(next_plan) :: Numeric /
            (Select count(distinct customer_id) From subscriptions),1),'%') as plans_percentage
From next_plan
Where next_plan is not null And plan_id = 0
Group by next_plan
Order by next_plan
```
| next_plan | total_transcations | plans_percentage |
| --------- | ------------------ | ---------------- |
| 1         | 546                | 54.6%            |
| 2         | 325                | 32.5%            |
| 3         | 37                 | 3.7%             |
| 4         | 92                 | 9.2%             |
### What is the customer count and percentage breakdown of all 5 `plan_name` values at `2020-12-31`?
```
SET search_path = foodie_fi;

With next_plan as (
SELECT 
  customer_id, 
  plan_id, 
  start_date,
  LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
FROM subscriptions
WHERE start_date <= '2020-12-31'),

break_down_perc as(
SELECT plan_id,
	COUNT(DISTINCT customer_id) AS customers
FROM next_plan
WHERE (next_date IS NOT NULL 
       AND (start_date < '2020-12-31' AND next_date > '2020-12-31'))
      OR (next_date IS NULL AND start_date < '2020-12-31')
GROUP BY plan_id)

SELECT plan_id, customers, 
  ROUND(100 * customers::NUMERIC / (
    SELECT COUNT(DISTINCT customer_id) 
    FROM subscriptions),1) AS percentage
FROM break_down_perc
GROUP BY plan_id, customers
ORDER BY plan_id
```
| plan_id | customers | percentage |
| ------- | --------- | ---------- |
| 0       | 19        | 1.9        |
| 1       | 224       | 22.4       |
| 2       | 326       | 32.6       |
| 3       | 195       | 19.5       |
| 4       | 235       | 23.5       |
### How many customers have upgraded to an annual plan in 2020?
```
Select Count(distinct customer_id) as total_annual_2020
From subscriptions
Where plan_id = 3 And start_date >= '2020-01-01' And start_date 
< '2020-12-31';
```

| total_annual_2020 |
| ----------------- |
| 195               |
### How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
used lead function 2 times and got the result by subtracting start date from next date for the data plan annual
```
With next_plan as (
Select customer_id,plan_id,
LEAD(plan_id, 1) OVER(PARTITION BY customer_id ORDER BY plan_id) as next_plan,
start_date,
LEAD(start_date, 1) OVER(PARTITION BY customer_id ORDER BY start_date) as next_date
From subscriptions)

Select Round(
  Avg(
    DATE_PART('day', next_date :: timestamp - start_date :: timestamp))) as average_days_to_annual
From next_plan
Where next_plan = 3
```
| average_days_to_annual |
| ---------------------- |
| 85                     |
### Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
This solution i couldn't get it alone so i searched for it and got to know a new function used `WIDTH_BUCKET` 
From this [solution](https://github.com/katiehuangx/8-Week-SQL-Challenge/blob/main/Case%20Study%20%233%20-%20Foodie-Fi/B.%20Data%20Analysis%20Questions.md)
```
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
```
| breakdown      | customers |
| -------------- | --------- |
| 0 - 30 days    | 48        |
| 30 - 60 days   | 25        |
| 60 - 90 days   | 33        |
| 90 - 120 days  | 35        |
| 120 - 150 days | 43        |
| 150 - 180 days | 35        |
| 180 - 210 days | 27        |
| 210 - 240 days | 4         |
| 240 - 270 days | 5         |
| 270 - 300 days | 1         |
| 300 - 330 days | 1         |
| 330 - 360 days | 1         |
### How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
```
With next_plan as(
	SELECT customer_id,start_date,
		plan_id,
  		Lead(plan_id,1) 
  			Over(Partition By customer_id
             	Order By plan_id) as next_plan
	From subscriptions)

Select count(customer_id) as number_of_downgrades
From next_plan 
Where next_plan = 1 And plan_id = 2
```

| number_of_downgrades |
| -------------------- |
| 0                    |
*** 