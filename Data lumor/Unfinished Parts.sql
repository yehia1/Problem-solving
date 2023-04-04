-- https://datalemur.com/questions/tesla-unfinished-parts

'''
Tesla is investigating bottlenecks in their production, and they need your help to extract the relevant data.
Write a query that determines which parts have begun the assembly process but are not yet finished.
'''
SELECT part FROM
parts_assembly
WHERE finish_date is NULL
GROUP BY part