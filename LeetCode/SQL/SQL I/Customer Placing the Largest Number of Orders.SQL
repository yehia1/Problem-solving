-- https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/description/?envType=study-plan&id=sql-i

Create table If Not Exists orders (order_number int, customer_number int)
Truncate table orders
insert into orders (order_number, customer_number) values ('1', '1')
insert into orders (order_number, customer_number) values ('2', '2')
insert into orders (order_number, customer_number) values ('3', '3')
insert into orders (order_number, customer_number) values ('4', '3')

-- Write your MySQL query statement below
With customer_number_count as (
    Select customer_number, count(customer_number) as counts
    From Orders 
    Group By customer_number
)

Select customer_number
From customer_number_count
Where counts = (Select max(counts) From customer_number_count);