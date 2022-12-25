SET search_path = pizza_runner;

-- What are the standard ingredients for each pizza
select n.pizza_name,
	string_agg(t.topping_name,',') as toppings
   	From
    pizza_toppings t,pizza_recipes r
    inner join pizza_names n 
    on n.pizza_id = r.pizza_id
    where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(r.toppings, ',' ) :: int [])
      	)
    group by pizza_name;
 
-- What was the most commonly added extra
select t.topping_name as number_of_extras,
	count(t.topping_name) 
   	From
    pizza_toppings t,pizza_recipes r
    inner join pizza_names n 
    on n.pizza_id = r.pizza_id
    inner join cleaned_customer c
    on c.pizza_id = r.pizza_id
    where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
      	)
    group by t.topping_name
    order by count(t.topping_name) desc 
    limit 1;

-- What was the most common exclusion
select t.topping_name as number_of_extras,
	count(t.topping_name) 
   	From
    pizza_toppings t,pizza_recipes r
    inner join pizza_names n 
    on n.pizza_id = r.pizza_id
    inner join cleaned_customer c
    on c.pizza_id = r.pizza_id
    where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(exclusions, ',') ::  int [])
      	)
    group by t.topping_name
    order by count(t.topping_name) desc 
    limit 1; 
    
-- Generate an order item for each record in the customers_orders table in the format of one of the following
Select order_id,
	Concat(pizza_name,' ',
	case 
	when count(extras)  0 then 'Extra - '
	Else '' End,
	String_agg(extras,','),' ',
	case
	when count(exclusions)  0 then 'Exclude - '
	Else '' End,
	String_agg(exclusions,',')
	) as pizza_with_extras_and_exclusions from 
      (Select order_id,pizza_name,
    		case
    		when exclusions is not null and t.topping_id IN
    		(Select 
    		UNNEST(STRING_TO_ARRAY(exclusions, ','):: int [])
    		)
    		then topping_name
    		end as exclusions,
    		case
    		when extras is not null and t.topping_id IN
    		(Select 
    		UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
    		)
    		then topping_name
    		end as extras
      from pizza_toppings as t,
      cleaned_customer as c
      JOIN pizza_names as n 
      ON c.pizza_id = n.pizza_id
      GROUP BY c.order_id,pizza_name,
      exclusions,extras,topping_id,topping_name
      ) as sub
  group by order_id,pizza_name
      		
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
Select order_id,
           concat(pizza_name,': ',string_agg(case
           	when counts > 1 
      		then '2x' || topping_name 
      		else topping_name end,',')) as toppings FROM
(Select order_id,pizza_name,topping_name,count(topping_name) as counts
	from pizza_toppings t,cleaned_customer c 
    inner join pizza_recipes r
    on c.pizza_id = r.pizza_id
    inner join pizza_names n
    on c.pizza_id = n.pizza_id
    where topping_id in (
      Select 
      	UNNEST(string_to_array(r.toppings,',') :: int[])
      )
      group by order_id,pizza_name,topping_name
    order by order_id) as sub1
    Group by order_id,pizza_name

-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
Select toppings,(count(extras) + count(toppings) - count(exclusions) 
 )) as toppings_count
from
(Select order_id,
    		case
    		when exclusions is not null and t.topping_id IN
    		(Select 
    		UNNEST(STRING_TO_ARRAY(exclusions, ',') :: int [])
    		)
    		then topping_name
    		end as exclusions,
    		case
    		when extras is not null and t.topping_id IN
    		(Select 
    		UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
    		)
    		then topping_name
    		end as extras,
         case
				when topping_id in
    	(select unnest(string_to_array(toppings,','):: int[]))
        then topping_name 
        else null end as toppings
      from pizza_toppings as t,
      cleaned_customer as c
      JOIN pizza_names as n 
      ON c.pizza_id = n.pizza_id
      join pizza_recipes r 
      on r.pizza_id = c.pizza_id
      order by order_id) as sub
where toppings is not null
GROUP BY toppings
order by 2 desc

   