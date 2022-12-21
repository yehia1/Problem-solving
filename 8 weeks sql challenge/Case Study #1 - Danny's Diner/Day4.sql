SET
  search_path = dannys_diner;

--Which item was purchased just before the customer became a member?
SELECT customer_id,product_name,join_date,order_date
FROM(
select s.customer_id,s.product_id,product_name,
  join_date,order_date,
rank() over(partition by s.customer_id
            order by order_date desc) as rank
from members b
inner join sales s
on s.customer_id = b.customer_id
inner join menu m 
on m.product_id = s.product_id
where order_date < join_date) as sub 
where rank = 1;


-- What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,count(s.product_id)
,sum(price)
FROM sales s
inner join menu m 
on m.product_id = s.product_id
inner join members b 
on s.customer_id = b.customer_id
where order_date < join_date
group by s.customer_id