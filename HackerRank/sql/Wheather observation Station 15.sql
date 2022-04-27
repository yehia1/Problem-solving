/*
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345.
 Round your answer to 4 decimal places.
 */
 
select TOP 1 convert(decimal(10,4),max(LONG_W)) from station
where LAT_N < 137.2345
group by LAT_N
order by LAT_N desc