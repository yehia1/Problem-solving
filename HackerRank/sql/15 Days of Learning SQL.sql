/*
Julia conducted a 15 days of learning SQL contest.
 The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least  submission each day (starting on the first day of the contest),
 and find the hacker_id and name of the hacker who made maximum number of submissions each day.
  If more than one such hacker has a maximum number of submissions, print the lowest hacker_id.
   The query should print this information for each day of the contest, sorted by the date.
*/

/* First 2 cte is used to get the maximum number of sumbits every day 
- first cte for counting the submissions for each user and date
- Second using the row_number function to count over the submission for each user for 1 day and order them desc so i can use condition on the last query
to choose the first 1
*/
with cte1 as(
Select hacker_id,submission_date,count(submission_id) as submission_count
From Submissions
Group By hacker_id,submission_date),

cte2 as
(Select submission_date,hacker_id,submission_count,
    row_number() over(partition By submission_date order by submission_count desc,hacker_id)
    as rank
From cte1),

/* these cte for getting the users who sumbitted for a consective days 
by comparing each day of these 15 days which starts from one there i was lucky so i choosed the day function
and the dense rank to count users for each day and the one who equals the days count will be choosed in the final query
*/

cte3 as(
Select submission_date,hacker_id,day(submission_date) submission_day,dense_rank () over (partition by hacker_id order by submission_date) as hacker_rank
From Submissions),

cte4 as (
Select submission_date,count(distinct hacker_id) as hackers_counts
From cte3 
Where submission_day = hacker_rank
Group By submission_date)

-- merge all the queries we got.
Select c4.submission_date,hackers_counts,c2.hacker_id,name
From cte2 c2
Inner Join cte4 c4
On c2.submission_date = c4.submission_date
Inner join Hackers h
On c2.hacker_id = h.hacker_id
Where rank = 1
order by c4.submission_date;




