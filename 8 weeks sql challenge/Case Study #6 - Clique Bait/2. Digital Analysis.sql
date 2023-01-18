SET search_PATH = clique_bait;

--find number of users
Select count(*) as number_of_users from usersك

--How many cookies does each user have on average?
Select Round(avg(counts)) as avg_cookies
from
(Select user_id,count(cookie_id) as counts
from users
group by 1) sub1


--What is the unique number of visits by all users per month?
Select extract(month from event_time) months,
	count(distinct visit_id) Number_of_events
    from events e
    group by 1 

--What is the percentage of visits which have a purchase event?
Select
	Round(100 * count(visit_id)::Numeric/
    (select count(visit_id) from events),2) as Purchase_percentage
from events e
inner join event_identifier ei
on e.event_type = ei.event_type
where event_name = 'Purchase' 

-- What is the percentage of visits which view the checkout page but do not have a purchase event?
with Events_counter as(
Select distinct visit_id,event_name,
LEAD(event_name, 1) OVER(PARTITION BY visit_id ORDER BY event_name) as next_event
FROM events e
join event_identifier ei 
on e.event_type = ei.event_type
where e.event_type in (2,3)
order by 1,2)

Select 
	Round(100 * Count(event_name) :: Numeric/
          (Select count(event_name)FROM Events_counter),2)
          AS No_Purchase_Checkout_Percentage
from Events_counter
where event_name = 'Add to Cart'
and next_event is null


--What are the top 3 pages by number of views?
Select page_name ,count(visit_id) as number_of_views
from events e
inner join page_hierarchy p
on e.page_id = p.page_id
group by page_name
order by number_of_views desc
limit 3;

--What is the number of views and cart adds for each product category?
Select product_category,
 sum(case when event_type = 1 then 1 end)as view_numbers,
 sum(case when event_type = 2 then 1 end)as add_to_cart_numbers
from events e
inner join Page_Hierarchy p
on e.page_id = p.page_id
where product_category is not null
group by product_category

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
order by 2 desc
limit 3