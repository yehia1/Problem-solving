# https://leetcode.com/problems/calculate-special-bonus/description/?envType=study-plan&id=sql-i

Create table If Not Exists Employees (employee_id int, name varchar(30), salary int)
Truncate table Employees
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000')
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800')
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400')
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100')
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700')

# Write your MySQL query statement below
Select employee_id ,
    case 
        When employee_id % 2 != 0 and left(name,1) != 'M'
        Then salary
        Else 0
    End as Bonus
From Employees
order by employee_id;