--3.0 Create temporary table using WITH and UNION for Jan, Feb, 
--and Mar 2017
WITH months AS
(SELECT '2017-01-01' AS first_day,
 	      '2017-01-31' AS last_day
  UNION
 SELECT
	      '2017-02-01' AS first_day,
 	      '2017-02-28' AS last_day
  UNION
 SELECT
 	      '2017-03-01' AS first_day,
 	      '2017-03-31' AS last_day
),
--Create temporary table cross_join to CROSS JOIN with
--subscriptions table
cross_join AS
(SELECT subscriptions.*, 
        months.*
   FROM subscriptions
        CROSS JOIN months
),
--Create temporary status table to add 1's and 0's
--in order to SUM them in status_aggregate temporary table
status AS
(SELECT id,
        first_day AS month,
        CASE
          WHEN (subscription_start < first_day) AND
            (
            subscription_end > first_day OR
            subscription_end IS NULL
            ) AND
            (segment = 87) THEN 1
          ELSE 0
        END AS is_active_87,
        CASE
          WHEN (subscription_start < first_day) AND
            (
            subscription_end > first_day OR
            subscription_end IS NULL
            ) AND
            (segment = 30) THEN 1
          ELSE 0
        END AS is_active_30,
--Add is_canceled CASE statements to status temporary table
--and closing temporary status table with FROM cross_join
        CASE
          WHEN (subscription_end BETWEEN first_day AND last_day) AND
            (segment = 87) THEN 1
          ELSE 0
        END AS is_canceled_87,
        CASE
          WHEN (subscription_end BETWEEN first_day AND last_day) AND
            (segment = 30) THEN 1
          ELSE 0
        END AS is_canceled_30
   FROM cross_join
),
--Ccreate temporary status_aggregate table to SUM
--active and canceled subscriptions as columns and GROUP BY month
status_aggregate AS
(SELECT month,
        SUM(is_active_87) AS sum_active_87,
        SUM(is_active_30) AS sum_active_30,
        SUM(is_canceled_87) AS sum_canceled_87,
        SUM(is_canceled_30) AS sum_canceled_30
   FROM status
  GROUP BY month
)
--Ccalculate the churn from status_aggregate temporary table
--by dividing SUM of canceled by SUM of active, per segment
SELECT month,
       1.0 * sum_canceled_87 / sum_active_87 AS churn_rate_87,
       1.0 * sum_canceled_30 / sum_active_30 AS churn_rate_30
  FROM status_aggregate;