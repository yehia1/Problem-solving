-- https://datalemur.com/questions/teams-power-users

'''
Write a query to find the top 2 power users who sent the most messages on Microsoft Teams in August 2022.
Display the IDs of these 2 users along with the total number of messages they sent.
Output the results in descending count of the messages.
'''
SELECT sender_id,COUNT(message_id)
FROM messages
WHERE sent_date BETWEEN '08/01/2022' AND '08/31/2022'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2