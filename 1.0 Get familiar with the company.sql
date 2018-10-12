--1.0 SELECT all columns from subscriptions table
--and LIMIT query to 100 rows
SELECT *
  FROM subscriptions
 LIMIT 100;
--SELECT and GROUP BY the segment column for concrete
--confirmation on all segments
SELECT segment
  FROM subscriptions
 GROUP BY 1;
