/*
Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/
select sum(c.population) from CITY c,COUNTRY ct
where c.COUNTRYCODE = ct.CODE and CONTINENT = 'Asia'