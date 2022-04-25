/*
Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

Input Format

The STATION table is described as follows:

Station.jpg
*/

SELECT DISTINCT CITY FROM STATION
WHERE CITY like '[^ieauo]%'