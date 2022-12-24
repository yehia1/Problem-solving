Create TEMP TABLE cleaned_customer as
 SELECT 
 	order_id,
    customer_id,
    pizza_id,
    CASE
    	WHEN exclusions LIKE '' or exclusions LIKE 'null' THEN NULL
        ELSE exclusions
        END AS exclusions,
 	CASE
    	WHEN extras LIKE '' or extras LIKE 'null' THEN NULL
        ELSE extras
        END AS extras,
    order_time
 FROM pizza_runner.customer_orders;
 
Create TEMP TABLE cleaned_runner as
	SELECT
    	order_id,
        runner_id,
        Cast(CASE
        	WHEN pickup_time LIKE '' 
            or pickup_time LIKE 'null' THEN NULL
            ELSE pickup_time
            END as TIMESTAMP) as pickup_time,
        Cast(CASE
        	WHEN distance LIKE '' 
            or distance LIKE 'null' THEN NULL
            WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
            Else distance
            END as Float) as distance,
        CAST(CASE
        	WHEN duration LIKE '' 
            or duration LIKE 'null' THEN NULL
            WHEN duration LIKE '%mins'
            THEN TRIM('mins' FROM duration)
            WHEN duration LIKE '%minutes'
            THEN TRIM('minutes' FROM duration)
            WHEN duration LIKE '%minute'
            THEN TRIM('minute' FROM duration)
            Else duration
            END as Float) as duration,
        CASE
        	WHEN cancellation LIKE 'NAN' 
            or cancellation LIKE 'null'
            or cancellation LIKE '' THEN NULL
            ELSE cancellation
            END as cancellation
FROM pizza_runner.runner_orders;

           

