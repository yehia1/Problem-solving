/*
You did such a great job helping Julia with her last coding contest challenge that she wants you to work on this one, too!

The total score of a hacker is the sum of their maximum scores for all of the challenges.
Write a query to print the hacker_id, name, and total score of the hackers ordered by the descending score.
If more than one hacker achieved the same total score, then sort the result by ascending hacker_id.
Exclude all hackers with a total score of 0 from your result.
*/

select h.hacker_id,h.name,sum(s.score) as total_score
from hackers as h join 
      (select hacker_id,challenge_id,max(score) as score from submissions
      group by hacker_id,challenge_id) s
      
on h.hacker_id = s.hacker_id 
where score > 0 

group by h.hacker_id,h.name
order by sum(score) desc,h.hacker_id asc