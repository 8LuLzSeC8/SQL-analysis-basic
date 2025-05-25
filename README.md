# Retail Sales Analysis SQL Project


## Project Overview

**Project Title**: Retail Sales Analysis 
**Database**: `sql_proj_1`

This project is designed to demonstrate SQL skills and techniques typically used to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering basic business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer basic business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_proj_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_proj_p1;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
--How many sales were made?
SELECT COUNT(*) AS total_sales 
FROM retail_sales;

--How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS No_of_Customers 
FROM retail_sales;

--How many unique categories do we have?
SELECT DISTINCT category AS categories 
FROM retail_sales;
```
A total of 1197 transctions are present in the data. It has 155 unique customers and 3 sale categories named Electronics, Clothing, Beauty.

```sql
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

--replacing columns have Null age values with a mean value of age column from the data set
SELECT gender,AVG(age) 
FROM retail_sales
GROUP BY gender;

UPDATE retail_sales
SET age = 41 
WHERE age IS NULL;

--Deleting rows with many columns empty
DELETE FROM retail_sales
WHERE quantity IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
A total of 11 transactions were performed on 2022-11-05.

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, SUM(total_sale) AS total_sale, COUNT(*) AS no_of_sales 
FROM retail_sales
GROUP BY category;
```
The Clothing category has the highest number of sales of 701 while the Electronics category has the highest revenue generated of 313810.

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT ROUND(AVG(age),2) AS avg_age 
FROM retail_sales
WHERE category = 'Beauty';
```
The average age of customers who bought items from Beauty category is 40.

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;
```
More than 300 sales were made with sale value more then 1000.

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT gender, category, COUNT(transactions_id) 
FROM retail_sales
GROUP BY gender,category;
```
Clothing is the popular category with highest transactions among both Male and Female.

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT month,year,rank
FROM (
SELECT EXTRACT(MONTH FROM sale_date) AS month, EXTRACT(YEAR FROM sale_date) AS year, AVG(total_sale),
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE t1.rank = 1;
```
In the year 2022, The month  of July has the highest average sale value and for the year 2023 was February.

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id, SUM(total_sale) AS total_sales 
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```
The highest total sales value made by a single customer is 38440.

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category, COUNT(DISTINCT customer_id) AS no_of_customers 
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT (CASE 
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN EXTRACT(HOUR FROM sale_time) > 17 THEN 'Evening'
	END) AS shift, COUNT(transactions_id)
FROM retail_sales
GROUP by shift;
```
The evening shift has the highest number of transactions made across two years with 1062 transactions.

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.


## Conclusion

The SQL analysis of the retail sales data revealed valuable insights into customer behavior, product performance, and sales trends. The store shows a diversified customer base with varying preferences across categories. Time-of-day and month-based trends indicate that targeted promotions could improve sales further. The identification of top customers and high-value transactions suggests potential for personalized marketing strategies.



