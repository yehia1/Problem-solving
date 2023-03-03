SET search_PATH = clique_bait;

--find number of users
Select Count(distinct user_id) as number_of_users From users

--How many cookies does each user have on average?
Select Round(avg(counts)) as avg_cookies
from
(Select user_id,Count(cookie_id) as counts
from users
Group By 1) sub1


--What is the unique number of visits by all users per month?
Select Extract(Month From event_time) months,
	Count(distinct visit_id) Number_of_events
From events e
Group By 1 

-- What is the number of events for each event type?
Select event_name,Count(e.*)
From events e
Inner Join event_identifier ei
On ei.event_type = e.event_type
Group By event_name;

--What is the percentage of visits which have a purchase event?
Select
	Round(100 * count(visit_id)::Numeric/
    (Select count(visit_id) from events),2) as Purchase_percentage
From events e
Inner Join event_identifier ei
On e.event_type = ei.event_type
Where event_name = 'Purchase' 

-- What is the percentage of visits which view the checkout page but do not have a purchase event?
With Events_counter as(
Select Distinct visit_id,event_name,
LEAD(event_name, 1) OVER(PARTITION BY visit_id ORDER BY event_name) as next_event
FROM events e
Join event_identifier ei 
On e.event_type = ei.event_type
Where e.event_type In (2,3)
Order By 1,2)

Select 
	Round(100 * Count(event_name) :: Numeric/
          (Select count(event_name)FROM Events_counter),2)
          AS No_Purchase_Checkout_Percentage
From Events_counter
Where event_name = 'Add to Cart'
And next_event Is null


--What are the top 3 pages by number of views?
Select page_name ,Count(visit_id) as number_of_views
From events e
Inner Join page_hierarchy p
On e.page_id = p.page_id
Group By page_name
Order By number_of_views desc
Limit 3;

--What is the number of views and cart adds for each product category?
Select product_category,
 Sum(Case When event_type = 1 Then 1 End)as view_numbers,
 Sum(Case When event_type = 2 Then 1 End)as add_to_cart_numbers
From events e
Inner Join Page_Hierarchy p
On e.page_id = p.page_id
Where product_category Is Not null
Group By product_category

--What are the top 3 products by purchases?
SELECT page_name,number_of_purchases
FROM
(SELECT
      page_name,
      event_name,
      COUNT(event_name) AS number_of_purchases
    FROM
      events AS e
      JOIN page_hierarchy AS pe ON e.page_id = pe.page_id
      JOIN event_identifier AS ei ON e.event_type = ei.event_type
    WHERE
      visit_id in (
        SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) 
      AND product_id > 0
      AND event_name = 'Add to Cart'
    GROUP BY 1, 2) sub1
Order By 2 Desc
Limit 3