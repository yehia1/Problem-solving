# https://leetcode.com/problems/tree-node/description/

Create table If Not Exists Tree (id int, p_id int)
Truncate table Tree
insert into Tree (id, p_id) values ('1', 'None')
insert into Tree (id, p_id) values ('2', '1')
insert into Tree (id, p_id) values ('3', '1')
insert into Tree (id, p_id) values ('4', '2')
insert into Tree (id, p_id) values ('5', '2')

# Write your MySQL query statement below
Select id,
    Case
        When p_id is null then 'Root'
        When id In (select p_id From Tree) then 'Inner'
        else 'Leaf'
        End as type
From Tree;
