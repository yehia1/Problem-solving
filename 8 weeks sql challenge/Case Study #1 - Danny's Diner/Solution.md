# 🍜 Case Study #1: Danny's Diner 

## 1. What is the total amount each customer spent at the restaurant?
```
    Select customer_id,sum(m.price)
    From menu m
    Inner Join sales s
    On s.product_id = m.product_id
    Group by customer_id
    Order by customer_id;
```

| customer_id | sum |
| ----------- | --- |
| A           | 76  |
| B           | 74  |
| C           | 36  |

## 2. How many days has each customer visited the restaurant?
```
Select customer_id, count(distinct order_date)
From sales
Group by customer_id
Order by customer_id;
```
| customer_id | numbers_of_visits |
| ----------- | ----------------- |
| A           | 4                 |
| B           | 6                 |
| C           | 2                 |
## 3.What was the first item from the menu purchased by each customer?

```
SELECT
  	distinct s.customer_id,
    m.product_name,
    order_date
FROM dannys_diner.menu m
inner join dannys_diner.sales s
on s.product_id = m.product_id
order by order_date
limit 3;
```
| customer_id | product_name | order_date               |
| ----------- | ------------ | ------------------------ |
| C           | ramen        | 2021-01-01T00:00:00.000Z |
| A           | curry        | 2021-01-01T00:00:00.000Z |
| B           | curry        | 2021-01-01T00:00:00.000Z |

## 4.What is the most purchased item on the menu and how many times was it purchased by all customers?
```
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
```
| customer_id | most_purchased_cout |
| ----------- | ------------------- |
| A           | 3                   |
| B           | 2                   |
| C           | 3                   |

## 5.Which item was the most popular for each customer?
```
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
```
| customer_id | product_name | products_counts |
| ----------- | ------------ | --------------- |
| A           | ramen        | 3               |
| B           | ramen        | 2               |
| B           | curry        | 2               |
| B           | sushi        | 2               |
| C           | ramen        | 3               |
## 6.Which item was purchased first by the customer after they became a member?
```
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
```
| customer_id | product_name |
| ----------- | ------------ |
| A           | ramen        |
| B           | sushi        |
## 7. Which item was purchased just before the customer became a member?
```
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
```
| customer_id | product_name | order_date               | join_date                |
| ----------- | ------------ | ------------------------ | ------------------------ |
| A           | sushi        | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| B           | sushi        | 2021-01-04T00:00:00.000Z | 2021-01-09T00:00:00.000Z |
## 8. What is the total items and amount spent for each member before they became a member?
```
Select s.customer_id,count(s.product_id), sum(price)
From sales s
Inner Join menu u
On s.product_id = u.product_id
Inner join members m 
On s.customer_id = m.customer_id
Where order_date < join_date
Group by s.customer_id
```

| customer_id | count | sum |
| ----------- | ----- | --- |
| B           | 3     | 40  |
| A           | 2     | 25  |
## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```
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
```
| customer_id | price | points |
| ----------- | --- | ------ |
| B           | 74  | 940    |
| C           | 36  | 360    |
| A           | 76  | 860    |
## 10.In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```
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
```
| customer_id | price_spent | points |
| ----------- | ----------- | ------ |
| A           | 76          | 1370   |
| B           | 62          | 940    |

# Bonus
## Join All The Things - Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)
```
Select s.customer_id,order_date,product_name,price,
	Case 
    	When join_date > order_date Then 'N' 
        Else 'Y'
        End as member 
From sales s
Inner Join menu u
On u.product_id = s.product_id
Inner Join members m
On m.customer_id = s.customer_id
Order by customer_id,order_date;
```
| customer_id | order_date               | product_name | price | member |
| ----------- | ------------------------ | ------------ | ----- | ------ |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      |
##  Rank All The Things - Danny also requires further information about the ```ranking``` of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ```ranking``` values for the records when customers are not yet part of the loyalty program.
```
with members_flag as(
Select s.customer_id,order_date,product_name,price,
	Case 
    	When join_date > order_date Then 'N' 
        Else 'Y'
        End as member 
From sales s
Inner Join menu u
On u.product_id = s.product_id
Inner Join members m
On m.customer_id = s.customer_id
Order by customer_id,order_date)

Select *,
	Case When member = 'Y'
    	Then rank() Over(Partition By customer_id,member
                        Order By order_date)
        Else Null
        End as ranking
From members_flag
```
| customer_id | order_date               | product_name | price | member | ranking |
| ----------- | ------------------------ | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N      |         |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y      | 1       |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N      |         |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N      |         |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y      | 3       |
