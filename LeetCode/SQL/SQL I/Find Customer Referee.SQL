# https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan&id=sql-i

Create table If Not Exists Customer (id int, name varchar(25), referee_id int)
Truncate table Customer
insert into Customer (id, name, referee_id) values ('1', 'Will', 'None')
insert into Customer (id, name, referee_id) values ('2', 'Jane', 'None')
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2')
insert into Customer (id, name, referee_id) values ('4', 'Bill', 'None')
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1')
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2')

# Write your MySQL query statement below
Select name From customer
Where referee_id != 2 or referee_id is null