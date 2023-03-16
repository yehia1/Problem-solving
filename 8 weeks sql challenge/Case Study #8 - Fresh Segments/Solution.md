# Case Study #8- Fresh Segments
## Data Exploration and Cleansing
### 1. Update the <span style="color:red">fresh_segments.interest_metrics</span> table by modifying the <span style="color:red">month_year</span>  column to be a date data type with the start of the month
This is new query and how to make alter in postgress sql which gave me alot of error when i use the normal way
```
ALTER TABLE interest_metrics
ALTER COLUMN month_year TYPE DATE USING TO_DATE(month_year, 'MM-YYYY');
```
### 2.What is count of records in the <span style="color:red">fresh_segments.interest_metrics</span>  for each <span style="color:red">month_year</span>  value sorted in chronological order (earliest to latest) with the null values appearing first?
This query is good to know how to get the nulls first in order by
```
Select month_year,Count(*) as records_count
From interest_metrics
Group By 1
Order By month_year Nulls First;
```
| month_year               | records_count |
| ------------------------ | ------------- |
|                          | 1194          |
| 2018-07-01T00:00:00.000Z | 729           |
| 2018-08-01T00:00:00.000Z | 767           |
| 2018-09-01T00:00:00.000Z | 780           |
| 2018-10-01T00:00:00.000Z | 857           |
| 2018-11-01T00:00:00.000Z | 928           |
| 2018-12-01T00:00:00.000Z | 995           |
| 2019-01-01T00:00:00.000Z | 973           |
| 2019-02-01T00:00:00.000Z | 1121          |
| 2019-03-01T00:00:00.000Z | 1136          |
| 2019-04-01T00:00:00.000Z | 1099          |
| 2019-05-01T00:00:00.000Z | 857           |
| 2019-06-01T00:00:00.000Z | 824           |
| 2019-07-01T00:00:00.000Z | 864           |
| 2019-08-01T00:00:00.000Z | 1149          |
### 3. What do you think we should do with these null values in the <span style="color:red">fresh_segments.interest_metrics</span> 
We can do multiple methods
- Check for the importance of these nulls if it's importand we can fill forward or backward or the most common solution is filling with mean
- If not important we can drop
### 4. How many <span style="color:red">interest_id</span> values exist in the <span style="color:red">fresh_segments.interest_metrics</span> table but not in the <span style="color:red">fresh_segments.interest_map</span> table? What about the other way around?
```
Select Count(interest_id) as distincts From interest_metrics
Where 
	interest_id :: Int Not In
    (Select id FROM interest_map)
Union
Select count(id) From interest_map
Where 
	id Not In
    (Select interest_id :: int From interest_metrics
    Where interest_id Is Not Null);
```
| distincts |
| --------- |
| 0         |
| 7         |
### 5. Summarise the <span style="color:red">id</span>  values in the <span style="color:red">fresh_segments.interest_map</span> by its total record count in this table
```
SELECT Count(id) From interest_map;
```
| count |
| ----- |
| 1209  |
### 6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where <span style="color:red">finterest_id = 21246</span> in your joined output and include all columns from <span style="color:red">fresh_segments.interest_metrics</span>and all columns from <span style="color:red">fresh_segments.interest_map</span> except from the <span style="color:red">id</span> column.
```
Select im.*,im1.interest_name,
		im1.interest_summary,im1.created_at,im1.last_modified
From interest_metrics im
Inner Join interest_map im1
On im1.id = im.interest_id :: Numeric
Where interest_id = '21246'
Order By im.month_year Nulls First;
```
| _month | _year | month_year               | interest_id | composition | index_value | ranking | percentile_ranking | interest_name                    | interest_summary                                      | created_at               | last_modified            |
| ------ | ----- | ------------------------ | ----------- | ----------- | ----------- | ------- | ------------------ | -------------------------------- | ----------------------------------------------------- | ------------------------ | ------------------------ |
|        |       |                          | 21246       | 1.61        | 0.68        | 1191    | 0.25               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 7      | 2018  | 2018-07-01T00:00:00.000Z | 21246       | 2.26        | 0.65        | 722     | 0.96               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 8      | 2018  | 2018-08-01T00:00:00.000Z | 21246       | 2.13        | 0.59        | 765     | 0.26               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 9      | 2018  | 2018-09-01T00:00:00.000Z | 21246       | 2.06        | 0.61        | 774     | 0.77               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 10     | 2018  | 2018-10-01T00:00:00.000Z | 21246       | 1.74        | 0.58        | 855     | 0.23               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 11     | 2018  | 2018-11-01T00:00:00.000Z | 21246       | 2.25        | 0.78        | 908     | 2.16               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 12     | 2018  | 2018-12-01T00:00:00.000Z | 21246       | 1.97        | 0.7         | 983     | 1.21               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 1      | 2019  | 2019-01-01T00:00:00.000Z | 21246       | 2.05        | 0.76        | 954     | 1.95               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 2      | 2019  | 2019-02-01T00:00:00.000Z | 21246       | 1.84        | 0.68        | 1109    | 1.07               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 3      | 2019  | 2019-03-01T00:00:00.000Z | 21246       | 1.75        | 0.67        | 1123    | 1.14               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
| 4      | 2019  | 2019-04-01T00:00:00.000Z | 21246       | 1.58        | 0.63        | 1092    | 0.64               | Readers of El Salvadoran Content | People reading news from El Salvadoran media sources. | 2018-06-11T17:50:04.000Z | 2018-06-11T17:50:04.000Z |
### 7.Are there any records in your joined table where the <span style="color:red">month_year</span> value is before the <span style="color:red">created_at</span> value from the <span style="color:red">fresh_segments.interest_map</span> table? Do you think these values are valid and why?
```
Select count(im.*) From
interest_metrics im 
Inner join interest_map im1
On im.interest_id :: Int = im1.id
Where month_year < created_at
```
| count |
| ----- |
| 188   |
***
## Interest Analysis
### 1. Which interests have been present in all <span style="color:red">month_year</span> dates in our dataset?
```
Select interest_name , count(interest_name) as interest_count
From interest_map im
left join interest_metrics im1
on im1.interest_id :: int = im.id
where month_year in 
( SELECT DISTINCT month_year FROM interest_metrics)
group by 1
having count(interest_name) = 14
Limit 10;
```
| interest_name                             | interest_count |
| ----------------------------------------- | -------------- |
| Military Families                         | 14             |
| Used Car Shoppers                         | 14             |
| Federal Employees                         | 14             |
| Vacation Rental Accommodation Researchers | 14             |
| College Aspirants                         | 14             |
| Realtors & Real Estate Researchers        | 14             |
| Pandora Jewelry Shoppers                  | 14             |
| Wireless Service Provider Researchers     | 14             |
| Tractor Shoppers                          | 14             |
| Phone Accessory Shoppers                  | 14             |
### 2. Using this same <span style="color:red">total_months</span> measure - calculate the cumulative percentage of all records starting at 14 months - which <span style="color:red">total_months</span>  value passes the 90% cumulative percentage value?
[I didn't understand the question well so the work is still in progress]
## Segment Analysis
[Work under progress]
## Index Analysis
### The <span style="color:red">index_value</span>  is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
 ### Average <span style="color:red">composition</span> can be calculated by dividing the composition column by the <span style="color:red">index_value</span>  column rounded to 2 decimal places.
 ```
ALTER TABLE interest_metrics
ADD Average_composition Decimal(10,2);

UPDATE interest_metrics SET Average_composition = composition / index_value ;
```
### 1. What is the top 10 interests by the average composition for each month?
we took only first month of output 
```
With ranked_month_compostion as(
Select month_year,interest_name,
	rank() over(partition by month_year
              order by Average_composition desc) as rank
From interest_metrics im
Inner Join interest_map im1
On im.interest_id :: int = im1.id)

Select month_year,interest_name
From ranked_month_compostion
Where rank <= 10
Limit 10;
```
| month_year               | interest_name                 |
| ------------------------ | ----------------------------- |
| 2018-07-01T00:00:00.000Z | Las Vegas Trip Planners       |
| 2018-07-01T00:00:00.000Z | Gym Equipment Owners          |
| 2018-07-01T00:00:00.000Z | Cosmetics and Beauty Shoppers |
| 2018-07-01T00:00:00.000Z | Luxury Retail Shoppers        |
| 2018-07-01T00:00:00.000Z | Furniture Shoppers            |
| 2018-07-01T00:00:00.000Z | Asian Food Enthusiasts        |
| 2018-07-01T00:00:00.000Z | Recently Retired Individuals  |
| 2018-07-01T00:00:00.000Z | Family Adventures Travelers   |
| 2018-07-01T00:00:00.000Z | Work Comes First Travelers    |
| 2018-07-01T00:00:00.000Z | HDTV Researchers              |
This is top ten for july 2018 and so on
### 2. For all of these top 10 interests - which interest appears the most often?
```
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
```
| interest_name              | count |
| -------------------------- | ----- |
| Solar Energy Researchers | 10     |
### What is the average of the average composition for the top 10 interests for each month?
```
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
```
| month_year               | avg                |
| ------------------------ | ------------------ |
| 2018-07-01T00:00:00.000Z | 6.0380000000000000 |
| 2018-08-01T00:00:00.000Z | 5.9450000000000000 |
| 2018-09-01T00:00:00.000Z | 6.8950000000000000 |
| 2018-10-01T00:00:00.000Z | 7.0660000000000000 |
| 2018-11-01T00:00:00.000Z | 6.6230000000000000 |
| 2018-12-01T00:00:00.000Z | 6.6520000000000000 |
| 2019-01-01T00:00:00.000Z | 6.3154545454545455 |
| 2019-02-01T00:00:00.000Z | 6.5790000000000000 |
| 2019-03-01T00:00:00.000Z | 6.1172727272727273 |
| 2019-04-01T00:00:00.000Z | 5.7500000000000000 |
| 2019-05-01T00:00:00.000Z | 3.5370000000000000 |
| 2019-06-01T00:00:00.000Z | 2.4270000000000000 |
| 2019-07-01T00:00:00.000Z | 2.7650000000000000 |
| 2019-08-01T00:00:00.000Z | 2.6310000000000000 |
|                          | 2.3700000000000000 |

### What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
This query took from me a long time and this 
(AVG(Average_composition) OVER(ORDER BY
            month_year ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW)
was tottaly new function to me
```
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

```
| month_year               | interest_name                 | max_index_composition | _3_month_moving_avg | _1_month_ago                      | _2_month_ago                      |
| ------------------------ | ----------------------------- | --------------------- | ------------------- | --------------------------------- | --------------------------------- |
| 2018-09-01T00:00:00.000Z | Work Comes First Travelers    | 8.26                  | 7.61                | Las Vegas Trip Planners: 7.21     | Las Vegas Trip Planners: 7.36     |
| 2018-10-01T00:00:00.000Z | Work Comes First Travelers    | 9.14                  | 8.20                | Work Comes First Travelers: 8.26  | Las Vegas Trip Planners: 7.21     |
| 2018-11-01T00:00:00.000Z | Work Comes First Travelers    | 8.28                  | 8.56                | Work Comes First Travelers: 9.14  | Work Comes First Travelers: 8.26  |
| 2018-12-01T00:00:00.000Z | Work Comes First Travelers    | 8.31                  | 8.58                | Work Comes First Travelers: 8.28  | Work Comes First Travelers: 9.14  |
| 2019-01-01T00:00:00.000Z | Work Comes First Travelers    | 7.66                  | 8.08                | Work Comes First Travelers: 8.31  | Work Comes First Travelers: 8.28  |
| 2019-02-01T00:00:00.000Z | Work Comes First Travelers    | 7.66                  | 7.88                | Work Comes First Travelers: 7.66  | Work Comes First Travelers: 8.31  |
| 2019-03-01T00:00:00.000Z | Alabama Trip Planners         | 6.54                  | 7.29                | Work Comes First Travelers: 7.66  | Work Comes First Travelers: 7.66  |
| 2019-04-01T00:00:00.000Z | Solar Energy Researchers      | 6.28                  | 6.83                | Alabama Trip Planners: 6.54       | Work Comes First Travelers: 7.66  |
| 2019-05-01T00:00:00.000Z | Readers of Honduran Content   | 4.41                  | 5.74                | Solar Energy Researchers: 6.28    | Alabama Trip Planners: 6.54       |
| 2019-06-01T00:00:00.000Z | Las Vegas Trip Planners       | 2.77                  | 4.49                | Readers of Honduran Content: 4.41 | Solar Energy Researchers: 6.28    |
| 2019-07-01T00:00:00.000Z | Las Vegas Trip Planners       | 2.82                  | 3.33                | Las Vegas Trip Planners: 2.77     | Readers of Honduran Content: 4.41 |
| 2019-08-01T00:00:00.000Z | Cosmetics and Beauty Shoppers | 2.73                  | 2.77                | Las Vegas Trip Planners: 2.82     | Las Vegas Trip Planners: 2.77     |
### 5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?
maybe because customer lose interest of product or there is a new product that takes all the hype.