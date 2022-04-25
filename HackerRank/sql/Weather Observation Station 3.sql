/*
Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
The STATION table is described as follows:

Station.jpg

*/
select DISTINCT CITY from STATION where (ID % 2) = 0 ;