CREATE DATABASE sqlProject1;

USE sqlProject1;

CREATE TABLE retail_sales(
	transactions_id	INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id	INT,
    gender VARCHAR(15),
    age	INT,
    category VARCHAR(15),	
    quantiy	INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
) ;

SELECT * FROM retail_sales;

-- Handling NULL Values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

-- Data Cleaning 
SELECT * FROM retail_sales
WHERE
	sale_date IS NULL 
    OR sale_time IS NULL 
    OR customer_id IS NULL 
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
-- Data Exploration 

-- 1. How many sales we have? 
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- 2. How many unique customers do we have? 
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- 3. What are the distinct categories we have?
SELECT DISTINCT category FROM retail_sales;
    
-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05: 
SELECT * 
FROM 
	retail_sales
WHERE 
	sale_date = '2022-11-05';
     
SELECT COUNT(*) FROM retail_sales WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022: 
SELECT 	*
FROM
	retail_sales
WHERE
	category = 'Clothing'
AND
	quantiy >= 4
AND
	sale_date >= '2022-11=01' AND sale_date <= '2022-11-30';

-- finding the total count  
SELECT COUNT(*) FROM retail_sales 
WHERE
	category = 'Clothing'
AND
	quantiy >= 4
AND
	sale_date >= '2022-11=01' AND sale_date <= '2022-11-30';
    
-- or it can be solved by another method
SELECT
	*
FROM
	retail_sales
WHERE
	category = 'Clothing'
AND
	DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND
	quantiy >= 4;
    
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	category,
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	* 
FROM 
	retail_sales
WHERE 
	total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
    gender,
    COUNT(*) as total_transactions
FROM 
	retail_sales
GROUP BY 
	category, gender
ORDER BY 
	category;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT * 
FROM
	(
	SELECT 
		YEAR(sale_date) AS sale_year,
		MONTH(sale_date) AS sale_month,
		AVG(total_sale) AS avg_sale_of_month,
		RANK() OVER(
			PARTITION BY YEAR(sale_date)
			ORDER BY AVG(total_sale) DESC
		) AS sales_rank
	FROM
		retail_sales
	GROUP BY 1, 2
	) AS best
WHERE 
	sales_rank = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
	DISTINCT customer_id,
    SUM(total_sale) AS total_spent
FROM
	retail_sales
GROUP BY
	customer_id
ORDER BY 
	total_spent DESC
LIMIT 
	5;
    
-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) AS count_of_unique_customers
FROM retail_sales
GROUP BY 1;

-- 10. Write a SQL query to create each shift and number of orders. (Example Morning < 12, Afternoon between 12 and 17, Evening >= 17)
WITH 
	shift_wise_sales
AS
	(
	SELECT
		*,
		CASE
			WHEN 
				HOUR(sale_time) < 12 
			THEN 
				'Morning'
            
			WHEN 
				HOUR(sale_time) > 12 AND HOUR(sale_time) < 17
				-- HOUR(sale_time) BETWEEN 12 AND 17 
			THEN
				'Afternoon'
			ELSE
				'Evening'
		END AS shift
	FROM
		retail_sales
	)
    
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM
	shift_wise_sales
GROUP BY
	shift;