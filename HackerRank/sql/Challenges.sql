/*
Julia asked her students to create some coding challenges.
Write a query to print the hacker_id, name, and the total number of challenges created by each student.
Sort your results by the total number of challenges in descending order.
If more than one student created the same number of challenges, then sort the result by hacker_id.
If more than one student created the same number of challenges and the count is less than the maximum number of challenges created,
then exclude those students from the result.
*/
select h.hacker_id,h.name,count(c.challenge_id) as counter from Hackers h
inner join Challenges c on 
h.hacker_id = c.hacker_id
group by h.hacker_id,h.name 
having
      counter = (SELECT MAX(temp1.cnt)
        from (SELECT COUNT(hacker_id) as cnt
             from Challenges
             group by hacker_id) temp1)
        or counter in 
        /* the set of counts... */
        (select t.cnt
         from (select count(*) as cnt 
               from challenges
               group by hacker_id) t
         /* who's group of counts... */
         group by t.cnt
         /* has only one element */
         having count(t.cnt) = 1)
         
order by count(c.challenge_id) desc,h.hacker_id 