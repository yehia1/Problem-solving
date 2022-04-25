/*
Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

Input Format

The STATION table is described as follows:

Station.jpg
*/

select distinct CITY from Station where CITY like '%[ieaou]'