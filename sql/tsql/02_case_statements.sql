-- Case statements
/* Evaluates a list of conditions and returns a value when the first condition is met 
Use cases:
     1. Categorize Data  2. Mapping  3. Quick Form of Case Statement  4. Handling Nulls  5. Conditional Aggregation 
Rules: 
     The data type of result must be matching
     Case statement can be used anywhere in the query */
-----------------------------------------------------------------------------------------------------------------------------------
/* 1. showing total sales for each category:
	   - High: Sales over 50,  Medium: Sales between 20 and 50, Low: Sales 20 or less
   The results are sorted from highest to lowest total sales.*/
select
    orderId,
    productid,
    sales,
case
when sales>50 then'High'
when sales>20 then 'Medium'
else 'Low'
End as Category
from sales.orders
order by sales desc;
------------------------------------------------------------------------------------------------------------------------------
-- Mapping
-- 2.Employee details with gender displayed as full text
select 
    employeeid,
    firstname,
    lastname,
    gender,
case
    when gender='M' then 'Male'
    when gender='F' then 'Female'
End EM
from sales.employees
--3.customer details with abbreviated country codes 
select 
    customerid,
    firstname,
    lastname,
    country,
    score,
case
    when country='Germany'then'GER'
    when country='USA'then'US'
    else 'Not available'
End  Abreviated_country_codes
from sales.customers;
-- 4.Quick form[column to be evaluated only one][only for equal operator][for simple only not complex logic]
-- same example as above
select 
    customerid,
    firstname,
    country,
case Country
    when'Germany'then'GER'
    when'USA'then'US'
    else 'Not available'
End  Abb_codes
from sales.customers;
----------------------------------------------------------------------------------------------------------------------------
-- Handling nulls
--Replace nulls with a specific values
-- null can lead to incorrect results, which can lead to wrong decision making:
--5. Calculate the average score of customers, treating NULL as 0, and provide CustomerID and LastName details.
select
customerid,
firstname,
lastname,
score,
case
    when score IS NULL THEN 0
    else score
end cleanscore,
avg(score) over() average,
avg(case
        when score IS NULL THEN 0
        else score
    end ) over() clean_average
from sales.customers;
------------------------------------------------------------------------------------------------------------------------------
-- conditional aggregation
-- apply aggregate function only on subsetts of data that fulfills certain conditions
-- deep dive analysis
-- 6.Count how many orders each customer made with sales greater than 30 
select 
c.customerid,
c.firstname,
o.sales,
case    
    when o.sales>30 then 1
    else 0
end flag
from sales.orders as o
inner join
sales.customers as c
on o.customerid=c.customerid
order by customerid;
-- this is step1 creating flag and to see the data clearly
select
customerid,
sum(case    
    when sales>30 then 1
    else 0
end )orders,
count(*) actual_orders
from sales.orders
group by customerid
-- second step to sumarize

