SET search_path = data_mart;

DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT
	To_date(week_date, 'dd/mm/yy') as date,
  	Extract('week' from To_date(week_date, 'dd/mm/yy')) as week,
  	Extract('month' from To_date(week_date, 'dd/mm/yy')) as month,
  	Extract('year' from To_date(week_date, 'dd/mm/yy')) as year,
  region,
  platform,
  segment,
case 
  	when right(segment,1) = '1' then 'Young Adults'
  	when right(segment,1) = '2' then 'Middle Aged'
  	when right(segment,1) in ('3','4') then 'Retired'
  	else 'unknown'
  	end as age_band,
case
  	when left(segment,1) = 'C' then 'Couples'
  	when left(segment,1) = 'F' then 'Families'
  	else 'unknown'
  	end as demographic,
  customer_type,
  transactions,
  sales,
Round(sales :: Numeric /transactions :: Numeric ,2)
  as avg_transaction
FROM weekly_sales);
  
Select * from clean_weekly_sales