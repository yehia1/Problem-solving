/*
P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):

* * * * * 
* * * * 
* * * 
* * 
*
Write a query to print the pattern P(20).
*/
declare @i int = 0

while( @i< 20 )
BEGIN 
 PRINT REPLICATE('* ',(20 - @i))
 set @i = @i +1
end
