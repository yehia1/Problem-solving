# Case Study #7 Balanced Tree Clothing Co
## High Level Sales Analysis
### What was the total quantity sold for all products?
```
Select Count(prod_id)as total_quantity_sales From sales;
```
| total_quantity_sales |
| -------------------- |
| 15095                |
### What is the total generated revenue for all products before discounts?
```
Select Sum(s.price * s.qty) as total_sales
From sales s
Inner Join product_prices pp
On s.prod_id = pp.product_id;
```
| total_sales |
| ------------ |
| 1289453      |
###  What was the total discount amount for all products?
```
Select Round(Sum(((discount ::Numeric/ 100) *price)*qty),2) as total_discount
From sales 
```
| total_discount |
| -------------- |
| 156229.14      |
*** 
## Transaction Analysis
### How many unique transactions were there?
```
Select Count(distinct txn_id) unique_transactions from sales;
```
| unique_transactions |
| ------------------- |
| 2500                |
### What is the average unique products purchased in each transaction?
for the the unique products we use count(prod) divided by the number of transcations.
```
Select Count(prod_id) / Count(distinct txn_id) as average_products_per_transcation from sales;
```
### What are the 25th, 50th and 75th percentile values for the revenue per transaction?
This was a good query to percentile for first time in sql 
```
WITH revenue AS(
    SELECT
      txn_id,
      SUM(qty * price) AS revenue
    FROM
      sales
    GROUP BY
      txn_id
  )
Select
    percentile_cont(0.25) within group (order by revenue) as p_25,
    percentile_cont(0.5) within group (order by revenue) as p_50,
    percentile_cont(0.75) within group (order by revenue) as p_75
From revenue
```
| p_25   | p_50  | p_75 |
| ------ | ----- | ---- |
| 375.75 | 509.5 | 647  |
### What is the average discount value per transaction?
```
With transcation_discount as(
Select Distinct txn_id,
	Sum(discount :: Numeric / 100 * price * qty) discounts
From sales s
Group By txn_id)
    
SELECT Round(Avg(discounts),2) as average_disconts FROM transcation_discount;
```
| average_disconts |
| ---------------- |
| 62.49            |
### What is the percentage split of all transactions for members vs non-members?
```
with members as(
Select Round(100 *Count(member):: Numeric
/(Select Count(txn_id) From sales)) as members_percentage From sales
Where member = 't'),

non_members as(
Select Round(100 *Count(member):: Numeric
/(Select Count(txn_id) From sales)) as non_members_percentage From sales
Where member = 'f')  


select members_percentage,non_members_percentage
from members,non_members;
```
| members_percentage | non_members_percentage |
| ------------------ | ---------------------- |
| 60                 | 40                     |
### What is the average revenue for member transactions and non-member transactions?
```
Select (Select Avg(price * qty)From sales Where member = 't')
avg_members_revenue,
		(Select Avg(price * qty)From sales Where member = 'f' )
avg_non_members_revenue
From sales
Limit 1
```
| avg_members_revenue | avg_non_members_revenue |
| ------------------- | ----------------------- |
| 85.75 | 84.93     |
***
## Product Analysis
### What are the top 3 products by total revenue before discount?
```
Select distinct product_name,Sum(s.price * qty) as revenue 
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By product_name
Order By 2 Desc
Limit 3;
```
| product_name                 | revenue |
| ---------------------------- | ------- |
| Blue Polo Shirt - Mens       | 217683  |
| Grey Fashion Jacket - Womens | 209304  |
| White Tee Shirt - Mens       | 152000  |
### What is the total quantity, revenue and discount for each segment?
```
Select segment_name,Sum(qty) quantity
		,Sum(s.price * qty *(s.price * (discount :: Numeric/100)))revenue,
        Sum(s.price * (discount :: Numeric/100))discounts
From sales s
Inner join product_details pd
On pd.product_id = s.prod_id
Group by segment_name;
```
| segment_name | quantity | revenue                      | discounts                  |
| ------------ | -------- | ---------------------------- | -------------------------- |
| Shirt        | 11265    | 2307766.99 | 16560.31 |
| Jeans        | 11349    | 596235.65  | 8393.08  |
| Jacket       | 11385    | 1770959.74 | 14647.64 |
| Socks        | 11217    | 1101012.560 | 12495.31 |
### What is the top selling product for each segment?
```
With segment_product_revenue as (
Select segment_name,product_name,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
	Rank() over(partition by segment_name order by Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100))))) desc) as rank
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By segment_name,product_name)

Select segment_name,product_name,revenue
From segment_product_revenue
Where rank = 1
```
| segment_name | product_name                  | revenue |
| ------------ | ----------------------------- | ------- |
| Jacket       | Grey Fashion Jacket - Womens  | 183912  |
| Jeans        | Black Straight Jeans - Womens | 106407  |
| Shirt        | Blue Polo Shirt - Mens        | 190864  |
| Socks        | Navy Solid Socks - Mens       | 119862  |
### What is the total quantity, revenue and discount for each category?
```
Select category_name ,Count(prod_id) as total_quantity,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
    Sum(qty * s.price * (discount :: Numeric/100)) as discount
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By category_name;
```
| category_name | total_quantity | revenue | discount                   |
| ------------- | -------------- | ------- | -------------------------- |
| Mens          | 7560           | 627512  | 86607.71 |
| Womens        | 7535           | 505712  | 69621.43 |
### What is the top selling product for each category?
```
With category_revenue as (
Select category_name,product_name,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
	Rank() over(partition by category_name order by Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100))))) desc) as rank
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By category_name,product_name)

Select category_name,product_name,revenue 
From category_revenue
Where rank = 1
```
| category_name | product_name                 | revenue |
| ------------- | ---------------------------- | ------- |
| Mens          | Blue Polo Shirt - Mens       | 190864  |
| Womens        | Grey Fashion Jacket - Womens | 183912  |
### What is the percentage split of revenue by product for each segment?
```
With segment_product_revenue as (
Select segment_name,product_name,
	round(sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By segment_name,product_name)

Select segment_name,product_name,
	Round(100 * revenue :: Numeric / Sum(revenue) Over (Partition By segment_name)) as segment_percentage
From segment_product_revenue
Order By 1 , 3 Desc;
```
| segment_name | product_name                     | segment_percentage |
| ------------ | -------------------------------- | ------------------ |
| Jacket       | Grey Fashion Jacket - Womens     | 57                 |
| Jacket       | Khaki Suit Jacket - Womens       | 24                 |
| Jacket       | Indigo Rain Jacket - Womens      | 19                 |
| Jeans        | Black Straight Jeans - Womens    | 58                 |
| Jeans        | Navy Oversized Jeans - Womens    | 24                 |
| Jeans        | Cream Relaxed Jeans - Womens     | 18                 |
| Shirt        | Blue Polo Shirt - Mens           | 54                 |
| Shirt        | White Tee Shirt - Mens           | 37                 |
| Shirt        | Teal Button Up Shirt - Mens      | 9                  |
| Socks        | Navy Solid Socks - Mens          | 44                 |
| Socks        | Pink Fluro Polkadot Socks - Mens | 36                 |
| Socks        | White Striped Socks - Mens       | 20                 |
### What is the percentage split of revenue by segment for each category?
```
With Category_segment_revenue as (
Select Category_name,segment_name,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By segment_name,Category_name)

Select Category_name,segment_name,
	Round(100 * revenue :: Numeric / Sum(revenue) Over (partition by Category_name)) as category_percentage
From Category_segment_revenue
Order By 1 , 3 Desc; 
```
| category_name | segment_name | category_percentage |
| ------------- | ------------ | ------------------- |
| Mens          | Shirt        | 57                  |
| Mens          | Socks        | 43                  |
| Womens        | Jacket       | 64                  |
| Womens        | Jeans        | 36                  |
### What is the percentage split of total revenue by category?
```
With category_revenue as 
(Select Category_name,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By Category_name)

Select category_name,
	Round(100 * revenue / (Select Sum(revenue) from category_revenue),2)
From category_revenue
```
| category_name | round |
| ------------- | ----- |
| Mens          | 55.37 |
| Womens        | 44.63 |
### What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
```
SELECT
  product_name,
  ROUND(
    (100 * COUNT(product_name) :: numeric / (Select
    Count(distinct txn_id) from sales)),
    2
  ) as percent_of_penetration
From sales s
Inner Join product_details p
On s.prod_id = p.product_id
Group By product_name
Order By 2 Desc;
```
| product_name                     | percent_of_penetration |
| -------------------------------- | ---------------------- |
| Navy Solid Socks - Mens          | 51.24                  |
| Grey Fashion Jacket - Womens     | 51.00                  |
| Navy Oversized Jeans - Womens    | 50.96                  |
| White Tee Shirt - Mens           | 50.72                  |
| Blue Polo Shirt - Mens           | 50.72                  |
| Pink Fluro Polkadot Socks - Mens | 50.32                  |
| Indigo Rain Jacket - Womens      | 50.00                  |
| Khaki Suit Jacket - Womens       | 49.88                  |
| Black Straight Jeans - Womens    | 49.84                  |
| White Striped Socks - Mens       | 49.72                  |
| Cream Relaxed Jeans - Womens     | 49.72                  |
| Teal Button Up Shirt - Mens      | 49.68                  |
### What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
I got this solution by using multiple self join and this query was some how hard one.
```
With products as(
Select product_name ,txn_id
From sales s
Inner join product_details p
On s.prod_id = p.product_id)

Select p1.product_name as product1,
p2.product_name as product2,
p3.product_name as product3,
COUNT(*) AS times_bought_together
From products p1
Join products p2 
On p1.txn_id = p2.txn_id
And p1.product_name != p2.product_name
AND p1.product_name < p2.product_name
Join products p3 
On p1.txn_id = p3.txn_id
And p3.product_name != p2.product_name
And p3.product_name != p2.product_name
AND p1.product_name < p3.product_name
AND p2.product_name < p3.product_name
Group By 1,2,3
Order By 4 desc 
Limit 1
```
| product1                     | product2                    | product3               | times_bought_together |
| ---------------------------- | --------------------------- | ---------------------- | --------------------- |
| Grey Fashion Jacket - Womens | Teal Button Up Shirt - Mens | White Tee Shirt - Mens | 352                  |
***
## Reporting Challenge
{Solution is still under devlopment :) }
## Reporting Challenge
Use a single SQL query to transform the `product_hierarchy` and `product_prices` datasets to the `product_details` table.
```
Select product_id, price,
Concat(p1.level_text,' ',p2.level_text,' - ',p3.level_text)
as product_name,
p3.id as category_id,
p2.id as segment_id,
p1.id as style_id,
p3.level_text as category,
p2.level_text as segment,
p1.level_text as style
From product_prices pp
Join product_hierarchy p1 On pp.id = p1.id
Join product_hierarchy p2 On p1.parent_id = p2.id
Join product_hierarchy p3 On p2.parent_id = p3.id
```
| product_id | price | product_name                     | category_id | segment_id | style_id | category | segment | style               |
| ---------- | ----- | -------------------------------- | ----------- | ---------- | -------- | -------- | ------- | ------------------- |
| c4a632     | 13    | Navy Oversized Jeans - Womens    | 1           | 3          | 7        | Womens   | Jeans   | Navy Oversized      |
| e83aa3     | 32    | Black Straight Jeans - Womens    | 1           | 3          | 8        | Womens   | Jeans   | Black Straight      |
| e31d39     | 10    | Cream Relaxed Jeans - Womens     | 1           | 3          | 9        | Womens   | Jeans   | Cream Relaxed       |
| d5e9a6     | 23    | Khaki Suit Jacket - Womens       | 1           | 4          | 10       | Womens   | Jacket  | Khaki Suit          |
| 72f5d4     | 19    | Indigo Rain Jacket - Womens      | 1           | 4          | 11       | Womens   | Jacket  | Indigo Rain         |
| 9ec847     | 54    | Grey Fashion Jacket - Womens     | 1           | 4          | 12       | Womens   | Jacket  | Grey Fashion        |
| 5d267b     | 40    | White Tee Shirt - Mens           | 2           | 5          | 13       | Mens     | Shirt   | White Tee           |
| c8d436     | 10    | Teal Button Up Shirt - Mens      | 2           | 5          | 14       | Mens     | Shirt   | Teal Button Up      |
| 2a2353     | 57    | Blue Polo Shirt - Mens           | 2           | 5          | 15       | Mens     | Shirt   | Blue Polo           |
| f084eb     | 36    | Navy Solid Socks - Mens          | 2           | 6          | 16       | Mens     | Socks   | Navy Solid          |
| b9a74d     | 17    | White Striped Socks - Mens       | 2           | 6          | 17       | Mens     | Socks   | White Striped       |
| 2feb6b     | 29    | Pink Fluro Polkadot Socks - Mens | 2           | 6          | 18       | Mens     | Socks   | Pink Fluro Polkadot |