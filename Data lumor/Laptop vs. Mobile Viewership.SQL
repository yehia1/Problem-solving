-- Laptop vs. Mobile Viewership
'''
This is the same question as problem #3 in the SQL Chapter of Ace the Data Science Interview!

Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). Define “mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the viewership on laptops versus mobile devices.

Output the total viewership for laptop and mobile devices in the format of "laptop_views" and "mobile_views".
'''

SELECT
Sum(CASE 
    WHEN device_type = 'laptop' Then 1
    END
  ) as laptop_views,
Sum(CASE 
    WHEN device_type = 'phone' device_type = 'tablet' Then 1
    END
  ) as mobile_views
FROM viewership

