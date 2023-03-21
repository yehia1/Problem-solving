# 🛍️ Case Study #5 - Data Mart
## 1. Data Cleansing Steps
### Convert the week_date to a DATE format
```
To_date(week_date, 'dd/mm/yy') as date
```
### Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
```
Extract('week' From To_date(week_date, 'dd/mm/yy')) as week
```
### Add a month_number with the calendar month for each week_date value as the 3rd column
```
Extract('month' From To_date(week_date, 'dd/mm/yy')) as month
```
### Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
```
Extract('year' From To_date(week_date, 'dd/mm/yy')) as year
```
### Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
```
Case 
  	When Right(segment,1) = '1' Then 'Young Adults'
  	When Right(segment,1) = '2' Then 'Middle Aged'
  	When Right(segment,1) in ('3','4') Then 'Retired'
  	Else 'unknown'
  	End as age_band,
```
### Add a new demographic column using the following mapping for the first letter in the segment values:
```
Case
  	When Left(segment,1) = 'C' Then 'Couples'
  	When Left(segment,1) = 'F' Then 'Families'
  	Else 'unknown'
  	End as demographic,
```
### Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
```
Round(sales :: Numeric /transactions :: Numeric ,2)
  as avg_transaction
```

### All the query and the result 
```
SET search_path = data_mart;

DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT
	To_date(week_date, 'dd/mm/yy') as date,
  	Extract('week' From To_date(week_date, 'dd/mm/yy')) as week,
  	Extract('month' From To_date(week_date, 'dd/mm/yy')) as month,
  	Extract('year' From To_date(week_date, 'dd/mm/yy')) as year,
  region,
  platform,
  segment,
Case 
  	When Right(segment,1) = '1' Then 'Young Adults'
  	When Right(segment,1) = '2' Then 'Middle Aged'
  	When Right(segment,1) in ('3','4') Then 'Retired'
  	Else 'unknown'
  	End as age_band,
Case
  	When Left(segment,1) = 'C' Then 'Couples'
  	When Left(segment,1) = 'F' Then 'Families'
  	Else 'unknown'
  	End as demographic,
  customer_type,
  transactions,
  sales,
  Round(sales :: Numeric /transactions :: Numeric ,2)
  as avg_transaction
FROM weekly_sales);
```
| date                     | week | month | year | region | platform | segment | age_band     | demographic | customer_type | transactions | sales    | avg_transaction |
| ------------------------ | ---- | ----- | ---- | ------ | -------- | ------- | ------------ | ----------- | ------------- | ------------ | -------- | --------------- |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | ASIA   | Retail   | C3      | Retired      | Couples     | New           | 120631       | 3656163  | 30.31           |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | ASIA   | Retail   | F1      | Young Adults | Families    | New           | 31574        | 996575   | 31.56           |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | USA    | Retail   | null    | unknown      | unknown     | Guest         | 529151       | 16509610 | 31.20           |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | EUROPE | Retail   | C1      | Young Adults | Couples     | New           | 4517         | 141942   | 31.42           |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | AFRICA | Retail   | C2      | Middle Aged  | Couples     | New           | 58046        | 1758388  | 30.29           |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | CANADA | Shopify  | F2      | Middle Aged  | Families    | Existing      | 1336         | 243878   | 182.54          |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | AFRICA | Shopify  | F3      | Retired      | Families    | Existing      | 2514         | 519502   | 206.64          |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | ASIA   | Shopify  | F1      | Young Adults | Families    | Existing      | 2158         | 371417   | 172.11          |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | AFRICA | Shopify  | F2      | Middle Aged  | Families    | New           | 318          | 49557    | 155.84          |
| 2020-08-31T00:00:00.000Z | 36   | 8     | 2020 | AFRICA | Retail   | C3      | Retired      | Couples     | New           | 111032       | 3888162  | 35.02           |
***
## 2. Data Exploration
### What day of the week is used for each week_date value?
From result it's only monday there so we took it.
```
Select 
	To_Char(Date,'Day')as day
From clean_weekly_sales
Limit 1;
```
| day   |
| --------- |
| Monday    |
### What range of week numbers are missing from the dataset?
```
With weeks as 
(Select Generate_series(1,52) as week_numbers)

Select * From weeks
Where week_numbers not in 
(Select week From clean_weekly_sales);
```
| week_numbers |
| ------------ |
| 1            |
| 2            |
| 3            |
| 4            |
| 5            |
| 6            |
| 7            |
| 8            |
| 9            |
| 10           |
| 11           |
| 12           |
| 37           |
| 38           |
| 39           |
| 40           |
| 41           |
| 42           |
| 43           |
| 44           |
| 45           |
| 46           |
| 47           |
| 48           |
| 49           |
| 50           |
| 51           |
| 52           |
### How many total transactions were there for each year in the dataset?
```
Select year, Count(transactions) as number_of_transcations
From clean_weekly_sales 
Group By year
```
| year | number_of_transcations |
| ---- | ---------------------- |
| 2019 | 5708                   |
| 2018 | 5698                   |
| 2020 | 5711                   |
### What is the total sales for each region for each month?
I took a random 10 sample from the result.
```
Select region,month,Sum(sales)
From clean_weekly_sales
Group By region,month
Order By region,month
```
| region        | month | sales      |
| ------------- | ----- | ---------- |
| AFRICA        | 4     | 1911783504 |
| USA           | 7     | 760331754  |
| OCEANIA       | 7     | 2563459400 |
| SOUTH AMERICA | 3     | 71023109   |
| ASIA          | 4     | 1804628707 |
| AFRICA        | 9     | 276320987  |
| OCEANIA       | 9     | 372465518  |
| AFRICA        | 5     | 1647244738 |
| OCEANIA       | 6     | 2371884744 |
| CANADA        | 8     | 447073019  |
### What is the total count of transactions for each platform 
```
Select platform,Count(transactions) as number_of_transcations
From clean_weekly_sales
Group By platform	
Order By platform
```
| platform | number_of_transcations |
| -------- | ---------------------- |
| Retail   | 8568                   |
| Shopify  | 8549                   |
### What is the percentage of sales for Retail vs Shopify for each month?
```
With Retail_monthly_sales as(
  Select month,platform,Sum(sales) total_retail_month
  From clean_weekly_sales
  Where platform = 'Retail'
  Group By month,platform	
  Order By month,platform),

Shopify_monthly_sales as(
  Select month,platform,Sum(sales) total_shopify_month
  From clean_weekly_sales
  Where platform = 'Shopify'
  Group By month,platform	
  Order By month,platform),

monthly_sales as (
  Select month,Sum(sales) total_month
  From clean_weekly_sales
  Group By month
  Order By month)

Select m.month,
	Round(100 * total_retail_month :: Numeric / total_month,2)
	as retail_percent,
    Round(100 * total_shopify_month :: Numeric / total_month,2)
	as shopify_percent
From Retail_monthly_sales r
Inner Join monthly_sales m
On r.month = m.month
Inner Join Shopify_monthly_sales s 
On s.month = m.month
```
| month | retail_percent | shopify_percent |
| ----- | -------------- | --------------- |
| 3     | 97.54          | 2.46            |
| 4     | 97.59          | 2.41            |
| 5     | 97.30          | 2.70            |
| 6     | 97.27          | 2.73            |
| 7     | 97.29          | 2.71            |
| 8     | 97.08          | 2.92            |
| 9     | 97.38          | 2.62            |
### What is the percentage of sales by demographic for each year in the dataset?
```
With demograpic_sales as (
Select year,demographic,Sum(sales) yearly_sales
From clean_weekly_sales
Group By year,demographic
Order By year,demographic)

Select year, 
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'Couples' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS couples_percentage,
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'Families' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS families_percentage,
  ROUND(100 * MAX 
    (CASE WHEN demographic = 'unknown' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS unknown_percentage
FROM demograpic_sales
GROUP BY year
ORDER BY year;
```
| year | couples_percentage | families_percentage | unknown_percentage |
| ---- | ------------------ | ------------------- | ------------------ |
| 2018 | 26.38              | 31.99               | 41.63              |
| 2019 | 27.28              | 32.47               | 40.25              |
| 2020 | 28.72              | 32.73               | 38.55              |
### Which age_band and demographic values contribute the most to Retail sales?
```
SELECT age_band,
    demographic,
   	Sum(sales) sum_sales,
    Round(100 * SUM(sales)::NUMERIC / Sum(Sum(sales)) Over(),2) as contribution_percentage
From clean_weekly_sales
Where platform = 'Retail'
Group By 1,2
Order By 3 desc
```
| age_band     | demographic | sum_sales   | contribution_percentage |
| ------------ | ----------- | ----------- | ----------------------- |
| unknown      | unknown     | 16067285533 | 40.52                   |
| Retired      | Families    | 6634686916  | 16.73                   |
| Retired      | Couples     | 6370580014  | 16.07                   |
| Middle Aged  | Families    | 4354091554  | 10.98                   |
| Young Adults | Couples     | 2602922797  | 6.56                    |
| Middle Aged  | Couples     | 1854160330  | 4.68                    |
| Young Adults | Families    | 1770889293  | 4.47                    |
### Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
yes it's so near to the real ones.
```
Select year,platform,
	Round(avg(avg_transaction)) avg_transaction,
  sum(sales)/sum(transactions) as avg_calculated_transcations
From clean_weekly_sales
Group By 1,2
Order By 1,2
```
| year | platform | avg_transaction | avg_calculated_transcations |
| ---- | -------- | --------------- | --------------------------- |
| 2018 | Retail   | 43              | 36                          |
| 2018 | Shopify  | 188             | 192                         |
| 2019 | Retail   | 42              | 36                          |
| 2019 | Shopify  | 178             | 183                         |
| 2020 | Retail   | 41              | 36                          |
| 2020 | Shopify  | 175             | 179                         |
***
## Before and After analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the `week_date` value of `2020-06-15` as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all `week_date` values for `2020-06-15` as the start of the period after the change and the previous week_date values would be before
### What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
```
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
```
| after_sales | before_sales | total_diff | sales_change_percent |
| ----------- | ------------ | ---------- | -------------------- |
| 2318994169  | 2345878357   | -26884188  | -1.15                |
### What about the entire 12 weeks before and after?
```
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
```
| after_sales | before_sales | total_diff | sales_change_percent |
| ----------- | ------------ | ---------- | -------------------- |
| 6973947753  | 7126273147   | -152325394 | -2.14                |
### How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
taking the 12 as example for each year
```
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
```
| year | after_sales | before_sales | total_diff | sales_change_percent |
| ---- | ----------- | ------------ | ---------- | -------------------- |
| 2018 | 6500818510  | 6396562317   | 104256193  | 1.63                 |
| 2019 | 6862646103  | 6883386397   | -20740294  | -0.30                |
| 2020 | 6973947753  | 7126273147   | -152325394 | -2.14                |
From the result there is a decreasing in sales.
***
## Bonus Question
Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
### region
```
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select region,
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
    Group by 1) 
   
Select region,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By region
```
| region        | after_sales | before_sales | total_diff | sales_change_percent |
| ------------- | ----------- | ------------ | ---------- | -------------------- |
| AFRICA        | 1700390294  | 1709537105   | -9146811   | -0.54                |
| ASIA          | 1583807621  | 1637244466   | -53436845  | -3.26                |
| CANADA        | 418264441   | 426438454    | -8174013   | -1.92                |
| EUROPE        | 114038959   | 108886567    | 5152392    | 4.73                 |
| OCEANIA       | 2282795690  | 2354116790   | -71321100  | -3.03                |
| SOUTH AMERICA | 208452033   | 213036207    | -4584174   | -2.15                |
| USA           | 666198715   | 677013558    | -10814843  | -1.60                |
All the sales got negative percentage except for Europe
### platform
```
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
```
| platform | after_sales | before_sales | total_diff | sales_change_percent |
| -------- | ----------- | ------------ | ---------- | -------------------- |
| Retail   | 6738777279  | 6906861113   | -168083834 | -2.43                |
| Shopify  | 235170474   | 219412034    | 15758440   | 7.18                 |
shopify got good sales increase percentage.
### age_band
```
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
```
| age_band     | after_sales | before_sales | total_diff | sales_change_percent |
| ------------ | ----------- | ------------ | ---------- | -------------------- |
| Middle Aged  | 1141853348  | 1164847640   | -22994292  | -1.97                |
| Retired      | 2365714994  | 2395264515   | -29549521  | -1.23                |
| Young Adults | 794417968   | 801806528    | -7388560   | -0.92                |
| unknown      | 2671961443  | 2764354464   | -92393021  | -3.34                |
all the metrices is bad here.
### demographic
```
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
```
| demographic | after_sales | before_sales | total_diff | sales_change_percent |
| ----------- | ----------- | ------------ | ---------- | -------------------- |
| Couples     | 2015977285  | 2033589643   | -17612358  | -0.87                |
| Families    | 2286009025  | 2328329040   | -42320015  | -1.82                |
| unknown     | 2671961443  | 2764354464   | -92393021  | -3.34                |
all is negative again.
### customer_type
```
With base_week as(
  Select week 
  From clean_weekly_sales
  Where date = '2020-6-15' Limit 1),

Twelve_weeks_sales as(
	Select customer_type,
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
   
Select customer_type,after_sales,before_sales,
	after_sales - before_sales as total_diff,
    Round(100*(after_sales - before_sales) ::Numeric/ before_sales ,2) as sales_change_percent
From Twelve_weeks_sales
Order By customer_type
```
| customer_type | after_sales | before_sales | total_diff | sales_change_percent |
| ------------- | ----------- | ------------ | ---------- | -------------------- |
| Existing      | 3606243454  | 3690116427   | -83872973  | -2.27                |
| Guest         | 2496233635  | 2573436301   | -77202666  | -3.00                |
| New           | 871470664   | 862720419    | 8750245    | 1.01                 |

New customers gives a good sales percentage in 2020
