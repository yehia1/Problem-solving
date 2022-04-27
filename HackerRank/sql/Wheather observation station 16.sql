/*
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.770. Round your answer to 4 decimal places.

*/

select top 1 convert(decimal(6,4),LAT_N) from Station 
where LAT_N > 38.7780
order by LAT_N asc  