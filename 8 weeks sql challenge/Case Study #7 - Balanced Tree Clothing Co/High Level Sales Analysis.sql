SET search_path = balanced_tree;

--What was the total quantity sold for all products?
Select Count(prod_id)as total_quantity_sales From sales;

--What is the total generated revenue for all products before discounts?
Select Sum(s.price * s.qty) as tottal_sales
From sales s
Inner Join product_prices pp
On s.prod_id = pp.product_id;

--What was the total discount amount for all products?
Select Round(Sum(((discount ::Numeric/ 100) *price)*qty),2) as total_discount
From sales 