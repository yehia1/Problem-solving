-- https://datalemur.com/questions/odd-even-measurements

/*
Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns.
Refer to the Example Output below for the desired format.

Definition:

Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements,
and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

*/

WITH counter_cte as( 
SELECT *,
ROW_NUMBER() 
OVER(PARTITION BY EXTRACT(day FROM measurement_time) ORDER BY measurement_time asc) as counter
FROM measurements)

SELECT date_trunc('day',measurement_time),
SUM(CASE WHEN counter % 2 != 0 THEN measurement_value END) as odd_sum,
SUM(CASE WHEN counter % 2 = 0 THEN measurement_value END) as even_sum
FROM counter_cte
GROUP BY date_trunc('day',measurement_time)
ORDER BY date_trunc('day',measurement_time)


