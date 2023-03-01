# https://leetcode.com/problems/employees-with-missing-information/description/?envType=study-plan&id=sql-i

Create table If Not Exists Employees (employee_id int, name varchar(30))
Create table If Not Exists Salaries (employee_id int, salary int)
Truncate table Employees
insert into Employees (employee_id, name) values ('2', 'Crew')
insert into Employees (employee_id, name) values ('4', 'Haven')
insert into Employees (employee_id, name) values ('5', 'Kristian')
Truncate table Salaries
insert into Salaries (employee_id, salary) values ('5', '76071')
insert into Salaries (employee_id, salary) values ('1', '22517')
insert into Salaries (employee_id, salary) values ('4', '63539')

# Write your MySQL query statement below

Select e.employee_id
From Employees e 
Left JOIN Salaries s
On e.employee_id = s.employee_id
Where s.salary = null
Union 
Select s.employee_id
From Employees e 
Right JOIN Salaries s
On e.employee_id = s.employee_id
Where e.name = null
Order By 1;