--What day of the week is used for each week_date value?
Select 
	To_Char(Date,'Day')
    from clean_weekly_sales
    Limit 1;


-- What range of week numbers are missing from the dataset?
With weeks as 
(Select Generate_series(1,52) as week_numbers)

Select * from weeks
where week_numbers not in 
(Select week from clean_weekly_sales);

--How many total transactions were there for each year in the dataset?
Select year, count(transactions)
from clean_weekly_sales 
group by year

-- What is the total sales for each region for each month?
Select region,month,sum(sales)
from clean_weekly_sales
group by region,month
order by region,month

-- What is the total count of transactions for each platform
Select platform,count(transactions)
from clean_weekly_sales
group by platform	
order by platform


--What is the percentage of sales for Retail vs Shopify for each month?

with platform_monthly_sales as(
Select month,platform,sum(sales) total_platform_month
from clean_weekly_sales
group by month,platform	
order by month,platform),

monthly_sales as 
(SELECT month,sum(sales) total_month
from clean_weekly_sales
group by month
order by month)

Select m.month,
	Round(100 *min(case 
    	when platform = 'Retail'
        then total_platform_month :: Numeric/ total_month :: Numeric
    end),2)as retail_percent,
    Round(100*min(case 
    	when platform = 'Shopify'
        then total_platform_month :: Numeric/ total_month :: Numeric
    end),2) as Shopify_percent
from monthly_sales m
inner join platform_monthly_sales p
on m.month = p.month
group by 1


-- What is the percentage of sales by demographic for each year in the dataset?
With demograpic_sales as (
Select year,demographic,sum(sales) yearly_sales
from clean_weekly_sales
Group By year,demographic
order By year,demographic)

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
GROUP BY 1
ORDER BY 1;


--Which age_band and demographic values contribute the most to Retail sales?
SELECT age_band,
    demographic,
   	Sum(sales) sum_sales,
    Round(100 * SUM(sales)::NUMERIC / sum(sum(sales)) over(),2) as contribution_percentage
    from clean_weekly_sales
    where platform = 'Retail'
    Group by 1,2
    order by 3 desc