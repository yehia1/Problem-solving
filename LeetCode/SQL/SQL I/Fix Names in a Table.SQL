# https://leetcode.com/problems/fix-names-in-a-table/description/?envType=study-plan&id=sql-i

Create table If Not Exists Users (user_id int, name varchar(40))
Truncate table Users
insert into Users (user_id, name) values ('1', 'aLice')
insert into Users (user_id, name) values ('2', 'bOB')

# Write your MySQL query statement below
Select user_id,
Concat(Upper(Left(name,1)),Lower(substring(name,2))) as name
From Users
Order By user_id;