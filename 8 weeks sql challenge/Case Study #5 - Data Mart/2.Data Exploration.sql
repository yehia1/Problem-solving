--What day of the week is used for each week_date value?
Select 
	To_Char(Date,'Day')
    from clean_weekly_sales
    Limit 1;