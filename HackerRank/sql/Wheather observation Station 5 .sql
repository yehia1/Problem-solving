/*
Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
The STATION table is described as follows:

*/

select top 1 city c, len(city) l
from   station
order by l desc, c asc;

select top 1 city c, len(city) l
from   station
order by l asc, c asc;