set search_path = pizza_runner;

-- What are the standard ingredients for each pizza
Select pizza_name,
	string_agg(topping_name,',')
From pizza_toppings,pizza_names n
Inner Join pizza_recipes r
On r.pizza_id = n.pizza_id
Where topping_id In
(Select UNNEST(String_to_array(toppings,',') :: int[])
From pizza_recipes)
Group By pizza_name

-- What was the most common exclusion
With number_of_exclusions as (
Select t.topping_name,
	Count(t.topping_name) as count_of_exclusions 
From
pizza_toppings t,pizza_recipes r
Inner Join pizza_names n 
On n.pizza_id = r.pizza_id
Inner Join cleaned_customer c
On c.pizza_id = r.pizza_id
Where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(exclusions, ',') ::  int [])
      	)
Group By t.topping_name)

Select topping_name,count_of_exclusions
From number_of_exclusions
Where count_of_exclusions = (Select max(count_of_exclusions) From number_of_exclusions)

-- What was the most commonly added extra?
With number_of_extras as (
Select t.topping_name,
	Count(t.topping_name) as count_of_extras 
From
pizza_toppings t,pizza_recipes r
Inner Join pizza_names n 
On n.pizza_id = r.pizza_id
Inner Join cleaned_customer c
On c.pizza_id = r.pizza_id
Where t.topping_id IN
    (Select 
      	UNNEST(STRING_TO_ARRAY(extras, ',') ::  int [])
      	)
Group By t.topping_name)

Select topping_name,count_of_extras
From number_of_extras
Where count_of_extras = (Select max(count_of_extras) From number_of_extras)

-- Generate an order item for each record in the customers_orders table in the format of one of the following
With pizza_topping_cte as(
Select order_id,pizza_name,
    Case
    When exclusions Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(exclusions, ','):: int [])
    	)
    Then topping_name
    End as exclusions,
    Case
    When extras Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
    	)
    Then topping_name
    End as extras
From pizza_toppings as t,
cleaned_customer as c
JOIN pizza_names as n 
ON c.pizza_id = n.pizza_id
GROUP BY c.order_id,pizza_name,
exclusions,extras,topping_id,topping_name)

Select order_id,
	Concat(pizza_name,' ',
	Case 
	When Count(extras) > 0 Then '- Extra '
	Else '' End,
    String_agg(extras,', '),' ',
    Case
	When Count(exclusions) > 0 Then '- Exclude '
	Else '' End,
	String_agg(exclusions,', ')) AS Pizza_information
From pizza_topping_cte
Group By order_id,pizza_name

--Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- This solution is without extras and exclusions.
With toppings_counts_cte as(       
Select order_id,pizza_name,topping_name,
	Count(topping_name) as counts
From pizza_toppings t,cleaned_customer c 
Inner Join pizza_recipes r
On c.pizza_id = r.pizza_id
Inner Join pizza_names n
On c.pizza_id = n.pizza_id
Where topping_id in (
   Select 
      UNNEST(string_to_array(r.toppings,',') :: int[])
      )
Group By order_id,pizza_name,topping_name)

Select order_id,
     		Concat(pizza_name,': ',string_agg(Case
      		When counts > 1 
      		Then '2x' || topping_name 
      		Else topping_name End,','))
From toppings_counts_cte
Group By order_id,pizza_name 

-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
With pizza_ingredints as(
Select order_id,
    Case
    When exclusions Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(exclusions, ',') :: int [])
    	)
    Then topping_name
    End As exclusions,
    Case
    When extras Is Not null And t.topping_id IN
    	(Select 
    	UNNEST(STRING_TO_ARRAY(extras, ',') :: int [])
    	)
    Then topping_name
    End As extras,
    Case
		When topping_id In
    	(Select 
    	UNNEST(STRING_TO_ARRAY(toppings, ',') :: int [])
    	)
        Then topping_name 
        Else null End As toppings
From pizza_toppings as t,
cleaned_customer as c
JOIN pizza_names as n 
ON c.pizza_id = n.pizza_id
Join pizza_recipes r 
On r.pizza_id = c.pizza_id
Order By order_id)

Select order_id,(Count(extras) + Count(toppings) - Count(exclusions) 
 ) as toppings_count
From pizza_ingredints
Group By order_id
Order By toppings_count desc
           

