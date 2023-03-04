set search_path = clique_bait;

--Generate a table that has 1 single row for every unique visit_id record and has the following columns:
Select u.user_id,e.visit_id,
  Min(e.event_time) as visit_start_time,
  Sum(Case When e.event_type = 1 Then 1 End) as page_views,
  Sum(Case When e.event_type = 2 Then 1 Else 0 End) as cart_adds,
  Sum(Case When e.event_type = 3 Then 1 Else 0 End) as purchases,
  c.campaign_name,
  Sum(Case When e.event_type = 4 Then 1 Else 0 End) as impression,
  Sum(Case When e.event_type = 5 then 1 Else 0 End) as click,
  STRING_AGG(CASE WHEN p.product_id IS NOT NULL AND e.event_type = 2 THEN p.page_name ELSE NULL END, 
      ', ' ORDER BY e.sequence_number) AS cart_products
From events e 
Inner join users u
On u.cookie_id = e.cookie_id
LEFT JOIN campaign_identifier AS c
ON e.event_time BETWEEN c.start_date AND c.end_date
LEFT JOIN age_hierarchy AS p
  ON e.page_id = p.page_id
Group By 1,2,campaign_name
Order By 1