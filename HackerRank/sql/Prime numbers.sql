/* 
get the prime numbers of 1000 number
*/

declare @i int;
set @i = 2 
declare @var bit;
declare @j int;
DECLARE @result nvarchar(1000) = '';
while(@i <1000)
begin
    set @var = 'true'
    set @j = 2
    while (@j < @i)
    begin 
        if @i % @j = 0
        begin
            set @var = 'false'
        end
        set @j = @j+1 
    end 
    if @var = 'true'
        begin
        set @result += cast(@i as nvarchar(1000)) + '&';
        end
    set @i = @i+1 
end
set @result = SUBSTRING(@result, 1, LEN(@result) - 1)
select @result