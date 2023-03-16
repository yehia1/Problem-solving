set search_path = fresh_segments;


ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');

--Which interests have been present in all month_year dates in our dataset?
Select interest_name , Count(interest_name) as interest_count
From interest_map im
Left Join interest_metrics im1
On im1.interest_id :: int = im.id
Where month_year In 
( SELECT DISTINCT month_year FROM interest_metrics)
Group By 1
Having Count(interest_name) = 14;


--Using this same total_months measure - calculate the cumulative percentage of all records starting at 14 months - which total_months value passes the 90% cumulative percentage value?
with counted_months as (
SELECT
      interest_id,
      COUNT(interest_id) total_months,
      ROW_NUMBER() OVER(
        PARTITION BY COUNT(interest_id)
        ORDER BY
          COUNT(interest_id)
      ) AS rank
    FROM
      interest_metrics AS im
    GROUP BY
      1
    HAVING
      COUNT(interest_id) > 0)

select total_months,max(rank) as number_of_interests,round(100 * sum(max(rank)) over (order by total_months)
/ SUM(MAX(rank)) OVER (),2) as cum_perc
from counted_months
group by total_months
order by 3 desc

--If we were to remove all interest_id values which are lower than the total_months value we found in the previous question - how many total data points would we be removing?
with counted_months as(
Select interest_id,count(interest_id) as total_months
from interest_metrics
group by interest_id 
)

Select count(total_months)
from counted_months
where total_months < 6


--After removing these interests - how many unique interests are there for each month?
Select month_year, Count(interest_id) As number_of_interests
From
  interest_metrics As im
Where
  month_year Is Not Null
  And interest_id :: int In (
    Select
      interest_id :: int
    From
      interest_metrics
    Group By
      1
    Having
      Count(interest_id) > 5
  )
Group By
  1
Order By
  1