set search_path = fresh_segments;


ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');

--Which interests have been present in all month_year dates in our dataset?
Select interest_name , count(interest_name) as interest_count
From interest_map im
left join interest_metrics im1
on im1.interest_id :: int = im.id
where month_year in 
( SELECT DISTINCT month_year FROM interest_metrics)
group by 1
having count(interest_name) = 14;


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