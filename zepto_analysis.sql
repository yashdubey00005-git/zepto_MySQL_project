CREATE DATABASE zepto_db;
USE zepto_db;

CREATE TABLE zepto(
SKU_id INT PRIMARY KEY AUTO_INCREMENT ,
Category VARCHAR (120),
name VARCHAR (150),
mrp DECIMAL(8,2),
discountPercent DECIMAL(5,2),
availableQuantity INT,
discountedSellingPrice DECIMAL(8,2),
weightInGms INT,
outOfStock Boolean,
quantity INT);

SELECT * FROM zepto;

-- different product categories
SELECT DISTINCT Category
FROM zepto
ORDER BY Category;

-- products in stocks v/s out of stocks
SELECT 
    SUM(outOfStock = 0) AS products_in_stock,
    SUM(outOfStock = 1) AS products_out_of_stock
FROM zepto;

-- prooduct name persent multiple times

SELECT name, COUNT(SKU_id) AS "Number Of SKU's"
FROM zepto 
GROUP BY name
HAVING COUNT(SKU_id) > 1
ORDER BY COUNT(SKU_id) DESC;

-- data cleaning
-- products with price = 0

SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0; -- Got an error and off the SQL_SAFE_UPDATE mode to delete the data

SET SQL_SAFE_UPDATES = 0;

-- CONVERT PAISE TO RUPPEES

UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice 
FROM zepto;

-- Q1) Found top 10 best-value products based on discount percentage

SELECT DISTINCT name, mrp, discountPercent
FROM zepto 
ORDER BY discountPercent DESC
LIMIT 10;


-- Q2) Identified high-MRP products that are currently out of stock

SELECT name, mrp
FROM zepto
WHERE outOfStock = TRUE
AND mrp > 300        -- let's assume more than 300rs MRP considered as high-MRP product
ORDER BY mrp DESC;

-- Q3) Estimated potential revenue for each product category

SELECT Category AS Product_Category,SUM(discountedSellingPrice*availableQuantity) AS Total_Revenue
FROM zepto
GROUP BY Product_Category
ORDER BY Total_Revenue;


-- Q4) Filtered expensive products (MRP > ₹500) with minimal discount

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5) Ranked top 5 categories offering highest average discounts

SELECT Category, AVG(discountPercent) AS Average_discount
FROM zepto
GROUP BY Category
ORDER BY Average_discount DESC
LIMIT 5;


-- Q6) Calculated price per gram to identify value-for-money products

SELECT name AS value_for_money_products, SUM(discountedSellingPrice/weightInGms) AS price_per_gram
FROM zepto
GROUP BY value_for_money_products
ORDER BY price_per_gram;

-- Q7) Grouped products based on weight into Low, Medium, and Bulk categories

SELECT DISTINCT name, weightInGMS,
  CASE WHEN weightInGMS < 1000 THEN "LOW"
  WHEN weightInGMS <5000 THEN "Medium"
  ELSE "Bulk"
END AS weight_categoory
FROM zepto;

-- Q8) Measured total inventory weight per product category

SELECT Category AS Product_Category, SUM(availableQuantity*weightInGMS) AS Total_Inventory_Weight
FROM zepto
GROUP BY Product_Category
Order By Total_Inventory_Weight;