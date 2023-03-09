# 🪝Case Study #6 Clique Bait
## 1. Enterprise Relationship Diagram
```
CREATE TABLE clique_bait.event_identifier (
  "event_type" INTEGER,
  "event_name" VARCHAR(13)
);

CREATE TABLE clique_bait.campaign_identifier (
  "campaign_id" INTEGER,
  "products" VARCHAR(3),
  "campaign_name" VARCHAR(33),
  "start_date" TIMESTAMP,
  "end_date" TIMESTAMP
);

CREATE TABLE clique_bait.page_hierarchy (
  "page_id" INTEGER,
  "page_name" VARCHAR(14),
  "product_category" VARCHAR(9),
  "product_id" INTEGER
);

CREATE TABLE clique_bait.users (
  "user_id" INTEGER,
  "cookie_id" VARCHAR(6),
  "start_date" TIMESTAMP
);

CREATE TABLE clique_bait.events (
  "visit_id" VARCHAR(6),
  "cookie_id" VARCHAR(6),
  "page_id" INTEGER,
  "event_type" INTEGER,
  "sequence_number" INTEGER,
  "event_time" TIMESTAMP
);
```
![image](https://raw.githubusercontent.com/yehia1/Problem-solving/Main/8%20weeks%20sql%20challenge/Case%20Study%20%236%20-%20Clique%20Bait/ERD.png)
***
## 2. Digital Analysis
### How many users are there?
```
Select Count(distinct user_id) as number_of_users From users
```
| number_of_users |
| --------------- |
| 500             |
### How many cookies does each user have on average?
```
Select Round(Avg(counts)) as avg_cookies
From
(Select user_id,Count(cookie_id) as counts
From users
Group By 1) sub1
```
| avg_cookies |
| ----------- |
| 4           |
### What is the unique number of visits by all users per month?
```
Select Extract(Month From event_time) months,
	Count(distinct visit_id) Number_of_events
From events e
Group By 1
```
| months | number_of_events |
| ------ | ---------------- |
| 1      | 876              |
| 2      | 1488             |
| 3      | 916              |
| 4      | 248              |
| 5      | 36               |
### What is the number of events for each event type?
```
Select event_name,Count(e.*)
From events e
Inner Join event_identifier ei
On ei.event_type = e.event_type
Group By event_name;
```
| event_name    | count |
| ------------- | ----- |
| Purchase      | 1777  |
| Ad Impression | 876   |
| Add to Cart   | 8451  |
| Page View     | 20928 |
| Ad Click      | 702   |
### What is the percentage of visits which have a purchase event?
```
Select
	Round(100 * count(visit_id)::Numeric/
    (Select count(visit_id) from events),2) as Purchase_percentage
From events e
Inner Join event_identifier ei
On e.event_type = ei.event_type
Where event_name = 'Purchase' 
```
| purchase_percentage |
| ------------------- |
| 5.43                |
### What is the percentage of visits which view the checkout page but do not have a purchase event?
```
With Events_counter as(
Select Distinct visit_id,event_name,
LEAD(event_name, 1) OVER(PARTITION BY visit_id ORDER BY event_name) as next_event
FROM events e
Join event_identifier ei 
On e.event_type = ei.event_type
Where e.event_type In (2,3)
Order By 1,2)

Select 
	Round(100 * Count(event_name) :: Numeric/
          (Select count(event_name)FROM Events_counter),2)
          AS No_Purchase_Checkout_Percentage
From Events_counter
Where event_name = 'Add to Cart'
And next_event Is null
```
| no_purchase_checkout_percentage |
| ------------------------------- |
| 11.53                           |
### What are the top 3 pages by number of views?
```
Select page_name ,Count(visit_id) as number_of_views
From events e
Inner Join page_hierarchy p
On e.page_id = p.page_id
Group By page_name
Order By number_of_views desc
Limit 3;
```
| page_name    | number_of_views |
| ------------ | --------------- |
| All Products | 4752            |
| Lobster      | 2515            |
| Crab         | 2513            |
### What is the number of views and cart adds for each product category?
```
Select product_category,
 Sum(Case When event_type = 1 Then 1 End)as view_numbers,
 Sum(Case When event_type = 2 Then 1 End)as add_to_cart_numbers
From events e
Inner Join Page_Hierarchy p
On e.page_id = p.page_id
Where product_category Is Not null
Group By product_category
```
| product_category | view_numbers | add_to_cart_numbers |
| ---------------- | ------------ | ------------------- |
| Luxury           | 3032         | 1870                |
| Shellfish        | 6204         | 3792                |
| Fish             | 4633         | 2789                |
### What are the top 3 products by purchases?
all the orders is recoreded in one event so we can't seperate then normally so i searched for parrallel solution for this where we count `add to cart` for every product and then count them
```
SELECT page_name,number_of_purchases
FROM
(SELECT
      page_name,
      event_name,
      COUNT(event_name) AS number_of_purchases
    FROM
      events AS e
      JOIN page_hierarchy AS pe ON e.page_id = pe.page_id
      JOIN event_identifier AS ei ON e.event_type = ei.event_type
    WHERE
      visit_id in (
        SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) 
      AND product_id > 0
      AND event_name = 'Add to Cart'
    GROUP BY 1, 2) sub1
Order By 2 Desc
Limit 3
```
| page_name | number_of_purchases |
| --------- | ------------------- |
| Lobster   | 754                 |
| Oyster    | 726                 |
| Crab      | 719                 | 
***
## 3. Product Funnel Analysis
### Using a single SQL query - create a new output table which has the following details:
- How many times was each product viewed?
- How many times was each product added to cart?
- How many times was each product added to a cart but not purchased (abandoned)?
- How many times was each product added to a cart but not purchased (abandoned)?
```
-- create table which further aggregates the data for each product.
Select page_name as product,
Sum(
  Case 
	  When event_type = 1 Then 1 End)as views,
Sum(
  Case 
	  When event_type = 2 then 1 end)as added_to_cart,
Sum(Case 
    When event_type = 2 and 
    visit_id In ( SELECT
          distinct visit_id
        FROM
          events
        WHERE
          event_type = 3) Then 1 End) as purchases,
Sum(Case 
    	When event_type = 2 And 
    visit_id Not In ( SELECT
          distinct visit_id
        FROM
          events
        WHERE
          event_type = 3) Then 1 End) as abandoned 
INTO Products_aggregations
From page_hierarchy p
Inner Join events e
On e.page_id = p.page_id
Where product_category Is Not Null
Group By page_name;
```
| product        | views | added_to_cart | purchases | abandoned |
| -------------- | ----- | ------------- | --------- | --------- |
| Abalone        | 1525  | 932           | 699       | 233       |
| Oyster         | 1568  | 943           | 726       | 217       |
| Salmon         | 1559  | 938           | 711       | 227       |
| Crab           | 1564  | 949           | 719       | 230       |
| Tuna           | 1515  | 931           | 697       | 234       |
| Lobster        | 1547  | 968           | 754       | 214       |
| Kingfish       | 1559  | 920           | 707       | 213       |
| Russian Caviar | 1563  | 946           | 697       | 249       |
| Black Truffle  | 1469  | 924           | 707       | 217       |
### create table which further aggregates the data for each Category.
```
Select product_category,
Sum(
  Case 
	  When event_type = 1 Then 1 End)as views,
Sum(
  Case 
	  When event_type = 2 Then 1 End)as added_to_cart,
Sum(
  Case 
    When event_type = 2 and 
      visit_id in ( SELECT
          Distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) Then 1 End) as purchases,
Sum(
  case 
    When event_type = 2 and 
      visit_id not in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) Then 1 End) as abandoned 
INTO Category_aggregations
From page_hierarchy p
Inner Join events e
On e.page_id = p.page_id
Where product_category Is Not Null
Group By product_category;
```
| product_category | views | added_to_cart | purchases | abandoned |
| ---------------- | ----- | ------------- | --------- | --------- |
| Luxury           | 3032  | 1870          | 1404      | 466       |
| Shellfish        | 6204  | 3792          | 2898      | 894       |
| Fish             | 4633  | 2789          | 2115      | 674       |
###  Making new table helps me in my queries
```
Select *,rank() Over(Order By views desc)views_rank,
rank() Over(Order By added_to_cart desc)added_to_cart_rank,
rank() Over(Order By purchases desc)purchases_rank,
rank() Over(Order By abandoned desc)abandoned_rank
into ranked
from Products_aggregations;
```
| product        | views | added_to_cart | purchases | abandoned | views_rank | added_to_cart_rank | purchases_rank | abandoned_rank |
| -------------- | ----- | ------------- | --------- | --------- | ---------- | ------------------ | -------------- | -------------- |
| Oyster         | 1568  | 943           | 726       | 217       | 1          | 4                  | 2              | 6              |
| Crab           | 1564  | 949           | 719       | 230       | 2          | 2                  | 3              | 4              |
| Russian Caviar | 1563  | 946           | 697       | 249       | 3          | 3                  | 8              | 1              |
| Kingfish       | 1559  | 920           | 707       | 213       | 4          | 9                  | 5              | 9              |
| Salmon         | 1559  | 938           | 711       | 227       | 4          | 5                  | 4              | 5              |
| Lobster        | 1547  | 968           | 754       | 214       | 6          | 1                  | 1              | 8              |
| Abalone        | 1525  | 932           | 699       | 233       | 7          | 6                  | 7              | 3              |
| Tuna           | 1515  | 931           | 697       | 234       | 8          | 7                  | 8              | 2              |
| Black Truffle  | 1469  | 924           | 707       | 217       | 9          | 8                  | 5              | 6              |
### Which product had the most views, cart adds and purchases?
```
Select product,views,added_to_cart,purchases
From ranked 
Where added_to_cart_rank = 1
Or views_rank = 1
Or purchases_rank =1 
```
| product | views | added_to_cart | purchases |
| ------- | ----- | ------------- | --------- |
| Oyster  | 1568  | 943           | 726       |
| Lobster | 1547  | 968           | 754       |
### Which product was most likely to be abandoned?
```
Select product,abandoned 
From ranked
Where abandoned_rank = 1;
```
| product        | abandoned |
| -------------- | --------- |
| Russian Caviar | 249       |
### Which product had the highest view to purchase percentage?
```
Select product, Round(100 *purchases :: Numeric / views,2)
From Products_aggregations
Order By 2 desc
Limit 1;
```
| product | round |
| ------- | ----- |
| Lobster | 48.74 |
### What is the average conversion rate from view to cart add?
```
Select Round(avg(100 *added_to_cart :: Numeric / views),2) average_add_to_cart_percentage
From Products_aggregations;
```
| average_add_to_cart_percentage |
| ------------------------------ |
| 60.95                          |
### What is the average conversion rate from cart add to purchase?
```
Select Round(avg(100 *purchases :: Numeric / added_to_cart),2) average_Purchase_percentage
From Products_aggregations
```
| average_purchase_percentage |
| --------------------------- |
| 75.93                       |
## 4.Campaigns Analysis
Generate a table that has 1 single row for every unique visit_id record and has the following columns:
- `user_id`
- `visit_id`
- `visit_start_time` the earliest `event_time` for each visit
- `page_views`: count of page views for each visit
- `cart_adds`: count of product cart add events for each visit
- `purchase`: 1/0 flag if a purchase event exists for each visit
- `campaign_name`: map the visit to a campaign if the `visit_start_time` falls between the `start_date` and `end_date`
- `impression`: count of ad impressions for each visit
- `click`: count of ad clicks for each visit
- (Optional column) `cart_products`: a comma separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the `sequence_number`)
```
Select u.user_id,e.visit_id,
  Min(e.event_time) as visit_start_time,
  Sum(Case When e.event_type = 1 Then 1 End) as page_views,
  Sum(Case When e.event_type = 2 Then 1 Else 0 End) as cart_adds,
  Sum(Case When e.event_type = 3 Then 1 Else 0 End) as purchases,
  c.campaign_name,
  Sum(Case When e.event_type = 4 Then 1 Else 0 End) as impression,
  Sum(Case When e.event_type = 5 then 1 Else 0 End) as click,
  STRING_AGG(CASE WHEN p.product_id IS NOT NULL AND e.event_type = 2 THEN p.page_name ELSE NULL END, 
      ', ' ORDER BY e.sequence_number) AS cart_products
From events e 
Inner join users u
On u.cookie_id = e.cookie_id
LEFT JOIN campaign_identifier AS c
ON e.event_time BETWEEN c.start_date AND c.end_date
LEFT JOIN page_hierarchy AS p
  ON e.page_id = p.page_id
Group By 1,2,campaign_name
Order By 1
```
| user_id | visit_id | visit_start_time         | page_views | cart_adds | purchases | campaign_name                     | impression | click | cart_products                                                  |
| ------- | -------- | ------------------------ | ---------- | --------- | --------- | --------------------------------- | ---------- | ----- | -------------------------------------------------------------- |
| 1       | 02a5d5   | 2020-02-26T16:57:26.260Z | 4          | 0         | 0         | Half Off - Treat Your Shellf(ish) | 0          | 0     |                                                                |
| 1       | 0826dc   | 2020-02-26T05:58:37.918Z | 1          | 0         | 0         | Half Off - Treat Your Shellf(ish) | 0          | 0     |                                                                |
| 1       | 0fc437   | 2020-02-04T17:49:49.602Z | 10         | 6         | 1         | Half Off - Treat Your Shellf(ish) | 1          | 1     | Tuna, Russian Caviar, Black Truffle, Abalone, Crab, Oyster     |
| 1       | 30b94d   | 2020-03-15T13:12:54.023Z | 9          | 7         | 1         | Half Off - Treat Your Shellf(ish) | 1          | 1     | Salmon, Kingfish, Tuna, Russian Caviar, Abalone, Lobster, Crab |
| 1       | 41355d   | 2020-03-25T00:11:17.860Z | 6          | 1         | 0         | Half Off - Treat Your Shellf(ish) | 0          | 0     | Lobster                                                        |