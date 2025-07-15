/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

USE DataWarehouseAnalytics;
GO

-- Create Schemas

CREATE SCHEMA gold;
GO

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
);
GO

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date 
);
GO

CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int 
);
GO

TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\ug984\Downloads\sql-data-analytics-project\datasets\csv-files\gold.dim_customers.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\ug984\Downloads\sql-data-analytics-project\datasets\csv-files\gold.dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\ug984\Downloads\sql-data-analytics-project\datasets\csv-files\gold.fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

select distinct quantity from gold.fact_sales

select  Avg(DATEDIFF(YEAR,birthdate,GETDATE())) as avg_age from gold.dim_customers 
--DATEDIFF(YEAR, birthdate, GETDATE()) - Calculates the difference in years between the birthdate column and the current date (i.e., it gives the approximate age of each customer).
--DATEDIFF(YEAR, birthdate, GETDATE()) – Calculates the number of years between the birthdate and today (i.e., the age of each customer).
--

Select distinct(customer_id) from gold.dim_customers


select distinct birthdate from gold.dim_customers


-- Database Exploration


-- Explore All objects in data base

Select * from INFORMATION_SCHEMA.TABLES

-- Explore all columns in the data database
Select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='dim_customers';

-- Dimension Exploration
-- Explore All Contries Our Customers come From

select Distinct(country) from gold.dim_customers

-- Explore all Categories "The major division"
select Distinct category, Subcategory,product_name from gold.dim_products
order by 1,2,3


-- Date Exploration
 
 -- Find the date of the first and last order
Select 
min(order_date) as First_order_date,
max(order_date) as Last_order_date
from gold.fact_sales

-- How many years of sales are available

Select 
min(order_date) as First_order_date,
max(order_date) as Last_order_date,
DATEDIFF(month,min(order_date),max(order_date)) as order_range_months
from gold.fact_sales

-- Find the Youngest and the oldest customer
Select
Min(birthdate) as oldest_birthdate,
DATEDIFF(year,min(birthdate),Getdate()) as oldest_age,
Max(birthdate) as youngest_birthdate,
DATEDIFF(year,max(birthdate),Getdate()) as youngest_age
from gold.dim_customers



-- Measure Exploration
-- Find the Total Sales
Select Sum(sales_amount) as Total_sales from gold.fact_sales
-- Find How many items are sold

Select Sum(quantity) as Total_quantity from gold.fact_sales

-- find the avg selling price
Select avg(price) as avg_price from gold.fact_sales

-- Find the Total number of orders

select count(order_number) as total_orders from gold.fact_sales
select count(distinct(order_number)) as total_orders from gold.fact_sales

-- find the total number of products
select count(product_key) as total_product from gold.dim_products
select count(distinct(product_key)) as total_product from gold.dim_products

-- Find the Total number of customers
select count(distinct(customer_key)) as total_customers from gold.dim_customers

-- find the total number of customers that has placed an order

select count(distinct(customer_key)) as total_customers_place_order from gold.fact_sales


-- generate a report that shows all key metrics of the business

Select 'Total_sales' as measure_name, Sum(sales_amount) as Measure_value from gold.fact_sales
union all
Select 'Total_Quantity' as measure_name, Sum(quantity) as Measure_value from gold.fact_sales
union all
Select 'Average Price' as measure_name, avg(Price) as Measure_value from gold.fact_sales
union all
Select 'Total nr. Orders' as measure_name, count(distinct order_number) as Measure_value from gold.fact_sales
union all
Select 'Total nr. Products' as measure_name, count(product_name) as Measure_value from gold.dim_products
union all
Select 'Total nr. Customers' as measure_name, count(distinct customer_key) as Measure_value from gold.dim_customers



--Magnitude Analysis

-- Find Total customers by countries
select
country,
count(customer_key) as total_customers
from gold.dim_customers
group by country
order by total_customers Desc


-- Find total customers by gender 
select
gender,
count(customer_key) as total_customers
from gold.dim_customers
group by gender
order by total_customers Desc
-- Find Total Products by category
select 
category,
count(product_name) as total_product
from gold.dim_products
group by category
order by total_product Desc

-- What is the Average Costs in Each category
select 
category,
avg(cost) as avg_cost
from gold.dim_products
group by category
order by avg_cost Desc
-- What is total revenue generated by each cateegory
Select
p.category,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.category
order by total_revenue desc
-- What is total revenue generated by each customer
select 
c.customer_key,
c.first_name,
c.last_name,
sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key =f.customer_key
group by 
c.customer_key,
c.first_name,
c.last_name
order by total_revenue desc

-- What is the distribution of sold items acrosss countries
select 
c.country,
sum(f.quantity) as total_sold_items
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key =f.customer_key
group by 
c.country
order by total_sold_items desc

-- Ranking Analysis

-- which 5 product generate the highest revenue
Select top 5
p.product_name,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.product_name
order by total_revenue desc 

-- using window function
select *
from (
	Select
	p.product_name,
	sum(f.sales_amount) total_revenue,
	ROW_NUMBER() over (order by sum(f.sales_amount) Desc) as rank_products
	from gold.fact_sales f
	left join gold.dim_products p
	on p.product_key=f.product_key
	group by p.product_name)t
	where rank_products <=5
	 

-- which are the 5 worst performing product in terms of revenue
Select top 5
p.product_name,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.product_name
order by total_revenue asc

-- which 5 product subcategory generate the highest revenue
Select top 5
p.subcategory,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.subcategory
order by total_revenue desc 

-- find top 10 customer who have generated the highest revenue 
select top 10
c.customer_key,
c.first_name,
c.last_name,
sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key =f.customer_key
group by 
c.customer_key,
c.first_name,
c.last_name
order by total_revenue desc

-- the 3 customer with fewest orders placed
select top 3
c.customer_key,
c.first_name,
c.last_name,
count(distinct order_number)as total_orders
from gold.fact_sales f
left join gold.dim_customers c
on c.customer_key =f.customer_key
group by 
c.customer_key,
c.first_name,
c.last_name
order by total_orders asc