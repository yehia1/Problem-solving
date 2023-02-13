set 
	search_path = dannys_diner;
    
-- Bonus 1 
Select s.customer_id,order_date,product_name,price,
	Case 
    	When join_date > order_date Then 'N' 
        Else 'Y'
        End as member 
From sales s
Inner Join menu u
On u.product_id = s.product_id
Inner Join members m
On m.customer_id = s.customer_id
Order by customer_id,order_date;
 
--Bonus 2 
with members_flag as(
Select s.customer_id,order_date,product_name,price,
	Case 
    	When join_date > order_date Then 'N' 
        Else 'Y'
        End as member 
From sales s
Inner Join menu u
On u.product_id = s.product_id
Inner Join members m
On m.customer_id = s.customer_id
Order by customer_id,order_date)

Select *,
	Case When member = 'Y'
    	Then rank() Over(Partition By customer_id,member
                        Order By order_date)
        Else Null
        End as ranking
From members_flag

                    
                                               