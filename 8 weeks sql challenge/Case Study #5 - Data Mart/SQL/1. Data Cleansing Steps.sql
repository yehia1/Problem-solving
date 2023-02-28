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
  
Select * from clean_weekly_sales