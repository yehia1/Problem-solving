Set search_path = fresh_segments;

--Update the fresh_segments.interest_metrics table by modifying the month_year column to be a date data type with the start of the month
ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');

-- The index_value is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
--Average composition can be calculated by dividing the composition column by the index_value column rounded to 2 decimal places.
ALTER TABLE interest_metrics
ADD Average_composition Decimal(10,2);

UPDATE interest_metrics SET Average_composition = composition / index_value ;

--What is the top 10 interests by the average composition for each month?
With ranked_month_compostion as(
Select month_year,interest_name,
	rank() over(partition by month_year
              order by Average_composition desc) as rank
From interest_metrics im
Inner Join interest_map im1
On im.interest_id :: int = im1.id),

Select month_year,interest_name
From ranked_month_compostion
Where rank <= 10

-- For all of these top 10 interests - which interest appears the most often?
With ranked_month_compostion as(
Select month_year,interest_name,
	rank() over(partition by month_year
              order by Average_composition desc) as rank
From interest_metrics im
Inner Join interest_map im1
On im.interest_id :: int = im1.id),

top_ten_cop_mon as(
Select month_year,interest_name
From ranked_month_compostion
Where rank <= 10)

Select interest_name,count(*)
From top_ten_cop_mon
Group By interest_name
Order By count(*) desc
Limit 1

--What is the average of the average composition for the top 10 interests for each month?
With ranked_month_compostion as(
Select month_year,interest_name,Average_composition,
	rank() over(partition by month_year
              order by Average_composition desc) as rank
From interest_metrics im
Inner Join interest_map im1
On im.interest_id :: int = im1.id)

Select month_year,avg(Average_composition)
From ranked_month_compostion
Where rank <= 10
Group By month_year

-- What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
With ranked_month_compostion as(
Select month_year,interest_name,Average_composition,
	rank() over(partition by month_year
              order by Average_composition desc) as rank
From interest_metrics im
Inner Join interest_map im1
On im.interest_id :: int = im1.id),

semi_final_sol as(
Select month_year,interest_name,Average_composition as max_index_composition,
(AVG(Average_composition) OVER(ORDER BY
            month_year ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW)
      ) :: numeric(10, 2) AS _3_month_moving_avg,
Concat(
	Lag(interest_name,1) over(order by month_year),
  	': ',
  	Lag(Average_composition,1) over(order by month_year)
) as _1_month_ago,
Concat(
	Lag(interest_name,2) over(order by month_year),
  	': ',
  	Lag(Average_composition,2) over(order by month_year)
) as _2_month_ago
From ranked_month_compostion
Where rank = 1 
Order by month_year)

Select month_year,interest_name,max_index_composition,
_3_month_moving_avg,_1_month_ago,_2_month_ago
From semi_final_sol
Where month_year > '2018-08-01'
Order By month_year
