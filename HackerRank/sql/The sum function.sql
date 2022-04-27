/*
Query the total population of all cities in CITY where District is California.
*/
select sum(POPULATION) from CITY where district = 'California'