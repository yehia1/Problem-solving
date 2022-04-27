/*
Query the following two values from the STATION table:

The sum of all values in LAT_N rounded to a scale of 2 decimal places.
The sum of all values in LONG_W rounded to a scale of 2 decimal places.
*/

select convert(decimal(10,2),sum(LAT_N)),
convert(decimal(10,2),sum(LONG_W)) from station