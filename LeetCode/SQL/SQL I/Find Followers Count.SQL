# https://leetcode.com/problems/find-followers-count/description/?envType=study-plan&id=sql-i

Create table If Not Exists Followers(user_id int, follower_id int)
Truncate table Followers
insert into Followers (user_id, follower_id) values ('0', '1')
insert into Followers (user_id, follower_id) values ('1', '0')
insert into Followers (user_id, follower_id) values ('2', '0')
insert into Followers (user_id, follower_id) values ('2', '1')

# Write your MySQL query statement below
Select user_id,count(follower_id)followers_count
From Followers 
Group By user_id
Order By user_id;