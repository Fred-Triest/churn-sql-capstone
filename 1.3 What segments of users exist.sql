--1.3 SELECT and GROUP BY the segment column for concrete
--confirmation on all segments 
SELECT segment
FROM subscriptions
GROUP BY 1;
--SELECT the DISTINCT COUNT of subscribers by id
--and GROUP BY segment to get user count by segment
SELECT DISTINCT
  COUNT(id) AS number_of_subscribers,
  segment
FROM subscriptions
GROUP BY 2;