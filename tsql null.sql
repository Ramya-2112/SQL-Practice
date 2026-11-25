/*Table of Contents:
     1. Handle NULL - Data Aggregation
     2. Handle NULL - Mathematical Operators
     3. Handle NULL - Sorting Data
     4. NULLIF - Division by Zero
     5. IS NULL - IS NOT NULL
     6. LEFT ANTI JOIN
     7. NULLs vs Empty String vs Blank Spaces*/
/* functions:
coalesce/isnull   null  to 30
nullif  30 to null
isnull/isnotnull ? true or false
*/
-- 1.DATA AGGREGATION average score of the customers
select
customerid,
score,
coalesce(score,0) score_1,
avg(score)over() as average_score,
avg(coalesce(score,0))over() as average_score_1
from sales.customers;
/*over() tells the sql server to calculate the average across the entire result set without grouping the rows together.
avg without coalesce ignores null values.*/

-- 2. Mathematical operations
/*Display the full name of customers in a single field by merging their
   first and last names, and add 10 bonus points to each customer's score.*/
select
firstname,
lastname,
concat(firstname ,coalesce(lastname,'')) as full_name,
coalesce(score,0)+10 as dd
from sales.customers;
-- 3.sorting data
/*Sort the customers from lowest to highest scores,
   with NULL values appearing last.*/
select
customerid,
score,
case when score is null then 1 else 0 end flag
from 
sales.customers
order by case when score is null then 1 else 0 end, score;
-- 4.NULLIF - DIVISION BY ZERO
-- here we are preventing the error of dividing by zero
/*Find the sales price for each order by dividing sales by quantity.*/
select
sales,
quantity,
sales/nullif(quantity,0) as saleprice
from sales.orders;
-- 5.is null & is not null
--   Identify the customers who have no scores 
SELECT *
FROM sales.Customers
WHERE Score IS NULL;
-- 6.who has scores
select * from
sales.customers where score is not null;

-- 7.Left anti join + is null
-- List all details for customers who have not placed any orders 
select * from sales.customers as c
left join sales.orders as o
on c.customerid=o.customerid
where o.orderid is null;
--  NULLs vs EMPTY STRING vs BLANK SPACES
-- differences between NULL, empty strings, and blank spaces
WITH Orders AS (
    SELECT 1 AS Id, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    DataLENGTH(Category) AS LenCategory,
    TRIM(Category) AS Policy1,
    NULLIF(TRIM(Category), '') AS Policy2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;

