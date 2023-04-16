-- https://datalemur.com/questions/supercloud-customer

WITH containers_user as (
SELECT customer_id FROM
customer_contracts cc
JOIN products p 
ON cc.product_id = p.product_id
WHERE product_category = 'Containers'),

compu_container as(
SELECT customer_id FROM
customer_contracts cc
JOIN products p 
ON cc.product_id = p.product_id
WHERE product_category = 'Compute'
AND customer_id in (SELECT customer_id FROM containers_user))

SELECT customer_id FROM
customer_contracts cc
JOIN products p 
ON cc.product_id = p.product_id
WHERE product_category = 'Analytics'
AND customer_id in (SELECT customer_id FROM compu_container)

