-- What was the first item from the menu purchased by each customer?
SELECT
  	distinct s.customer_id,
    m.product_name,
    order_date
FROM dannys_diner.menu m
inner join dannys_diner.sales s
on s.product_id = m.product_id
order by order_date
limit 3;




-- What is the most purchased item on the menu and how many times was it purchased by all customers?
select	m.product_name, count(s.product_id) as counts 
from dannys_diner.sales s
inner join dannys_diner.menu m
on s.product_id = m.product_id
group by m.product_name
limit 1 

---- What is the most purchased item on the menu and how many times was it purchased by all customers?
select s.customer_id,product_name as maximum_product,count(s.product_id)
	FROM dannys_diner.menu m 
	inner join dannys_diner.sales s
	on s.product_id = m.product_id 
    group by s.customer_id,product_name
    having m.product_name = (SELECT product_name
      FROM dannys_diner.menu m 
      inner join dannys_diner.sales s
      on s.product_id = m.product_id
      group by product_name
      having count(s.product_id) = (SELECT max(counts) from 
      (SELECT product_name, count(s.product_id) counts
          FROM dannys_diner.menu m 
          inner join dannys_diner.sales s
          on s.product_id = m.product_id
          group by product_name) as sub));