/*
Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

Input Format

The CITY and COUNTRY tables are described as follows:
*/
select c.NAME from CITY c INNER JOIN COUNTRY ct
on c.COUNTRYCODE = ct.CODE
Where CONTINENT = 'Africa'