drop table  if exists zepto;
create Table zepto
(
sku_id Serial Primary key,
category varchar(120),
name varchar(120) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity Integer,
discountedSellingPrice numeric(8,2),
weightInGms Integer,
outOfStock Boolean,
quantity integer
);

-- Data Exploration
-- count rows

select count(*) from zepto;

-- sample data
select * from zepto limit 10;

-- null values
select * from zepto 
where category isnull
or
name isnull
or
mrp isnull
or 
discountpercent isnull
or
availablequantity isnull
or
discountedsellingprice isnull
or
weightInGms isnull
or
outofstock isnull
or
quantity isnull

-- another way
WITH rows_with_any_null AS (
  SELECT *
  FROM zepto
  WHERE category IS NULL
     OR name IS NULL
     OR mrp IS NULL
     OR discountpercent IS NULL
     OR availablequantity IS NULL
     OR discountedsellingprice IS NULL
     OR weightInGms IS NULL
     OR outofstock IS NULL
     OR quantity IS NULL
)
SELECT count(*)
FROM rows_with_any_null;

-- Distinct categories
select distinct(category) from zepto order by category;

-- product in stocks vs out of stocks

select outofstock,count(sku_id) from zepto group by outofstock;

-- product names present multiple times
select name,count(sku_id) as "Number of skus" from zepto 
group by name
having count(sku_id) >1
order by count(sku_id) desc;


-- Data cleaning
-- product with price 0
select  * from zepto
where mrp=0 or discountedsellingprice=0;

delete from zepto
where mrp=0;

-- convert paise into rupees
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;

select  mrp,
discountedsellingprice from zepto;

-- data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountedsellingprice from zepto
order by discountedsellingprice desc limit 10;


--Q2.What are the Products with High MRP but Out of Stock
select distinct name,mrp,outofstock from zepto
where outofstock= True 
order by mrp desc limit 1


--Q3.Calculate Estimated Revenue for each category
select  category ,sum(discountedsellingprice * availablequantity) as total_ravenue
from zepto group by category
order by total_ravenue desc


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select DISTINCT name, mrp, discountPercent from zepto
where mrp>500 and discountpercent>10
order by mrp desc,discountpercent desc;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category ,ROUND(AVG(discountPercent),2) AS avg_discount
from zepto
group by category
order by avg_discount desc limit 5

-- Q6. Find the price per gram for products above 100g and sort by best value.
select  DISTINCT name, weightInGms,discountedsellingprice,
Round(discountedsellingprice/weightInGms,2) as price_gm from zepto
where weightInGms >=100
order by price_gm desc

--Q7.Group the products into categories like Low, Medium, Bulk.
select  DISTINCT name, weightInGms,
case When weightInGms<1000 then 'low'
	 when weightInGms<5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;


--Q8.What is the Total Inventory Weight Per Category 
select category,
sum(weightInGms*availableQuantity) as Total_weight
from zepto
group by category
order by Total_weight desc;

