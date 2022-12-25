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
      		
    

   