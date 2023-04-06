-- https://datalemur.com/questions/second-day-confirmation

'''
New TikTok users sign up with their emails and each user receives a text confirmation to activate their account.
 Assume you are given the below tables about emails and texts.

Write a query to display the ids of the users who did not confirm on the first day of sign-up,
 but confirmed on the second day.
'''

SELECT e.user_id
From texts t
Join emails e
On e.email_id = t.email_id
WHERE action_date = interval '1' day + signup_date
ORDER BY user_id

