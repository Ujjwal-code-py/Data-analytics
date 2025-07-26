 SQL EDA Project:

 This project performs a complete **Exploratory Data Analysis (EDA)** using **SQL Server** on a simulated data warehouse. It involves setting up a database, creating schemas, 
 importing CSV data, and generating detailed analytical insights into customer behavior, product performance, and sales trends.

 ## 📌 Project Overview

- **Database:** `DataWarehouseAnalytics`
- **Schema:** `gold`
- **Data Sources:** CSV files (Customers, Products, Sales)
- **Objective:** Analyze customer demographics, product performance, and sales trends using SQL.

## 🛠️ How to Set Up the Database
You can create the `DataWarehouseAnalytics` database in **two ways**:

### ✅ Option 1: Run the SQL Script (Recommended for First-Time Setup)
Make sure you're connected to the `master` database before running the script.


📄 **Script:**


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

⚠️ Ensure correct file paths and backup before execution.

♻️ Option 2: Restore the Database from Backup
Alternatively, you can restore the database directly from a .bak file.

File available in dataset folder use this file from that

📦 Backup File: DataWarehouseAnalytics.bak 

🔧 To restore in SSMS:

Open SQL Server Management Studio

Right-click on Databases > Restore Database

Choose Device and select the .bak file

Click OK to restore the database


## 🔍 6-Step Basic EDA Process

Once the database is set up, perform the following **EDA phases** using SQL:

### 1️⃣ Database Exploration

Understand the structure and metadata of the database.

**Questions Explored:**
- What tables and schemas exist?
- What are the column names and data types in each table?
- Are primary keys and foreign keys defined correctly?

---

### 2️⃣ Dimension Exploration

Explore the descriptive dimensions of customers and products.

**Questions Explored:**
- What countries do customers belong to?
- What are the different product categories and subcategories?
- How many unique customers and products exist?
- What are the demographics (gender, marital status) of customers?

---

### 3️⃣ Data (Date) Exploration

Analyze the date-related patterns in the sales data.

**Questions Explored:**
- What is the time range of sales data?
- How many months or years of sales are available?
- Who is the youngest and oldest customer?
- How is customer age distributed?

---

### 4️⃣ Measure Exploration

Perform summary statistics on numeric and transactional columns.

**Questions Explored:**
- What is the total sales amount?
- What is the total quantity of items sold?
- What is the average selling price?
- How many unique orders have been placed?
- How many customers have placed orders?

---

### 5️⃣ Magnitude Analysis

Group and compare metrics across categories for deeper insight.

**Questions Explored:**
- Which country has the most customers?
- Which product categories are most popular?
- What is the average cost per product category?
- Which categories generate the most revenue?
- How are sales distributed across different countries?

---

### 6️⃣ Ranking Analysis

Identify the top and bottom performers among products and customers.

**Questions Explored:**
- What are the top 5 products by revenue?
- Which product subcategories perform the best or worst?
- Who are the top 10 customers by total purchase amount?
- Which customers placed the fewest number of orders?

---

## 👨‍💻 Author

**Ujjwal Gupta**  
BTech IT, Walchand Institute of Technology  
GitHub: [@Ujjwal-code-py](https://github.com/Ujjwal-code-py)

---

## 📃 License

This project is for **educational and analytical use only**. Data and scripts may be reused with proper attribution.
