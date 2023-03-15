# Case Study #8- Fresh Segments
<img src="https://8weeksqlchallenge.com/images/case-study-designs/8.png" alt="Image" width="500" height="520">

- [Introduction](#Introduction)
- [Tables](#tables)
- [Case Study Questions](#Case-Study-Questions)
***
## Introduction
Danny created Fresh Segments, a digital marketing agency that helps other businesses analyse trends in online ad click behaviour for their unique customer base.

Clients share their customer lists with the Fresh Segments team who then aggregate interest metrics and generate a single dataset worth of metrics for further analysis.

In particular - the composition and rankings for different interests are provided for each client showing the proportion of their customer list who interacted with online assets related to each interest for each month.

Danny has asked for your assistance to analyse aggregated metrics for an example client and provide some high level insights about the customer list and their interests.
***
## Tables
For this case study there is a total of 2 datasets which you will need to use to solve the questions.
### Interest Metrics
This table contains information about aggregated interest metrics for a specific major client of Fresh Segments which makes up a large proportion of their customer base.

Each record in this table represents the performance of a specific <span style="color:red"> interest_id</span> based on the client’s customer base interest measured through clicks and interactions with specific targeted advertising content.
| _month | _year | month_year | interest_id | composition | index_value | ranking | percentile_ranking |
| ------ | ----- | ---------- | ----------- | ----------- | ----------- | ------- | ------------------ |
| 7      | 2018  | 07-2018    | 32486       | 11.89       | 6.19        | 1       | 99.86              |
| 7      | 2018  | 07-2018    | 6106        | 9.93        | 5.31        | 2       | 99.73              |
| 7      | 2018  | 07-2018    | 18923       | 10.85       | 5.29        | 3       | 99.59              |
| 7      | 2018  | 07-2018    | 6344        | 10.32       | 5.1         | 4       | 99.45              |
| 7      | 2018  | 07-2018    | 100         | 10.77       | 5.04        | 5       | 99.31              |
| 7      | 2018  | 07-2018    | 69          | 10.82       | 5.03        | 6       | 99.18              |
| 7      | 2018  | 07-2018    | 79          | 11.21       | 4.97        | 7       | 99.04              |
| 7      | 2018  | 07-2018    | 6111        | 10.71       | 4.83        | 8       | 98.9               |
| 7      | 2018  | 07-2018    | 6214        | 9.71        | 4.83        | 8       | 98.9               |
| 7      | 2018  | 07-2018    | 19422       | 10.11       | 4.81        | 10      | 98.63              |

In July 2018, the <span style="color:red">composition</span> metric is 11.89, meaning that 11.89% of the client’s customer list interacted with the interest  <span style="color:red">interest_id = 32486</span>  - we can link <span style="color:red">interest_id </span> to a separate mapping table to find the segment name called “Vacation Rental Accommodation Researchers”

The <span style="color:red">index_value </span> is 6.19, means that the <span style="color:red">composition</span> value is 6.19x the average composition value for all Fresh Segments clients’ customer for this particular interest in the month of July 2018.

The <span style="color:red">ranking</span>  and <span style="color:red">percentage_ranking</span>  relates to the order of <span style="color:red">index_value </span>  records in each month year.
### Interest Map
This mapping table links the <span style="color:red">interest_id</span> with their relevant interest information. You will need to join this table onto the previous <span style="color:red">interest_details</span> table to obtain the <span style="color:red">interest_name</span>  as well as any details about the summary information.

| id  | interest_name             | interest_summary                                                                   | created_at               | last_modified            |
| --- | ------------------------- | ---------------------------------------------------------------------------------- | ------------------------ | ------------------------ |
| 1   | Fitness Enthusiasts       | Consumers using fitness tracking apps and websites.                                | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 2   | Gamers                    | Consumers researching game reviews and cheat codes.                                | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 3   | Car Enthusiasts           | Readers of automotive news and car reviews.                                        | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 4   | Luxury Retail Researchers | Consumers researching luxury product reviews and gift ideas.                       | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 5   | Brides & Wedding Planners | People researching wedding ideas and vendors.                                      | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 6   | Vacation Planners         | Consumers reading reviews of vacation destinations and accommodations.             | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:13.000Z |
| 7   | Motorcycle Enthusiasts    | Readers of motorcycle news and reviews.                                            | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:13.000Z |
| 8   | Business News Readers     | Readers of online business news content.                                           | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
| 12  | Thrift Store Shoppers     | Consumers shopping online for clothing at thrift stores and researching locations. | 2016-05-26T14:57:59.000Z | 2018-03-16T13:14:00.000Z |
| 13  | Advertising Professionals | People who read advertising industry news.                                         | 2016-05-26T14:57:59.000Z | 2018-05-23T11:30:12.000Z |
## Case Study Questions
### Data Exploration and Cleansing
1. Update the <span style="color:red">fresh_segments.interest_metrics</span> table by modifying the <span style="color:red">month_year</span>  column to be a date data type with the start of the month
2. What is count of records in the <span style="color:red">fresh_segments.interest_metrics</span>  for each <span style="color:red">month_year</span>  value sorted in chronological order (earliest to latest) with the null values appearing first?
3. What do you think we should do with these null values in the  <span style="color:red">fresh_segments.interest_metrics</span> 
4. How many <span style="color:red">interest_id</span> values exist in the <span style="color:red">fresh_segments.interest_metrics</span> table but not in the <span style="color:red">fresh_segments.interest_map</span> table? What about the other way around?
5. Summarise the <span style="color:red">id</span>  values in the <span style="color:red">fresh_segments.interest_map</span> by its total record count in this table
6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where <span style="color:red">finterest_id = 21246</span> in your joined output and include all columns from <span style="color:red">fresh_segments.interest_metrics</span>and all columns from <span style="color:red">fresh_segments.interest_map</span> except from the <span style="color:red">id</span> column.
7. Are there any records in your joined table where the <span style="color:red">month_year</span> value is before the <span style="color:red">created_at</span> value from the <span style="color:red">fresh_segments.interest_map</span> table? Do you think these values are valid and why?
***
### Interest Analysis
1. Which interests have been present in all <span style="color:red">month_year</span> dates in our dataset?
2. Using this same <span style="color:red">total_months</span> measure - calculate the cumulative percentage of all records starting at 14 months - which <span style="color:red">total_months</span>  value passes the 90% cumulative percentage value?
3. If we were to remove all <span style="color:red">interest_id</span>  values which are lower than the <span style="color:red">total_months</span> value we found in the previous question - how many total data points would we be removing?
4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed <span style="color:red">interest</span>  example for your arguments - think about what it means to have less months present from a segment perspective.
5. After removing these interests - how many unique interests are there for each month?
***
### Segment Analysis
1. Using our filtered dataset by removing the interests with less than 6 months worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any <span style="color:red">month_year</span> ? Only use the maximum composition value for each interest but you must keep the corresponding <span style="color:red">month_year</span> 
2. Which 5 interests had the lowest average <span style="color:red">ranking</span>  value?
3. Which 5 interests had the largest standard deviation in their <span style="color:red">percentile_ranking</span>   value?
4. For the 5 interests found in the previous question - what was minimum and maximum <span style="color:red">percentile_ranking</span> values for each interest and its corresponding <span style="color:red">year_month</span> value? Can you describe what is happening for these 5 interests?
5. How would you describe our customers in this segment based off their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?
***
### Index Analysis
The <span style="color:red">index_value</span>  is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.
Average <span style="color:red">composition</span> can be calculated by dividing the composition column by the <span style="color:red">index_value</span>  column rounded to 2 decimal places.
1. What is the top 10 interests by the average composition for each month?
2. For all of these top 10 interests - which interest appears the most often?
3. What is the average of the average composition for the top 10 interests for each month?
4. What is the 3 month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top ranking interests in the same output shown below.
5. Provide a possible reason why the max average composition might change from month to month? Could it signal something is not quite right with the overall business model for Fresh Segments?
