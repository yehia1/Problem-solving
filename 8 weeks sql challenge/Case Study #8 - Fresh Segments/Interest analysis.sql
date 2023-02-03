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
