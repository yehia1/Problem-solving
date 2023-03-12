set search_path = balanced_tree;

--What are the top 3 products by total revenue before discount?
Select distinct product_name,Sum(s.price * qty) as revenue 
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By product_name
Order By 2 Desc
Limit 3;

--What is the total quantity, revenue and discount for each segment?
Select segment_name,Sum(qty) quantity
		,Sum(s.price * qty *(s.price * (discount :: Numeric/100)))revenue,
        Sum(s.price * (discount :: Numeric/100))discounts
From sales s
Inner join product_details pd
On pd.product_id = s.prod_id
Group by segment_name;

--What is the top selling product for each segment?
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

--What is the total quantity, revenue and discount for each category?
Select category_name ,Count(prod_id) as total_quantity,
	Round(Sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
    Sum(qty * s.price * (discount :: Numeric/100)) as discount
From sales s
Inner Join product_details pd
On pd.product_id = s.prod_id
Group By category_name;

-- What is the top selling product for each category?
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

--What is the percentage split of revenue by product for each segment?
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
    
-- What is the percentage split of revenue by segment for each category?
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

-- What is the percentage split of total revenue by category?
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


--What is the total transaction “penetration” for each product? 
--(hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
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

--What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
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


            