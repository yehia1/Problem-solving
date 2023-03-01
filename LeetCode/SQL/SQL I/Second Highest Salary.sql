# https://leetcode.com/problems/second-highest-salary/description/

Create table If Not Exists Employee (id int, salary int)
Truncate table Employee
insert into Employee (id, salary) values ('1', '100')
insert into Employee (id, salary) values ('2', '200')
insert into Employee (id, salary) values ('3', '300')

Select 
    Case 
        when count(id) = 1 Then null
    Else (Select distinct salary From
            (Select distinct id,salary,
                dense_rank() over(order by salary desc) as ranking
            From Employee)sub
            Where sub.ranking = 2)
    End as 'SecondHighestSalary'
From Employee;