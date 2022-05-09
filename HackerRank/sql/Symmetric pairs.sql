/*
You are given a table, Functions, containing two columns: X and Y.



Two pairs (X1, Y1) and (X2, Y2) are said to be symmetric pairs if X1 = Y2 and X2 = Y1.

Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.
*/

select f1.x,f1.y from functions f1
join functions f2 on f1.x = f2.y and f1.y = f2.x
group by f1.x,f1.y
having f1.x<f1.y or count(f1.x) > 1
order by f1.x