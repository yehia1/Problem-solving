/*
You are given a table, Projects, containing three columns: Task_ID, Start_Date and End_Date. It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.



If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. If there is more than one project that have the same number of completion days, then order by the start date of the project.
*/
SET sql_mode = '';
select start_date,min(end_date) from (
    select start_date from projects
    where start_date not in (select end_date from projects)) a,
    (select end_date from projects 
    where end_date not in (select start_date from projects)) b
    
where start_date < end_date
group by start_date
ORDER BY DATEDIFF(End_Date, Start_Date), Start_Date