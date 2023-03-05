Set search_path = clique_bait;

-- create table which further aggregates the data for each product.
Select page_name as product,
Sum(
  Case 
	  When event_type = 1 Then 1 End)as views,
Sum(
  Case 
	  When event_type = 2 then 1 end)as added_to_cart,
Sum(Case 
    When event_type = 2 and 
    visit_id In ( SELECT
          distinct visit_id
        FROM
          events
        WHERE
          event_type = 3) Then 1 End) as purchases,
Sum(Case 
    	When event_type = 2 And 
    visit_id Not In ( SELECT
          distinct visit_id
        FROM
          events
        WHERE
          event_type = 3) Then 1 End) as abandoned 
INTO Products_aggregations
From page_hierarchy p
Inner Join events e
On e.page_id = p.page_id
Where product_category Is Not Null
Group By page_name;


-- create table which further aggregates the data for each Category.
Select product_category,
Sum(
  Case 
	  When event_type = 1 Then 1 End)as views,
Sum(
  Case 
	  When event_type = 2 Then 1 End)as added_to_cart,
Sum(
  Case 
    When event_type = 2 and 
      visit_id in ( SELECT
          Distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) Then 1 End) as purchases,
Sum(
  case 
    When event_type = 2 and 
      visit_id not in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) Then 1 End) as abandoned 
INTO Category_aggregations
From page_hierarchy p
Inner Join events e
On e.page_id = p.page_id
Where product_category Is Not Null
Group By product_category;

-- making new table helps me in my queries
Select *,rank() Over(Order By views desc)views_rank,
rank() Over(Order By added_to_cart desc)added_to_cart_rank,
rank() Over(Order By purchases desc)purchases_rank,
rank() Over(Order By abandoned desc)abandoned_rank
into ranked
from Products_aggregations;

--Which product was most likely to be abandoned?
Select product,abandoned 
From ranked
Where abandoned_rank = 1;

-- Which product had the most views, cart adds and purchases?
Select product,views,added_to_cart,purchases
From ranked 
Where added_to_cart_rank = 1
Or views_rank = 1
Or purchases_rank =1 

--Which product had the highest view to purchase percentage?
Select product, Round(100 *purchases :: Numeric / views,2)
From Products_aggregations
Order By 2 desc
Limit 1;

--What is the average conversion rate from view to cart add?
Select Round(avg(100 *added_to_cart :: Numeric / views),2) average_add_to_cart_percentage
From Products_aggregations;

--What is the average conversion rate from cart add to purchase?
Select Round(avg(100 *purchases :: Numeric / added_to_cart),2) average_Purchase_percentage
From Products_aggregations

