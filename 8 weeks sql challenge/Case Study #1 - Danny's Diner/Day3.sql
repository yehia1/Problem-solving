SET
  search_path = dannys_diner;

--Which item was the most popular for each customer?
Select customer_id,product_name,
	products_counts
	FROM(
SELECT s.customer_id,
	   m.product_name,
       count(s.product_id) as products_counts,
       rank() over (
         Partition by customer_id
         order by count(s.product_id) desc) as rank
    FROM menu m 
	inner join sales s
	on s.product_id = m.product_id
    group by s.customer_id,m.product_name
    order by products_counts desc) as sub
    where rank = 1
    order by customer_id;
    
--Which item was purchased first by the customer after they became a member?
select customer_id,join_date,order_date,product_name
FROM(
select s.customer_id,s.product_id,product_name,
  join_date,order_date,
rank() over(partition by s.customer_id
            order by order_date asc) as rank
from members b
inner join sales s
on s.customer_id = b.customer_id
inner join menu m 
on m.product_id = s.product_id
where order_date >= join_date) as sub
where rank = 1

-- Which product had the most views, cart adds and purchases?
with ranked as(
Select *,rank() over(order by views desc)views_rank,
rank() over(order by added_to_cart desc)added_to_cart_rank,
rank() over(order by purchases desc)purchases_rank,
rank() over(order by abandoned desc)abandoned_rank
from Products_aggregations)

Select product,views,added_to_cart,purchases
from ranked 
where added_to_cart_rank = 1
or views_rank = 1
or purchases_rank =1 