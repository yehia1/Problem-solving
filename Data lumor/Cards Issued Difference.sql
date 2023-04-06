--https://datalemur.com/questions/cards-issued-difference
'''
Your team at JPMorgan Chase is soon launching a new credit card,
 and to gain some context, you are analyzing how many credit cards were issued each month.

Write a query that outputs the name of each credit card and the difference in issued amount between the month with the most cards issued,
 and the least cards issued.
 Order the results according to the biggest difference.
'''

SELECT card_name, 
  MAX(issued_amount) - MIN(issued_amount)
FROM monthly_cards_issued 
GROUP BY card_name
ORDER BY 2 desc