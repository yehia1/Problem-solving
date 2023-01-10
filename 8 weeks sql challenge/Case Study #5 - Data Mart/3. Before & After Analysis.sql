SET search_path = data_mart;
--What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
with base_week as(
  	select week from
  clean_weekly_sales
  where date = '2020-6-15' limit 1),

Four_weeks_sales as(
Select 
	sum(case
	when week between
	(Select week from base_week) and
	(Select week from base_week) + 3 
	and year = 2020
	then sales end)as after_sales,
    sum(case
    	when week between
      				(Select week from base_week) - 4 and
                    (Select week from base_week) - 1 
    				and year = 2020
                    then sales end)as before_sales
   from clean_weekly_sales) 
   
Select after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    from Four_weeks_sales;


-- What about the entire 12 weeks before and after?
 with base_week as(
  	select week from
  clean_weekly_sales
  where date = '2020-6-15' limit 1),

Twelve_weeks_sales as(
Select 
	sum(case
	when week between
	(Select week from base_week) and
	(Select week from base_week) + 11 
	and year = 2020
	then sales end)as after_sales,
    sum(case
    	when week between
      				(Select week from base_week) - 12 and
                    (Select week from base_week) - 1 
    				and year = 2020
                    then sales end)as before_sales
   from clean_weekly_sales) 
   
Select after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    from Twelve_weeks_sales;

-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
-- we use only 12 weeks example
with base_week as(
  	select week from
  clean_weekly_sales
  where date = '2020-6-15' limit 1),

Twelve_weeks_sales as(
Select year,
	sum(case
	when week between
	(Select week from base_week) and
	(Select week from base_week) + 11 
	then sales end)as after_sales,
    sum(case
    	when week between
      				(Select week from base_week) - 12 and
                    (Select week from base_week) - 1 
                    then sales end)as before_sales
   from clean_weekly_sales
   Group by 1) 
   
Select year,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    from Twelve_weeks_sales
    order by year
