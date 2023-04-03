-- https://datalemur.com/questions/duplicate-job-listings

'''
This is the same question as problem #8 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below that shows job postings for all companies on the LinkedIn platform. Write a query to get the number of companies that have posted duplicate job listings.

Clarification:

Duplicate job listings refer to two jobs at the same company with the same title and description.
'''

SELECT count(DISTINCT j1.company_id) co_w_duplicate_jobs
FROM job_listings j1
JOIN job_listings j2
On j1.company_id = j2.company_id
and j1.description = j2.description
AND j1.job_id != j2.job_id