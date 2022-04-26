/*Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.

Input Format

The CITY and COUNTRY tables are described as follows:
*/
select y.continent,round(avg(c.POPULATION),2) from City c,country y
where c.COUNTRYCODE = y.code
group by y.continent