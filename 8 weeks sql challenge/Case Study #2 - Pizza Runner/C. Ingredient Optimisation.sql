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


