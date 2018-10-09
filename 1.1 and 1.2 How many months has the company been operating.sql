--1.1 and 1.2 Use MIN and MAX aggregate functions to retrieve
--the lowest and highest date values from subscription_start
--column from the subscriptions table
SELECT
  MIN(subscription_start) AS first_subscription_date,
  MAX(subscription_start) AS last_subscription_date
FROM subscriptions;