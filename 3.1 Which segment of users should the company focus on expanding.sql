--3.1 Create temporary table using WITH and UNION for Jan, Feb, 
--and Mar 2017
WITH months AS
(SELECT '2016-12-01' AS first_day,
        '2016-12-31' AS last_day
 UNION
 SELECT
        '2017-01-01' AS first_day,
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
 FROM   subscriptions
        CROSS JOIN months
),
--Create temporary status table to add 1's and 0's
--in order to SUM and group new subscribers by acquisition channel
status AS
(SELECT id,
        first_day AS month,
        CASE
          WHEN (subscription_start BETWEEN first_day AND last_day)
          AND (segment = 87) THEN 1
          ELSE 0
        END AS new_subscriber_87,
        CASE
          WHEN (subscription_start BETWEEN first_day AND last_day)
          AND (segment = 30) THEN 1
          ELSE 0
        END AS new_subscriber_30
   FROM cross_join
),
--Create temporary status_aggregate table to SUM
--segment 87 and 30 subscriptions as columns and GROUP BY month
status_aggregate AS
(SELECT month,
        SUM(new_subscriber_87) AS sum_new_subscriber_87,
        SUM(new_subscriber_30) AS sum_new_subscriber_30
   FROM status
  GROUP BY month
)SELECT * FROM status_aggregate;