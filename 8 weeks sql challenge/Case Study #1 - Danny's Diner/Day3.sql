SET
  search_path = dannys_diner;
    
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
