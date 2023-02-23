SET search_path = foodie_fi;

-- Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Select customer_id,
		plan_name,
        start_date
from plans p 
inner join subscriptions s
on p.plan_id = s.plan_id
WHERE s.customer_id IN (1,2,11,13,15,16,18,19)
order by customer_id,start_date
