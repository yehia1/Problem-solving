/*
Query  Western Longitude (LONG_W) from STATION that is greater than 38.770. Round your answer to 4 decimal places.

*/

select top 1 convert(decimal(6,4),LONG_W) from Station 
where LAT_N > 38.7780
order by LAT_N asc  