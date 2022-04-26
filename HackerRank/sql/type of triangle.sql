/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.

*/

select case
    when (A+B) <= C OR (A+C) <= B OR (C+B) <= A then 'Not A Triangle'
    when (A = B and A = C) then 'Equilateral'
    when (A = B OR A = C OR C = B) then 'Isosceles'
    else 'Scalene'
    end 
from Triangles
