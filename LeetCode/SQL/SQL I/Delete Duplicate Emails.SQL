# https://leetcode.com/problems/delete-duplicate-emails/description/?envType=study-plan&id=sql-i

Create table If Not Exists Person (Id int, Email varchar(255))
Truncate table Person
insert into Person (id, email) values ('1', 'john@example.com')
insert into Person (id, email) values ('2', 'bob@example.com')
insert into Person (id, email) values ('3', 'john@example.com')


# Please write a DELETE statement and DO NOT write a SELECT statement.
# Write your MySQL query statement below
DELETE p1 FROM Person p1,Person p2 
WHERE p1.id > p2.id and p1.email = p2.email;