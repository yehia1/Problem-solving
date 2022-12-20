SET
  search_path = dannys_diner;

--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,sum(points) from
(SELECT s.customer_id,
m.product_name,m.price,
case when product_name = 'sushi' then price * 20
else 10 *price End as points
FROM sales s 
inner join menu m 
on s.product_id = m.product_id) as sub
group by customer_id
order by customer_id


--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT customer_id,sum(points) FROM
(Select 
 	s.customer_id,
	m.product_name,m.price,	
	case 
    when order_date >= join_date then price * 20
    when product_name = 'sushi' then price * 20
    else price *10 
    End as points 
    from menu m 
    inner join sales s 
    on s.product_id = m.product_id
    inner join members b
    on b.customer_id = s.customer_id) as sub
    group by customer_id