Set search_path = clique_bait;

-- create table which further aggregates the data for each product.
Select page_name as product,
sum(case 
	when event_type = 1 then 1 end)as views,
sum(case 
	when event_type = 2 then 1 end)as added_to_cart,
sum(case 
    	when event_type = 2 and 
    visit_id in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) then 1 end) as purchases,
sum(case 
    	when event_type = 2 and 
    visit_id not in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) then 1 end) as abandoned 
INTO Products_aggregations
from page_hierarchy p
inner join events e
on e.page_id = p.page_id
where product_category is not null
group by page_name;


-- create table which further aggregates the data for each Category.
Select product_category,
sum(case 
	when event_type = 1 then 1 end)as views,
sum(case 
	when event_type = 2 then 1 end)as added_to_cart,
sum(case 
    	when event_type = 2 and 
    visit_id in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) then 1 end) as purchases,
sum(case 
    	when event_type = 2 and 
    visit_id not in ( SELECT
          distinct visit_id
        FROM
          events AS ee
        WHERE
          event_type = 3) then 1 end) as abandoned 
INTO Category_aggregations
from page_hierarchy p
inner join events e
on e.page_id = p.page_id
where product_category is not null
group by product_category;

-- making new table helps me in my queries
Select *,rank() over(order by views desc)views_rank,
rank() over(order by added_to_cart desc)added_to_cart_rank,
rank() over(order by purchases desc)purchases_rank,
rank() over(order by abandoned desc)abandoned_rank
into ranked
from Products_aggregations;

--Which product was most likely to be abandoned?
Select product,abandoned 
from ranked
where abandoned_rank = 1;

-- Which product had the most views, cart adds and purchases?
Select product,views,added_to_cart,purchases
from ranked 
where added_to_cart_rank = 1
or views_rank = 1
or purchases_rank =1 

--Which product had the highest view to purchase percentage?
