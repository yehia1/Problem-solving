--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
Select concat(sum(price), '$') as Total_money_earned from
(Select c.order_id,
	case 
    	when pizza_id = 1 then 12
        when pizza_id = 2 then 10
        end as price
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
	where distance is not null) as sub1;
    
    
-- What if there was an additional $1 charge for any pizza extras?
with extras as(
  	SELECT
	count(extras) as e from
 	(Select
	Unnest(string_to_array(extras,',')) as extras
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
    where distance is not null)as sub2),
profit as(
  	Select sum(price) as Total_money_earned from
(Select c.order_id,
	case 
    	when pizza_id = 1 then 12
        when pizza_id = 2 then 10
        end as price
    from cleaned_customer c
    inner join cleaned_runner r
    on c.order_id = r.order_id
	where distance is not null) as sub1)

select 
    concat(Total_money_earned + e, '$') Total_money_earned from
  	profit, extras


           

