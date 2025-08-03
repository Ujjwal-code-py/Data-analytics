# 🛒 Zepto Inventory Data Analysis (SQL)

## 📌 Project Overview

This project simulates the day-to-day work of a data analyst in the e-commerce or retail industry. Using SQL, we analyze and clean a messy real-world inventory dataset, uncover valuable insights, and prepare it for business reporting. The workflow mirrors what analysts typically do with inventory, pricing, and stock data in companies like Zepto, Blinkit, or BigBasket.

### ✅ Key Objectives:
- Set up a real-world e-commerce inventory database.
- Perform exploratory data analysis (EDA) using SQL.
- Clean and transform raw inventory data (handle nulls, convert pricing).
- Extract meaningful business insights to support inventory decisions.

---

## 📁 Dataset Overview

The dataset was sourced from [Kaggle](https://www.kaggle.com/) and represents product listings scraped from Zepto. Each row corresponds to a Stock Keeping Unit (SKU) — the same product may appear multiple times with different sizes, prices, and offers.

### 🧾 Columns:
| Column Name             | Description                                           |
|-------------------------|-------------------------------------------------------|
| `sku_id`                | Unique ID for each product entry                      |
| `name`                  | Product name as shown in the app                     |
| `category`              | Product category (e.g., Fruits, Snacks)              |
| `mrp`                   | Maximum Retail Price (in ₹)                          |
| `discountPercent`       | Discount applied to MRP                              |
| `discountedSellingPrice`| Final selling price after discount (in ₹)           |
| `availableQuantity`     | Units available in inventory                         |
| `weightInGms`           | Product weight in grams                              |
| `outOfStock`            | Boolean indicating if item is out of stock           |
| `quantity`              | Number of units per package                          |

---

## 🔧 Project Workflow

### 1️⃣ Database & Table Creation



``sql
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
``


### 1️⃣ Database & Table Creation
You can import the CSV using pgAdmin or run the following command:


``
\copy zepto(category,name,mrp,discountPercent,availableQuantity,
            discountedSellingPrice,weightInGms,outOfStock,quantity)
FROM 'data/zepto_v2.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'UTF8');
``



### 3️⃣ Data Exploration
Counted total records

Previewed data samples

Identified null values

Listed distinct product categories

Compared in-stock vs out-of-stock

Detected duplicate product listings (SKU-level)

### 4️⃣ Data Cleaning
Removed rows with mrp or discountedSellingPrice = 0

Converted prices from paise to rupees (divided by 100)

Handled NULL and invalid entries

### 5️⃣ Business Insights (SQL)
Top 10 best value products (by discount %)

High-MRP products currently out of stock

Estimated revenue per product category

Products priced above ₹500 with low discounts

Categories with highest average discounts

Value-for-money products by ₹/gram

Product groups: Low, Medium, Bulk (by weight)

Total inventory weight per category
### How  to use  this
🔄 Clone the Repository:


`
git clone https://github.com/Ujjwal-code-py/Data-analytics.git
cd Data-analytics/Zepto\ Inventory\ Data\ analysis\ \(SQL\)
`

💻 Run in PostgreSQL
Create a new database (e.g., zepto_inventory)

Open zepto_SQL_data_analysis.sql in pgAdmin or VS Code

Run the table creation and SQL analysis queries

Import the dataset using the \copy command

