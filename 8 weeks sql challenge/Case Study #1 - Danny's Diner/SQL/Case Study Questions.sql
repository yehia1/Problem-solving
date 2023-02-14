set search_path = dannys_diner;

--1. What is the total amount each customer spent at the restaurant?
Select customer_id,sum(m.price)
From menu m
Inner Join sales s
On s.product_id = m.product_id
Group by customer_id
Order by customer_id;

--2. How many days has each customer visited the restaurant?
Select customer_id, count(distinct order_date)
From sales
Group by customer_id
Order by customer_id;

--3. What was the first item from the menu purchased by each customer?
SELECT
  	distinct s.customer_id,
    m.product_name,
    order_date
FROM dannys_diner.menu m
inner join dannys_diner.sales s
on s.product_id = m.product_id
order by order_date
limit 3;

-- or 
Select customer_id  , product_name
from(
Select customer_id,product_name,order_date,
ROW_NUMBER ( ) over(
  partition by customer_id order by order_date) rank  
From sales s
Inner Join menu m
on s.product_id = m.product_id) sub1
where rank = 1;

--4.1 What is the most purchased item on the menu?
Select	m.product_name, count(s.product_id) as counts 
From dannys_diner.sales s
Inner Join dannys_diner.menu m
On s.product_id = m.product_id
Group by m.product_name
Limit 1;


--4.2 What is the most purchased item on the menu and how many times was it purchased by all customers?
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

-- or
with max_product as(
Select product_name,count(s.product_id) as produts_count
From sales s
Inner Join menu m 
On s.product_id = m.product_id
Group by product_name),

max_product_name as(
Select product_name
from max_product
where produts_count = (Select max(produts_count) from max_product))

Select customer_id,count(s.product_id)
From sales s
Inner Join menu m 
On s.product_id = m.product_id
Where m.product_name = (Select product_name from max_product_name)
Group by customer_id
Order by customer_id;

--5. Which item was the most popular for each customer?
With ranked_products as(
Select customer_id,product_name,count(s.product_id) products_counts,
rank() over( partition by customer_id 
            order by count(s.product_id) desc)
From sales s
Inner Join menu m 
On s.product_id = m.product_id
Group by customer_id,product_name)

Select customer_id,product_name,products_counts
From ranked_products
Where rank = 1;

-- or
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

--6. Which item was purchased first by the customer after they became a member?
with members_orders as (
Select s.customer_id,product_name,
row_number() over(
  partition by s.customer_id
  order by order_date) as rank
From sales s
Inner Join menu u
On s.product_id = u.product_id
Inner Join members m
On s.customer_id = m.customer_id
Where order_date > join_date)

Select customer_id,product_name
From members_orders
Where rank = 1

--7. Which item was purchased just before the customer became a member?
with members_orders as (
Select s.customer_id,product_name,order_date,join_date,
row_number() over(
  partition by s.customer_id
  order by order_date desc) as rank
From sales s
Inner Join menu u
On s.product_id = u.product_id
Inner Join members m
On s.customer_id = m.customer_id
Where order_date < join_date)

Select customer_id,product_name,order_date,join_date
From members_orders
Where rank = 1;

--8. What is the total items and amount spent for each member before they became a member?
Select s.customer_id,count(s.product_id), sum(price)
From sales s
Inner Join menu u
On s.product_id = u.product_id
Inner join members m 
On s.customer_id = m.customer_id
Where order_date < join_date
Group by s.customer_id

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
Select customer_id,sum(price),
		sum(case 
      		when product_name = 'sushi' then price * 20
      		else price * 10
      		end)
      	as points
From sales s
Inner Join menu m
On s.product_id = m.product_id
Group by customer_id

--10 In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
-- not just sushi - how many points do customer A and B have at the end of January?
Select s.customer_id,sum(price) price_spent,
		sum(case 
            when order_date >= join_date then price * 20
      		when product_name = 'sushi' then price * 20
      		else price * 10
      		end)
      	as points
From sales s
Inner Join menu u
On s.product_id = u.product_id
Inner Join members m
On m.customer_id = s.customer_id
Where extract(month from order_date) < 2
Group by s.customer_id