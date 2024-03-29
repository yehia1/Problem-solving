-- https://datalemur.com/questions/sql-page-with-no-likes

'''
Assume you are given the tables below about Facebook pages and page likes.
Write a query to return the page IDs of all the Facebook pages that don't have any likes.
The output should be in ascending order.

'''

SELECT page_id
FROM pages
WHERE page_id NOT IN (SELECT page_id From page_likes)