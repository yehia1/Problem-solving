SET search_path = data_mart;
--region
with base_week as(
  	select week from
  clean_weekly_sales
  where date = '2020-6-15' limit 1),

Twelve_weeks_sales as(
Select region,
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
   from clean_weekly_sales
   Group by 1) 
   
Select region,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    from Twelve_weeks_sales
    order by region

--platform
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select platform,
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
          Then sales End)as before_sales
   	From clean_weekly_sales
   	Group By 1) 
   
Select platform,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By platform

--age_band
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select age_band,
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
          Then sales End)as before_sales
   	From clean_weekly_sales
   	Group By 1) 
   
Select age_band,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By age_band



--demographic
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select demographic,
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
          Then sales End)as before_sales
   	From clean_weekly_sales
   	Group By 1) 
   
Select demographic,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By demographic

--customer_type
with base_week as(
  	select week from
  clean_weekly_sales
  where date = '2020-6-15' limit 1),

Twelve_weeks_sales as(
Select customer_type,
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
   from clean_weekly_sales
   Group by 1) 
   
Select customer_type,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
    from Twelve_weeks_sales
    order by customer_type