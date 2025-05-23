--Creating database
CREATE DATABASE sql_proj_p1;

--Creating table schema to load data
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


--DATA CLEANING
SELECT * 
FROM retail_sales
LIMIT 10;

--verifying the number of records
SELECT COUNT(*) 
FROM retail_sales;

--check Null values
SELECT * 
FROM retail_sales rs
WHERE
	sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR price_per_unit IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;

--handling NULL values
SELECT gender,AVG(age) 
FROM retail_sales
GROUP BY gender;

UPDATE retail_sales
SET age = 41 
WHERE age IS NULL;

DELETE FROM retail_sales
WHERE quantity IS NULL;

--DATA EXPLORATION

--How many sales were made?
SELECT COUNT(*) AS total_sales 
FROM retail_sales;

--How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS No_of_Customers 
FROM retail_sales;

--How many unique categories do we have?
SELECT DISTINCT category AS categories 
FROM retail_sales;

--1) Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'

--3) Write a SQL query to calculate the total sales (total_sale) for each category:
SELECT category,SUM(total_sale) AS total_sale,COUNT(*) AS no_of_sales FROM retail_sales
GROUP BY category;

--4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
SELECT ROUND(AVG(age),2) AS avg_age 
FROM retail_sales
WHERE category = 'Beauty';

--5) Write a SQL query to find all transactions where the total_sale is greater than 1000:
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

--6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:
SELECT gender,category,COUNT(transactions_id) 
FROM retail_sales
GROUP BY gender,category;

--7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT month,year,rank
FROM (
SELECT EXTRACT(MONTH FROM sale_date) AS month, EXTRACT(YEAR FROM sale_date) AS year, AVG(total_sale),
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE t1.rank = 1;

--8) Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT customer_id,SUM(total_sale) AS total_sales 
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9) Write a SQL query to find the number of unique customers who purchased items from each category:
SELECT category, COUNT(DISTINCT customer_id) AS no_of_customers 
FROM retail_sales
GROUP BY category;

--10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT (CASE 
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
	END) AS shift, COUNT(transactions_id)
FROM retail_sales
GROUP by shift;

