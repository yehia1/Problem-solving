Set search_path = fresh_segments;

--Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month
ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');

--What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
Select month_year,count(*) as records_count
from interest_metrics
group by 1
order by month_year Nulls first;

--How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?
Select count(interest_id) from interest_metrics
where 
	interest_id :: int Not in
    (Select id from interest_map);

Select count(id) from interest_map
where 
	id Not in
    (Select interest_id :: int from interest_metrics
    where interest_id is not Null);

--What sort of table join should we perform for our analysis and why? Check your logic by checking the rows 
--where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns 
--from fresh_segments.interest_map except from the id column.
Select im.*,im1.interest_name,
		im1.interest_summary,im1.created_at,im1.last_modified
from interest_metrics im
inner join interest_map im1
on im1.id = im.interest_id :: Numeric
where interest_id = '21246';

