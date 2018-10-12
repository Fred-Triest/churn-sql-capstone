--1.1 and 1.2 Use MIN and MAX aggregate functions to retrieve
--the first and latest date values from subscription_start
--column from the subscriptions table
SELECT MIN(subscription_start) AS first_subscription_start_date,
       MAX(subscription_start) AS latest_subscription_start_date
  FROM subscriptions;
