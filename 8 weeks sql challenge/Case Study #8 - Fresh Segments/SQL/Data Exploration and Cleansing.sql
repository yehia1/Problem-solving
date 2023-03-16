Set search_path = fresh_segments;

--Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month
ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');

--What is count of records in the fresh_segments.interest_metrics for each month_year value sorted in chronological order (earliest to latest) with the null values appearing first?
Select month_year,Count(*) as records_count
From interest_metrics
Group By 1
Order By month_year Nulls First;

--How many interest_id values exist in the fresh_segments.interest_metrics table but not in the fresh_segments.interest_map table? What about the other way around?
Select Count(interest_id) as distincts From interest_metrics
Where 
	interest_id :: Int Not In
    (Select id FROM interest_map)
Union
Select count(id) from interest_map
Where 
	id Not In
    (Select interest_id :: int from interest_metrics
    Where interest_id Is Not Null);

--Summarise the id values in the fresh_segments.interest_map by its total record count in this table
SELECT Count(id) From interest_map;

--What sort of table join should we perform for our analysis and why? Check your logic by checking the rows 
--where interest_id = 21246 in your joined output and include all columns from fresh_segments.interest_metrics and all columns 
--from fresh_segments.interest_map except from the id column.
Select im.*,im1.interest_name,
		im1.interest_summary,im1.created_at,im1.last_modified
From interest_metrics im
Inner Join interest_map im1
On im1.id = im.interest_id :: Numeric
Where interest_id = '21246'
Order By im.month_year Nulls First;

--Are there any records in your joined table where the month_year value is before the created_at value from the fresh_segments.interest_map table?
-- Do you think these values are valid and why?
Select count(im.*) From
interest_metrics im 
Inner join interest_map im1
On im.interest_id :: Int = im1.id
Where month_year < created_at