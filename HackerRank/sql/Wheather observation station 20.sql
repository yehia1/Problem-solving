/*
A median is defined as a number separating the higher half of a data set from the lower half. 
Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
*/
select top 1 convert(decimal(20,4),PERCENTILE_DISC (.5) WITHIN GROUP (order by lat_n) OVER())from station