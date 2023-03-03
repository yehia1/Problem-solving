-- https://leetcode.com/problems/rising-temperature/description/

Create table If Not Exists Weather (id int, recordDate date, temperature int)
Truncate table Weather
insert into Weather (id, recordDate, temperature) values ('1', '2015-01-01', '10')
insert into Weather (id, recordDate, temperature) values ('2', '2015-01-02', '25')
insert into Weather (id, recordDate, temperature) values ('3', '2015-01-03', '20')
insert into Weather (id, recordDate, temperature) values ('4', '2015-01-04', '30')

# Write your MySQL query statement below
Select w1.id
From Weather w1
Join Weather w2
On w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
Where w2.temperature < w1.temperature;