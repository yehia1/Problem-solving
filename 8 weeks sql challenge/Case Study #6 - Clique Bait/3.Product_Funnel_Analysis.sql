Set search_path = clique_bait;

-- create table which further aggregates the data for each product.
Select page_name,
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


Select * from Products_aggregations