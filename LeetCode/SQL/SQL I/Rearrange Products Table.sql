# https://leetcode.com/problems/rearrange-products-table/description/?envType=study-plan&id=sql-i

Create table If Not Exists Products (product_id int, store1 int, store2 int, store3 int)
Truncate table Products
insert into Products (product_id, store1, store2, store3) values ('0', '95', '100', '105')
insert into Products (product_id, store1, store2, store3) values ('1', '70', 'None', '80')

# Write your MySQL query statement below
Select product_id,'store1' store,store1 price
From Products Where store1 is not null
Union  
Select product_id,'store2' store,store2 price
From Products Where store2 is not null
Union 
Select product_id,'store3' store,store3 price
From Products Where store3 is not null
order by product_id;