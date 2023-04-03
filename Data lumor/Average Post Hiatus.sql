# https://datalemur.com/questions/sql-average-post-hiatus-1

'''
Given a table of Facebook posts, for each user who posted at least twice in 2021,
write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021.
Output the user and number of the days between each user's first and last post.

p.s. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?
'''

SELECT user_id,
  Date_part('day',max(post_date) - min(post_date))
FROM POSTS
WHERE EXTRACT(year FROM post_date) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 2