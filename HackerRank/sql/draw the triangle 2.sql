/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* 
* * 
* * * 
* * * * 
* * * * *
Write a query to print the pattern P(20).
*/

declare @i int = 1

while(@i <= 20)
begin
PRINT REPLICATE('* ',@i)
set @i = @i + 1
end