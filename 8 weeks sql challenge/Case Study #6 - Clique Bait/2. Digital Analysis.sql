SET search_PATH = clique_bait;

--find number of users
Select count(*) as number_of_users from usersك

--How many cookies does each user have on average?
Select Round(avg(counts)) as avg_cookies
from
(Select user_id,count(cookie_id) as counts
from users
group by 1) sub1


--What is the unique number of visits by all users per month?
Select extract(month from event_time) months,
	count(distinct visit_id) Number_of_events
    from events e
    group by 1 

--What is the percentage of visits which have a purchase event?
Select
	Round(100 * count(visit_id)::Numeric/
    (select count(visit_id) from events),2) as Purchase_percentage
from events e
inner join event_identifier ei
on e.event_type = ei.event_type
where event_name = 'Purchase' 