# https://leetcode.com/problems/customers-who-never-order/description/?envType=study-plan&id=sql-i

Create table If Not Exists Customers (id int, name varchar(255))
Create table If Not Exists Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')

# Write your MySQL query statement below
Select name as Customers
From customers c
left join Orders o
on o.customerID = c.id
Where CustomerID is Null;