set search_path = clique_bait;

--Generate a table that has 1 single row for every unique visit_id record and has the following columns:
Select u.user_id,e.visit_id,
min(e.event_time) as visit_start_time,
sum(case when e.event_type = 1 then 1 end) as page_views,
sum(case when e.event_type = 2 then 1 else 0 end) as cart_adds,
sum(case when e.event_type = 3 then 1 else 0 end) as purchases,
c.campaign_name,
sum(case when e.event_type = 4 then 1 else 0 end) as impression,
sum(case when e.event_type = 5 then 1 else 0 end) as click,
STRING_AGG(CASE WHEN p.product_id IS NOT NULL AND e.event_type = 2 THEN p.page_name ELSE NULL END, 
    ', ' ORDER BY e.sequence_number) AS cart_products
from events e 
inner join users u
on u.cookie_id = e.cookie_id
LEFT JOIN campaign_identifier AS c
ON e.event_time BETWEEN c.start_date AND c.end_date
LEFT JOIN clique_bait.page_hierarchy AS p
  ON e.page_id = p.page_id
group by 1,2,campaign_name
order by 1