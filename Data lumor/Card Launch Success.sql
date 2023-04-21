--

/*
Your team at JPMorgan Chase is soon launching a new credit card.
You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month.
The launch month is the earliest record in the monthly_cards_issued table for a given card.
Order the results starting from the biggest issued amount.
*/

WITH card_least_month_cte as(
SELECT card_name,
MIN(to_date(issue_year || '-' || issue_month || '-01','YYYY-MM-DD')) as date
FROM monthly_cards_issued
GROUP BY card_name
),

date_conversion as(
SELECT card_name,issued_amount,
to_date(issue_year || '-' || issue_month || '-01','YYYY-MM-DD')as date
FROM monthly_cards_issued)

SELECT d.card_name,d.issued_amount
FROM date_conversion d
JOIN card_least_month_cte c
ON d.card_name = c.card_name AND d.date = c.date
ORDER BY issued_amount DESC


