SET search_path = balanced_tree;

--Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.
Select product_id, price,
Concat(p1.level_text,' ',p2.level_text,' - ',p3.level_text)
as product_name,
p3.id as category_id,
p2.id as segment_id,
p1.id as style_id,
p3.level_text as category,
p2.level_text as segment,
p1.level_text as style
From product_prices pp
Join product_hierarchy p1 On pp.id = p1.id
Join product_hierarchy p2 On p1.parent_id = p2.id
Join product_hierarchy p3 On p2.parent_id = p3.id

