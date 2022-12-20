set 
	search_path = dannys_diner;
    
-- Bonus 1 
SELECT s.customer_id,order_date,
	product_name,price,
    case 
    	when order_date >= join_date and s.customer_id = b.customer_id  then 'Y'
       	else 'N'
    	end as member
    FROM sales s 
    left join members b
    on s.customer_id = b.customer_id
    inner join menu m
    on s.product_id = m.product_id
    order by s.customer_id,order_date asc;
 
--Bonus 2 
Select customer_id,order_date,
		product_name,price,member,
		case 
        	when member = 'Y' Then 
            rank() over(partition by 
                        customer_id,member
                        order by order_date asc)
            else null
            end as ranking
            from (
              	SELECT s.customer_id,order_date,
					product_name,price,
    				case 
    				when order_date >= join_date and s.customer_id 						= b.customer_id  then 'Y'
       				else 'N'
    				end as member
    				FROM sales s 
    				left join members b
    				on s.customer_id = b.customer_id
    				inner join menu m
    				on s.product_id = m.product_id
    				order by s.customer_id,order_date asc)as sub
                    
                                               