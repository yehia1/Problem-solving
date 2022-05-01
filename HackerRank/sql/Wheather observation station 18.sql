/*
https://www.hackerrank.com/challenges/weather-observation-station-18/problem?isFullScreen=true
*/
select convert(decimal(20,4),
    abs(max(LAT_N)-min(LONG_W)) + abs(max(LONG_W)-min(LAT_N)))
from station