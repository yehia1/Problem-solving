-- https://datalemur.com/questions/time-spent-snaps

/*
Assume you are given the tables below containing information on Snapchat users, their ages, and their time spent sending and opening snaps.
 Write a query to obtain a breakdown of the time spent sending vs.
opening snaps (as a percentage of total time spent on these activities) for each age group.

Output the age bucket and percentage of sending and opening snaps. Round the percentage to 2 decimal places.

*/
WITH spent_cte as(
SELECT age_bucket,
  SUM(
    CASE
      WHEN activity_type = 'send' THEN time_spent
    END 
  )as send_spent,
  SUM(
    CASE
      WHEN activity_type = 'open' THEN time_spent
    END 
  ) as open_spent
FROM activities a
JOIN age_breakdown b
ON a.user_id = b.user_id
GROUP BY age_bucket)

SELECT age_bucket,
  ROUND(100 * send_spent :: Numeric/ (send_spent + open_spent),2)as send_perc,
  ROUND(100 *open_spent :: Numeric/ (send_spent + open_spent),2)as open_perc
FROM spent_cte