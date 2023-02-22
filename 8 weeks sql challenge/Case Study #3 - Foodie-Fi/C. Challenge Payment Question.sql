SET search_path = foodie_fi;

--The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

SET search_path = foodie_fi;

Select customer_id,s.plan_id,plan_name,
	start_date as payment_date,price as amount,
    rank() over(partition by customer_id
               order by s.plan_id) as payment_order
From plans p 
Inner Join subscriptions s
On s.plan_id = p.plan_id
Where s.plan_id != 0 And s.plan_id !=4
And start_date Between '2020-01-01' And '2020-12-31'



