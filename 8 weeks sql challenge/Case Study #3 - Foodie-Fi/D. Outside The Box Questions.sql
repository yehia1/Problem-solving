Set
  search_path = foodie_fi;
Select
  DATE_TRUNC('month', start_date) AS month,
  Count(customer_id) as current_number_of_customers,
  Lag(Count(customer_id), 1) over (
    ORDER BY
      DATE_TRUNC('month', start_date)
  ) as past_number_of_customers,
  (
    100 * (
      Count(customer_id) - Lag(Count(customer_id), 1) over (
        Order By
          DATE_TRUNC('month', start_date)
      )
    ) / Lag(Count(customer_id), 1) over (
      Order By
        DATE_TRUNC('month', start_date)
    )
  ) || '%' AS growth
From
  subscriptions as s
  Join plans as p
  On s.plan_id = p.plan_id
Where
  plan_name != 'trial'
  and plan_name != 'churn'
Group By
  month
Order By
  month