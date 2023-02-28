# 🛍️ Case Study #5 - Data Mart
<img src="https://8weeksqlchallenge.com/images/case-study-designs/5.png" alt="Image" width="500" height="520">

- [Introduction](#Introduction)
- [Tables](#tables)
- [ERD](#ERD)
- [Case Study Questions](#Case-Study-Questions)
***
## Introduction
Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:

- What was the quantifiable impact of the changes introduced in June 2020?
- Which platform, region, segment and customer types were the most impacted by this change?
- What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?
Available Data
***
## Tables
For this case study there is only a single table: `data_mart.weekly_sales`

The `Entity Relationship Diagram` is shown below with the data types made clear, please note that there is only this one table - hence why it looks a little bit lonely!
| week_date | region | platform | segment | customer_type | transactions | sales    |
| --------- | ------ | -------- | ------- | ------------- | ------------ | -------- |
| 31/8/20   | ASIA   | Retail   | C3      | New           | 120631       | 3656163  |
| 31/8/20   | ASIA   | Retail   | F1      | New           | 31574        | 996575   |
| 31/8/20   | USA    | Retail   | null    | Guest         | 529151       | 16509610 |
| 31/8/20   | EUROPE | Retail   | C1      | New           | 4517         | 141942   |
| 31/8/20   | AFRICA | Retail   | C2      | New           | 58046        | 1758388  |
| 31/8/20   | CANADA | Shopify  | F2      | Existing      | 1336         | 243878   |
| 31/8/20   | AFRICA | Shopify  | F3      | Existing      | 2514         | 519502   |
| 31/8/20   | ASIA   | Shopify  | F1      | Existing      | 2158         | 371417   |
| 31/8/20   | AFRICA | Shopify  | F2      | New           | 318          | 49557    |
| 31/8/20   | AFRICA | Retail   | C3      | New           | 111032       | 3888162  |

The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:

1. Data Mart has international operations using a multi-`region` strategy
2. Data Mart has both, a retail and online `platform` in the form of a Shopify store front to serve their customers
3. Customer `segment` and `customer_type` data relates to personal age and demographics information that is shared with Data Mart
4. `transactions` is the count of unique purchases made through Data Mart and `sales` is the actual dollar amount of purchases.

Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a `week_date` value which represents the start of the sales week.
## ERD
![image](https://8weeksqlchallenge.com/images/case-study-5-erd.png)
***
## Case Study Questions
### 1. Data Cleansing Steps
In a single query, perform the following operations and generate a new table in the `data_mart` schema named `clean_weekly_sales`:

- Convert the `week_date` to a DATE format

- Add a `week_number` as the second column for each `week_date` value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

- Add a `month_number` with the calendar month for each `week_date` value as the 3rd column

- Add a `calendar_year` column as the 4th column containing either 2018, 2019 or 2020 values

- Add a new column called `age_band` after the original segment column using the following mapping on the number inside the `segment` value.

|segment|age_band|
|--|--|
|1|Young Adults|
|2|Middle Aged|
|3,4|Retirees|
- Add a new `demographic` column using the following mapping for the first letter in the `segment` values:

|segment|demographic|
|--|--|
|C|Couples|
|F|Families|
- Ensure all `null` string values with an `"unknown"` string value in the original `segment` column as well as the new `age_band` and `demographic` columns.
- Generate a new `avg_transaction` column as the sales value divided by `transactions` rounded to 2 decimal places for each record.
### 2. Data Exploration
1. What day of the week is used for each `week_date` value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which `age_band` and `demographic` values contribute the most to Retail sales?
9. Can we use the `avg_transaction` column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
### 3. Before & After Analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the `week_date` value of `2020-06-15` as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all `week_date` values for `2020-06-15` as the start of the period after the change and the previous `week_date` values would be before

Using this analysis approach - answer the following questions:
1. What is the total sales for the 4 weeks before and after `2020-06-15`? What is the growth or reduction rate in actual values and percentage of sales?
2. What about the entire 12 weeks before and after?
3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
### 4. Bonus Question
Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?

- region
- platform
- age_band
- demographic
- customer_type

Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?