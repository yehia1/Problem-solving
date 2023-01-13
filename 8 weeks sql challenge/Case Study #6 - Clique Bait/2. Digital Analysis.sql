SET search_PATH = clique_bait;

--find number of users
Select count(*) as number_of_users from usersك

--How many cookies does each user have on average?
Select Round(avg(counts)) as avg_cookies
from
(Select user_id,count(cookie_id) as counts
from users
group by 1) sub1
