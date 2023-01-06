--What day of the week is used for each week_date value?
Select 
	To_Char(Date,'Day')
    from clean_weekly_sales
    Limit 1;


-- What range of week numbers are missing from the dataset?
With weeks as 
(Select Generate_series(1,52) as week_numbers)

Select * from weeks
where week_numbers not in 
(Select week from clean_weekly_sales);

--How many total transactions were there for each year in the dataset?
Select year, count(transactions)
from clean_weekly_sales 
group by year

-- What is the total sales for each region for each month?
Select region,month,sum(sales)
from clean_weekly_sales
group by region,month
order by region,month