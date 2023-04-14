-- https://datalemur.com/questions/signup-confirmation-rate

/*
New TikTok users sign up with their emails.
They confirmed their signup by replying to the text confirmation to activate their accounts.
Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table.
Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

emails table contain the information of user signup details.
texts table contains the users' activation information.
Assumptions:

The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
For example, user 123 in the emails table may not be in the texts table and vice versa.

*/

SELECT ROUND(COUNT(*):: NUMERIC/
(SELECT COUNT(*) FROM texts),2)confirm_rate
FROM texts
WHERE signup_action = 'Confirmed'