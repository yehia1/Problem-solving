SET search_path = foodie_fi;

--The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

Select customer_id,s.plan_id,plan_name
	,start_date as payment_date,price as amount,
	dense_rank() over(partition by customer_id
                order by s.plan_id) as payment_order
   into Payments
   from subscriptions s
   inner join plans p 
   on p.plan_id = s.plan_id
   where s.plan_id != 0 and s.plan_id !=4
   order by customer_id;


