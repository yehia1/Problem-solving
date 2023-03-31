-- https://datalemur.com/questions/matching-skills
'''
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job.
You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job.
Sort the output by candidate ID in ascending order.
'''
WITH order_tables as(
  Select candidate_id, skill
  FROM candidates
  ORDER BY candidate_id,skill 
),

skills_agg as(
Select candidate_id, string_agg(skill,',') as skills
FROM order_tables 
GROUP BY candidate_id)

Select candidate_id FROM
skills_agg 
Where skills like '%PostgreSQL,Python,Tableau%' 
