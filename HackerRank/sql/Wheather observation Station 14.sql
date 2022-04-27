/*
Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.

Input Format

The STATION table is described as follows:
*/

select convert(decimal(10,4),max(LAT_N)) from station
where LAT_N < 137.2345