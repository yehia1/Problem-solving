-- https://datalemur.com/questions/user-retention
/*

This is the same question as problem #23 in the SQL Chapter of Ace the Data Science Interview!

Assume you're given a table containing information on Facebook user actions.
Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

*/
SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);