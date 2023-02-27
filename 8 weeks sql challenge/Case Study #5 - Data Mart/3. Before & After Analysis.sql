SET search_path = data_mart;
--What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
with base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Four_weeks_sales as(
Select 
	Sum(
		Case
			When week Between
			(Select week From base_week) And
			(Select week From base_week) + 3 
			And year = 2020
			Then sales End)as after_sales,
    Sum(
		Case
    		When week Between
      			(Select week From base_week) - 4 And
                (Select week From base_week) - 1 
    			And year = 2020
                Then sales End)as before_sales
   From clean_weekly_sales) 
   
Select after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    From Four_weeks_sales;


-- What about the entire 12 weeks before and after?
With base_week as(
  Select week
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select 
		Sum(
			Case
				When week Between
					(Select week From base_week) And
					(Select week From base_week) + 11 
					And year = 2020
				Then sales End)as after_sales,
    	Sum(
			Case
    			When week Between
      				(Select week From base_week) - 12 And
                	(Select week From base_week) - 1 
    				And year = 2020
                Then sales end)as before_sales
    From clean_weekly_sales) 
   
Select after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    From Twelve_weeks_sales;

-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
-- we use only 12 weeks example
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' limit 1),

Twelve_weeks_sales as(
Select year,
	Sum(
		Case
			When week Between
				(Select week From base_week) And
				(Select week From base_week) + 11 
			Then sales End)as after_sales,
    sum(
		Case
    		when week Between
      			(Select week From base_week) - 12 And
                (Select week From base_week) - 1 
            Then sales End)as before_sales
   From clean_weekly_sales
   Group by 1) 
   
Select year,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By year

