SET search_path = balanced_tree;

--What was the total quantity sold for all products?
Select count(prod_id)as total_quantity_sales from sales;

--What is the total generated revenue for all products before discounts?
Select sum(s.price * s.qty) as tottal_sales
from sales s
inner join product_prices pp
on s.prod_id = pp.product_id;

--What was the total discount amount for all products?
Select Round(sum(((discount ::Numeric/ 100) *price)*qty),2) as total_discount
from sales 