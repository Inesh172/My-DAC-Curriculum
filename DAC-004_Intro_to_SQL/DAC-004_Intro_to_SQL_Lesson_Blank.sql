-- Refresher on how to perform basic query and how the database works:

-- SELECT Clause: everything = *

-- Select department table, the employee table and vendor table. Let's explore the database a little!
# department table
SELECT *	
FROM humanresources.department; 	

# employee table
SELECT *
FROM humanresources.employee;

# vendor table
SELECT *
FROM purchasing.vendor;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT some columns:

-- Select only name, start time and end time.

SELECT 
	name,
	starttime,
	endtime
FROM humanresources.shift;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT DISTINCT values: Unique column value

-- Distinct group names from department and businessentityid from jobcandidate
SLECT DISTINCT groupname  
FROM humanresources.department;

SLECT DISTINCT businessentityid
FROM humanresources.jobcandidate;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- From different schemas: sales



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- LIMIT: As the name suggest it limits the number of *rows* shown at the end result
SELECT * 
FROM purchasing.productvendor
LIMIT 10;      # Limit the table productvendor to 10 rows

SELECT * 
FROM purchasing.purchaseorderdetail
LIMIT 100;    # Limit the table purchaseorderdetail to 100 rows
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT MDAS: Multiplcation/division/addition/subtraction

-- From the customer table Multiplcation/division/addition/subtraction the store_id
SELECT 
	customerid,
	storeid * 10 AS tenfold
FROM sales.customer
LIMIT 15;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Q1: SELECT the DISTINCT title, last name, middlename and first_name of each person from the person schema. Return only 231 rows.
--A1;
SELECT DISTINCT 
	title,
	lastname,
	middlename,
	firstname
FROM person.person
LIMIT 231;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause: = 
-- gender is male
SELECT 
    jobtitle,
	maritalstatus,
	gender
FROM humanresources.employee
WHERE gender = 'M';

-- Only Research and Development
SELECT *
FROM humanresources.department
WHERE groupname = 'Research and Development';

-- When dealing with NULL values
SELECT *
FROM purchasing.productvendor
WHERE onorderqty IS NULL;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause: Arithmetic filter

-- From customer table, territoryid = 4
SELECT * 
FROM sales.customer
WHERE territoryid = 4
LIMIT 10;
-- From person table, emailpromotion <> 0
SELECT * 
FROM person.person
WHERE emailpromotion <> 0
LIMIT 10;

-- From employee table, vacationhours >= 99
SELECT *
FROM humanresources.employee
WHERE vacationhours >= 99
LIMIT 50;

-- From employee table, sickleavehours <= 20
 SELECT *
FROM humanresources.employee
WHERE sickleavehours <= 20
LIMIT 50;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--WHERE clause: OR clause

-- From employee table, select either Design Engineer or Tool Designer
SELECT * 
FROM humanresources.employee
WHERE jobtitle = 'Design Engineer'
   OR jobtitle = 'Tool Designer';

-- From product, select either Black or Silver
SELECT *
FROM production.product
WHERE color = 'Black'
   OR color = 'Silver';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause: AND clause

-- From Vendor, preferredvendorstatus and activeflag must be TRUE
SELECT * 
FROM purchasing.vendor
WHERE preferredvendorstatus = TRUE
  AND activeflag = TRUE;

-- From employee, gender must be Male and maritalstatus must be single
SELECT * 
FROM humanresources.employee
WHERE gender = 'M'
  AND maritalstatus = 'S';	

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--WHERE clause: Combined OR & AND clause

-- From the employee table pick either, marital status as single and gender male or marital status as married and gender female.
SELECT 
     jobtitle,
	 gender,
	 maritalstatus,
	 vacationhours,
	 sickleavehours
FROM humanresources.employee
WHERE (maritalstatus = 'S' AND gender = 'M')
   OR (maritalstatus = 'M' AND gender = 'F');

-- Example of poor formatting and logic.
-- From the salesperson table select territory_id either 4 or 6 and salesquota either 250000 or 300000
SELECT *
FROM sales.salesperson
WHERE (territoryid = 4 OR territoryid = 6)
   AND (salesquota = 250000 OR salesquota = 300000);
--Note: AND takes higher priority than OR




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--WHERE clause: IN clause
--Q: Find all the employees whose birthdate fall on these dates.

-- '1977-06-06'
-- '1984-04-30'
-- '1985-05-04'

SELECT *
FROM sales.salesperson
WHERE birthdate IN ('1977-06-06', '1984-04-30', '1985-05-04');


-- Find all the middle names that contains either A or B or C.
SELECT *
FROM person.person
WHERE middlename IN ('A', 'B', 'C');
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause: LIKE clause
-- The placement of the wildcard, %, affects what is getting filtered out.
SELECT *
FROM person.person
WHERE firstname LIKE 'J%';
-- From the person table, select all the firstname starting with a 'J'
-- Works very similar to excel find function

-- Find J  
SELECT *
FROM person.person
WHERE firstname LIKE '%J%'; # anywhere containing J 
-- Only works for string!
SELECT *
FROM humanresources.employee;
WHERE birthdate LIKE '1969-01-29%'; -- not supposed to work as data got problem

-- But what if you know the number of letters in the firstname?

SELECT *
FROM person.person
WHERE firstname LIKE 'J___';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- What if we want firstnames that contains the letter a inside?
SELECT *
FROM person.person
WHERE firstname LIKE '%A%';

-- not tallying

-- We have two varying results, we can use things like UPPER() and LOWER() clause
SELECT *
FROM person.person
WHERE LOWER(firstname) LIKE '%a%'; 

SELECT *
FROM person.person
WHERE UPPER(firstname) LIKE '%A%';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause: NOT clause

-- From the person table, lastname should not contain A in it.
SELECT *
FROM person.person
WHERE UPPER(lastname) NOT LIKE '%A%'; 


-- From the employee table, choose those that do not fall into this date range:
-- '1977-06-06', '1984-04-30', '1985-05-04'

SELECT *
FROM humanresources.employee
WHERE birthdate NOT IN (
	'1977-06-06', 
	'1984-04-30',
	'1985-05-04'
);



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- GROUP BY clause: For aggregate values
-- For us to use when we want to use aggregates.

-- From employee table, group by gender

SELECT 
	gender
FROM humanresources.employee
GROUP BY gender;

-- From employee table, group by maritalstatus

SELECT 
	gender
FROM humanresources.employee
GROUP BY maritalstatus;

-- We can also group more than one column
SELECT
	gender,
	maritalstatus,
	jobtitle
FROM humanresources.employee
GROUP BY gender,
	maritalstatus,
	jobtitle;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- All the AGGREGATES!
SELECT 
	gender,
	--COUNT(gender) AS Headcount,
	--COUNT(*) AS Headcount,
	COUNT(DISTINCT jobtitle) AS unqiuejobTitle,
	SUM(vacationhours) AS total_vacation_hours,
	AVG(vacationhours) AS average_vacation_hours,
	CEILING(Avg(vacationhours)) AS ceiling_vacation_hours,
	FLOOR(Avg(vacationhours)) AS floor_vacation_hours,
	ROUND(Avg(vacationhours)) AS rounded_average,

	MAX(sickleavehours) AS max_sick_hours,
	MIN(sickleavehours) AS min_sick_hours
	
FROM humanresources.employee
GROUP BY gender;

-- Q2: Analyse if the marital status of each gender affects the number of vacation hours one will take
-- A2:
SELECT 
	gender,
	maritalstatus,
	AVG(vacationhours) AS avg_vacation_hours,
FROM humanresources.employee
GROUP BY 1,2;

-- From employee table, ORDER BY hiredate, ASC and DESC
-- hiredate earliest
SELECT *
FROM humanresources.employee
ORDER BY hiredate ASC;

-- hiredate latest
SELECT *
FROM humanresources.employee
ORDER BY hiredate DESC;

-- Sort table using two or more values
SELECT 
	jobtitle,
	gender
FROM humanresources.employee
ORDER BY jobtitle ASC, gender ASC;

-- Sorting by Average
SELECT 
	jobtitle,
	AVG(vacationhours) AS avg_vacation_hours
FROM humanresources.employee
GROUP BY jobtitle
ORDER BY AVG(vacationhours) DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- HAVING clause:
SELECT
	jobtitle,
	AVG(sickleavehours) AS average_sick_leavehour
From humanresources.employee
GROUP BY jobtitle
HAVING AVG(sickleavehours) >50; --condition

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3: From the customer table, where customer has a personid and a storeid, find the territory that has higher than 40 customers
-- A3:
SELECT
	territoryid,
	COUNT(*) AS number_of_customers
FROM sales.customer
WHERE personid IS NOT NULL
	AND storeid IS NOT NULL
GROUP BY territoryid
HAVING COUNT(*) > 40;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- OFFSET: Using the employee table find the other the other employees except the top 10 oldest employees.
SELECT *
FROM humanresources.employee
ORDER BY birthdate ASC;

SELECT *
FROM humanresources.employee
ORDER BY birthdate ASC
OFFSET 10; --removing first 10

-- Q4: From the salesperson table, where customer has a personid and a storeid, find the territory that has higher than 40 customers
-- A4:
SELECT 
	territoryid,
	COUNT(*) AS number_of_customers
FROM sales.customer
WHERE personid IS NOT NULL
	AND storeid IS NOT NULL
GROUP BY territoryid
HAVING COUNT(*) > 40
ORDER BY territoryid ASC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Best practise: When exploring a new table:
/*
	Why should we use the example mentioned below?
	1) We don't have to generate the entire table to understand what kind of information the table stores.
	2) Much faster using this compared to generating the entire multi-million row table
	3) So people don't think you are a noob
*/
SELECT *
FROM humanresources.employee
WHERE gender = 'M' -->remove female entries
--WHERE created_date = '2024-10-29' 
LIMIT 10;
-- saves money for companies

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOINS: INNER

-- Inner join to get product information along with its subcategory name and category name

SELECT *
FROM production.product;

SELECT *
FROM production.productsubcategory;

SELECT *
FROM production.productcategory;

SELECT
	product.productid,
	product.name AS product_name,
	productcategory.name AS categoryname,
	productsubcategory.name AS subcategoryname
FROM production.product AS product -- data after 'from' is the left table 
INNER JOIN production.productsubcategory AS productsubcategory -- right table
		ON product.productsubcategoryid = productsubcategory.productsubcategoryid
INNER JOIN production.productcategory AS productcategory 
		on productsubcategory.productcategoryid = productcategory.productcategoryid;

-- Let's create a base table in the humanresources schema, where we are able to get each employee's department history and department name

-- Employee table

SELECT *
FROM humanresources.employee;

-- Unique table or?


-- Employee Department History table

SELECT *
FROM humanresources.employeedepartmenthistory;

-- Unique table or?


-- Department table

SELECT *
FROM humanresources.department;



-- Let's find all the employee, their respecitve departments and the time they served there. Bonus if you can find out the duration in days each employee spent
-- in each department! Duration in days cannot be NULL.
SELECT 
	employee.businessentityid AS employeeid,
	department.name AS departmentname,
	employeedepartmenthistory.startdate AS startdate,
	employeedepartmenthistory.enddate AS enddate,
	EXTRACT(DAY FROM (employeedepartmenthistory.enddate - employeedepartmenthistory.startdate)) AS durationindays
FROM humanresources.employee AS employee
INNER JOIN humanresources.employeedepartmenthistory AS employeedepartmenthistory
	ON employee.businessentityid = employeedepartmenthistory.businessentityid
INNER JOIN humanresources.department AS department
	ON employeedepartmenthistory.departmentid = department.departmentid
WHERE employeedepartmenthistory.enddate IS NOT NULL;	


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- JOINS: LEFT

-- List all products along with their total sales quantities, including products that have never been sold. 
-- For products that have not been sold, display the sales quantity as zero.
-- Sort by total orders descending

SELECT *
FROM production.product;

SELECT *
FROM sales.salesorderdetail;

SELECT 
	product.productid AS productid,
	product.name AS productname,
	COALESCE(SUM(salesorderdetail.orderqty), 0) AS totalsalesquantity
FROM production.product
LEFT JOIN sales.salesorderdetail
	ON product.productid = salesorderdetail.productid
GROUP BY product.productid,
	product.name
ORDER BY totalsalesquantity DESC;

-- Q5: List all employees and their associated email addresses,  
-- display their full name and email address.
-- A5:	
SELECT *
FROM humanresources.employee;	

SELECT *
FROM person.person;

SELECT 
	employee.businessentityid AS employeeid,
	CONCAT(person.firstname, ' ', person.lastname) AS fullname,
	person.emailaddress AS emailaddress
FROM humanresources.employee AS employee
LEFT JOIN person.person AS person
	ON employee.businessentityid = person.businessentityid
ORDER BY employeeid ASC;

-- Retrieve a list of all individual customers id, firstname along with the total number of orders they have placed 
-- and the total amount they have spent, removing customers who have never placed an order. 

SELECT *
FROM person.person;

SELECT *
FROM sales.customer;

SELECT *
FROM sales.salesorderheader;

SELECT 
	customer.customerid AS customerid,
	person.firstname AS firstname,
	COUNT(salesorderheader.salesorderid) AS totalorders,
	SUM(salesorderheader.totaldue) AS totalamountspent
FROM sales.customer AS customer
LEFT JOIN person.person AS person
	ON customer.personid = person.businessentityid
LEFT JOIN sales.salesorderheader
	ON customer.customerid = salesorderheader.customerid
GROUP BY 
	customer.customerid,
	person.firstname
HAVING COUNT(salesorderheader.salesorderid) > 0
ORDER BY customerid ASC;

-- Q6: Can LEFT JOIN cause duplication? How?
-- A6: 
Yes. When there are multiple matching rows in the right table for a single row in the left table,
the LEFT JOIN will create a separate row in the result set for each match, leading to duplication of the left table's data.
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 JOINS: RIGHT
Write a query to retrieve all sales orders and their corresponding customers. If a sales order exists without an associated customer, 
include the sales order in the result.

SELECT 
    salesorderheader.salesorderid, 
    salesorderheader.orderdate, 
    customer.customerid, 
    customer.personid
FROM sales.salesorderheader 
RIGHT JOIN sales.customer 
	ON salesorderheader.customerid = customer.customerid;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOINS: FULL OUTER JOIN

-- Write a query to find all employees and their corresponding sales orders. If an employee doesn’t have any sales orders, 
-- still include them in the result, and if there are sales orders without an associated employee, include those as well.

SELECT 
    employee.businessentityid,
    salesorderheader.salesorderid
FROM humanresources.employee
FULL OUTER JOIN sales.salesorderheader
	ON employee.businessentityid = salesorderheader.salespersonid;

		
-- Write a query to retrieve a list of all employees and customers, and if either side doesn't have a FirstName, 

-- use the available value from the other side. Use FULL OUTER JOIN and COALESCE.

SELECT 
	COALESCE(employee.businessentityid, person.businessentityid),
	COALESCE(employee.firstname, person.firstname),
	COALESCE(employee.lastname, person.lastname)
FROM humanresources.employee
FULL OUTER JOIN person.person
	ON employee.businessentityid = person.businessentityid
ORDER BY COALESCE(employee.businessentityid, person.businessentityid);

						 
-- Write a query to list all employees along with their associated sales orders. Include employees who may not have any sales orders. 
-- Use the COALESCE function to handle NULL values in the SalesOrderID column.

SELECT
	employee.businessentityid AS employeeid,
	COALESCE(salesorderheader.salesorderid, 'No Sales Order') AS salesorderid
FROM sales.salesorderheader AS salesorderheader
FULL OUTER JOIN humanresources.employee AS employee
	ON salesorderheader.salespersonid = employee.businessentityid	
ORDER BY employee.employeeid;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- JOINS: CROSS JOINS

-- Explanation: A CROSS JOIN in SQL combines every row from the first table with every row from the second table. This type of join creates a Cartesian product, 
-- meaning that if the first table has 10 rows and the second table has 5 rows, the result will have 10 * 5 = 50 rows. 
-- A CROSS JOIN does not require any relationship or matching columns between the two tables.

-- Example: Good for arranging one person to meet multiple people

-- Write a query to generate all possible combinations of product categories and product models. Show the category name and the model name.

SELECT 
productcategory.name AS categoryname,
productmodel.name AS modelname
FROM production.productmodel AS productmodel
CROSS JOIN production.productcategory AS productcategory;

-- Each model name is matched to each category name

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UNION, stacking the tables on top of each other without having duplicates



-- Union them together segregating employee and customer

SELECT *
FROM person.person;

SELECT *
FROM sales.customer;

SELECT 
	businessentityid,
	firstname,
	lastname,
	'Employee' AS entitytype
FROM humanresources.employee
UNION
SELECT
	businessentityid,
	firstname,
	lastname,
	'Customer' AS entitytype
FROM person.person
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UNION ALL: EVERYTHING

-- Write a query to retrieve all sales orders and purchase orders, displaying the order ID and order date. 
-- Use UNION ALL to combine the sales and purchase order data, keeping all duplicates.

SELECT 
	salesorderid AS orderid, 
	orderdate
FROM sales.salesorderheader

UNION ALL

SELECT 
	purchaseorderid AS orderid, 
	orderdate
FROM purchasing.purchaseorderheader;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STRING FUNCTION
-- DATE handling, CONCAT()
SELECT 
	UPPER(firstname) AS uppercase_firstname,
	LOWER(lastname) AS lowercase_lastname,
	CONCAT(uppercase_firstname, ' ', lowercase_lastname) AS fullname
FROM sales.salesorderheader;

-- Getting parts of the date out
SELECT 
	EXTRACT(YEAR FROM orderdate) AS order_year,
	EXTRACT(MONTH FROM orderdate) AS order_month,
	EXTRACT(DAY FROM orderdate) AS order_day
FROM sales.salesorderheader;

-- DATETIME manipulations

SELECT
	EXTRACT(YEAR FROM orderdate) AS order_year,
	EXTRACT(MONTH FROM orderdate) AS order_month,
	EXTRACT(DAY FROM orderdate) AS order_day
FROM sales.salesorderheader
WHERE territoryid = 1
	AND EXTRACT(YEAR FROM orderdate) = 2011;

-- Use string functions to format employee names and email addresses
SELECT
UPPER(firstname) AS uppercase_firstname,
LOWER(lastname) AS lowercase_lastname,
CONCAT(uppercase_firstname, ' ', lowercase_lastname) AS fullname,
CONCAT(LOWER(firstname), '.', LOWER(lastname), '@company.com') AS formatted_email
FROM person.person AS person;

-- From the following table write a query in  SQL to find the  email addresses of employees and groups them by city. 
-- Return top ten rows.

SELECT 
	address.city, 
	firstname,
	lastname,
	CONCAT(LOWER(firstname), '.', LOWER(lastname), '@company.com') AS email_address	
FROM person.businessentityaddress AS businessentityaddress  
GROUP BY city
LIMIT 10;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--CASE FUNCTION: CASE WHEN THEN ELSE END

-- Categorize products based on their list price
SELECT 
	productid,
	name,
	listprice,
	CASE 
		WHEN listprice < 100 THEN 'Budget'
		WHEN listprice BETWEEN 100 AND 500 THEN 'Standard'
		ELSE 'Premium'
	END AS price_category
FROM production.product;

-- Write a query to categorize sales orders based on the total amount (TotalDue). If the total amount is less than 1000, categorize it as "Low", 
-- if it's between 1000 and 5000, categorize it as "Medium", and if it's greater than 5000, categorize it as "High".

SELECT 
    salesorderheader.salesorderid AS salesorderid, 
    salesorderheader.totaldue AS totaldue,
	CASE 
		WHEN salesorderheader.totaldue < 1000 THEN 'Low'
		WHEN salesorderheader.totaldue BETWEEN 1000 AND 5000 THEN 'Medium'
		ELSE 'High'
	END AS amount_category
FROM sales.salesorderheader AS salesorderheader;

-- Q7: Write a query to calculate bonuses for each employee. The bonus is calculated based on both their total sales and their length of employment:

-- If an employee has sales greater than 500,000 and has been employed for more than 5 years, they get a 15% bonus.
-- If their sales are greater than 500,000 but they’ve been employed for less than 5 years, they get a 10% bonus.
-- If their sales are between 100,000 and 500,000, they get a 5% bonus, regardless of years of service.
-- If their sales are less than 100,000, they get no bonus.

-- A7:
SELECT 
	employee.businessentityid AS employeeid,
	salesperson.salesytd AS totalsales,
	EXTRACT(YEAR FROM AGE(CURRENT_DATE, employee.hiredate)) AS years_of_service,
	CASE 
		WHEN salesperson.salesytd > 500000 AND years_of_service > 5 THEN salesperson.salesytd * 0.15
		WHEN salesperson.salesytd > 500000 AND years_of_service <= 5 THEN salesperson.salesytd * 0.10
		WHEN salesperson.salesytd BETWEEN 100000 AND 500000 THEN salesperson.salesytd * 0.05
		ELSE salesytd
	END AS bonus
FROM humanresources.employee AS employee
LEFT JOIN sales.salesperson AS salesperson
	ON employee.businessentityid = salesperson.businessentityid;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- If time permits:
-- Window Functions
-- AGGREGATE window functions
SUM() OVER (PARTITION BY ... ORDER BY ...)
COUNT() OVER (PARTITION BY ... ORDER BY ...)
AVG() OVER (PARTITION BY ... ORDER BY ...)

Ranking window functions
ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
RANK() OVER (PARTITION BY ... ORDER BY ...)
DENSE_RANK() OVER (PARTITION BY ... ORDER BY ...)

LAG / LEAD window functions
LAG(column_name, offset, default_value) OVER (PARTITION BY ... ORDER BY ...)
LEAD(column_name, offset, default_value) OVER (PARTITION BY ... ORDER BY ...

-- Explanation:
/*
A window function in SQL allows you to perform calculations across a set of table rows that are somehow related to the current row. 
Unlike regular aggregate functions (such as SUM, COUNT, AVG), window functions do not group the result into a single output. 
Instead, they return a value for every row while using a "window" of rows to perform the calculation.
*/

-- Let’s say we want to calculate the running total of sales for each salesperson, partitioned by their ID (so each salesperson gets their own total), 
-- and ordered by the order date.
SELECT 
	salesperson.businessentityid AS salespersonid,
	salesorderheader.orderdate AS orderdate,
	salesorderheader.totaldue AS order_total,
	SUM(salesorderheader.totaldue) OVER (
		PARTITION BY salesperson.businessentityid
		ORDER BY salesorderheader.orderdate
	) AS running_total
FROM sales.salesperson AS salesperson
INNER JOIN sales.salesorderheader AS salesorderheader
	ON salesperson.businessentityid = salesorderheader.salespersonid
ORDER BY salespersonid, orderdate;


-- Retrieving distinct active employee names along with salary statistics per department:
SELECT
	person.firstname AS firstname,
	person.lastname AS lastname,
	department.name AS departmentname,
	AVG(salaryhistory.salary) OVER (
		PARTITION BY department.departmentid
	) AS avg_department_salary,
	MAX(salaryhistory.salary) OVER (
		PARTITION BY department.departmentid
	) AS max_department_salary,
	MIN(salaryhistory.salary) OVER (
		PARTITION BY department.departmentid
	) AS min_department_salary
FROM humanresources.employee AS employee
INNER JOIN person.person AS person
	ON employee.businessentityid = person.businessentityid
INNER JOIN humanresources.employeedepartmenthistory AS employeedepartmenthistory
	ON employee.businessentityid = employeedepartmenthistory.businessentityid
INNER JOIN humanresources.department AS department
	ON employeedepartmenthistory.departmentid = department.departmentid
INNER JOIN humanresources.employeesalaryhistory AS salaryhistory
	ON employee.businessentityid = salaryhistory.businessentityid
WHERE employee.status = 'Active';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------