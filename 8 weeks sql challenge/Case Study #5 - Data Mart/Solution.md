# Solution
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