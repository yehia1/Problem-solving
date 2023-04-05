-- https://datalemur.com/questions/click-through-rate
'''
Assume you have an events table on app analytics.
 Write a query to get the app’s click-through rate (CTR %) in 2022.
 Output the results in percentages rounded to 2 decimal places.
'''

WITH cte as (
SELECT app_id , 
  SUM(
    CASE WHEN event_type = 'click' then 1
    End 
  )as clicks,
  SUM(
    CASE WHEN event_type = 'impression' then 1
    End 
  )as impressions
FROM events
WHERE EXTRACT(year FROM timestamp) = '2022'
GROUP BY app_id)


SELECT app_id , ROUND(100 * clicks :: Numeric / impressions ,2)
as ctr
From cte
  