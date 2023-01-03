SET search_path = data_mart;

DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT
	To_date(week_date, 'dd/mm/yy') as date,
  	Extract('week' from To_date(week_date, 'dd/mm/yy')) as week,
  	Extract('month' from To_date(week_date, 'dd/mm/yy')) as month,
  	Extract('year' from To_date(week_date, 'dd/mm/yy')) as year
FROM weekly_sales);
  
Select * from clean_weekly_sales