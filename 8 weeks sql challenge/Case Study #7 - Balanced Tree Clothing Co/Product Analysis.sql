set search_path = balanced_tree;

--What are the top 3 products by total revenue before discount?
Select distinct product_name,sum(s.price * qty) as revenue 
from sales s
inner join product_details pd
on pd.product_id = s.prod_id
group by product_name
order by 2 desc
limit 3;

--What is the total quantity, revenue and discount for each segment?
Select segment_name,sum(qty) quantity
		,sum(s.price * qty *(s.price * (discount :: Numeric/100)))revenue,
        sum(s.price * (discount :: Numeric/100))discounts
from sales s
inner join product_details pd
on pd.product_id = s.prod_id
group by segment_name;

--What is the top selling product for each segment?
with segment_product_revenue as (
Select segment_name,product_name,
	round(sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
	rank() over(partition by segment_name order by round(sum(qty *(s.price - (s.price * (discount :: Numeric/100))))) desc) as rank
from sales s
inner join product_details pd
on pd.product_id = s.prod_id
group by segment_name,product_name)

Select segment_name,product_name,revenue
from segment_product_revenue
where rank = 1

--What is the total quantity, revenue and discount for each category?
Select category_name ,count(prod_id) as total_quantity,
	round(sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
    sum(qty * s.price * (discount :: Numeric/100)) as discount
from sales s
inner join product_details pd
on pd.product_id = s.prod_id
group by category_name;

-- What is the top selling product for each category?
with category_revenue as (
Select category_name,product_name,
	round(sum(qty *(s.price - (s.price * (discount :: Numeric/100)))))revenue,
	rank() over(partition by category_name order by round(sum(qty *(s.price - (s.price * (discount :: Numeric/100))))) desc) as rank
from sales s
inner join product_details pd
on pd.product_id = s.prod_id
group by category_name,product_name)

Select category_name,product_name,revenue 
from category_revenue
where rank = 1



            