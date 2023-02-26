--What day of the week is used for each week_date value?
Select 
	To_Char(Date,'Day')
From clean_weekly_sales
Limit 1;


-- What range of week numbers are missing from the dataset?
With weeks as 
(Select Generate_series(1,52) as week_numbers)

Select * From weeks
Where week_numbers not in 
(Select week From clean_weekly_sales);

--How many total transactions were there for each year in the dataset?
Select year, Count(transactions)
From clean_weekly_sales 
Group By year

-- What is the total sales for each region for each month?
Select region,month,Sum(sales)
From clean_weekly_sales
Group By region,month
Order By region,month

-- What is the total count of transactions for each platform
Select platform,Count(transactions)
From clean_weekly_sales
Group By platform	
Order By platform


--What is the percentage of sales for Retail vs Shopify for each month?
With platform_monthly_sales as(
  Select month,platform,sum(sales) total_platform_month
  From clean_weekly_sales
  Group by month,platform	
  Order by month,platform),

monthly_sales as 
  (SELECT month,Sum(sales) total_month
  From clean_weekly_sales
  Group By month
  Order By month)

Select m.month,
	Round(100 *Min(
    Case 
    	When platform = 'Retail'
        Then total_platform_month :: Numeric/ total_month :: Numeric
    End),2)as retail_percent,
  Round(100*Min(
    Case 
    	When platform = 'Shopify'
        Then total_platform_month :: Numeric/ total_month :: Numeric
    End),2) as Shopify_percent
From monthly_sales m
Inner join platform_monthly_sales p
On m.month = p.month
Group By 1

--or 
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


--Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
Select year,platform,
	Round(avg(avg_transaction)) avg_transaction,
    sum(sales)/sum(transactions) as avg_calculated_transcations
    from clean_weekly_sales
    group by 1,2
    order by 1,2