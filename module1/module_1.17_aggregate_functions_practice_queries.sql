-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.17: Introduction to Aggregate Functions
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Run Module_1.17_Expand_ShopEasy_Dataset.sql first
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. COUNT(*) vs COUNT(column)
-- ============================================================

-- Total customers (all rows)
SELECT COUNT(*) AS total_customers
FROM customers;

-- Customers with a phone number on file (NULLs excluded)
SELECT COUNT(phone) AS customers_with_phone
FROM customers;

-- Total products
SELECT COUNT(*) AS total_products
FROM products;

-- Total orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- ============================================================
-- 2. SUM()
-- ============================================================

-- Total value of all products in the catalogue
SELECT SUM(price) AS total_catalogue_value
FROM products;

-- Total revenue from all orders
SELECT SUM(total_amount) AS total_revenue
FROM orders;

-- ============================================================
-- 3. AVG()
-- ============================================================

-- Average product price
SELECT AVG(price) AS avg_product_price
FROM products;

-- Average order value
SELECT AVG(total_amount) AS avg_order_value
FROM orders;

-- ============================================================
-- 4. MIN() and MAX()
-- ============================================================

-- Cheapest and most expensive products
SELECT
    MIN(price) AS cheapest_product,
    MAX(price) AS most_expensive_product
FROM products;

-- Earliest and most recent order dates
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS latest_order_date
FROM orders;

select * from orders;

-- Smallest and largest order amounts
SELECT
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order
FROM orders;

-- ============================================================
-- 5. Multiple aggregates in one query
-- ============================================================

-- Full order business summary
SELECT
    COUNT(*)          AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount) AS largest_order
FROM orders;

-- Full product catalogue summary
SELECT
    COUNT(*)   AS total_products,
    SUM(price) AS total_catalogue_value,
    AVG(price) AS avg_price,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM products;

-- ============================================================
-- 6. Aggregate with WHERE -- targeted summaries
-- ============================================================

-- Total revenue from Delivered orders only
SELECT SUM(total_amount) AS delivered_revenue
FROM orders
WHERE status = 'Delivered';

-- Count of Pending orders and their combined value
SELECT
    COUNT(*) AS pending_orders,
    SUM(total_amount) AS pending_value
FROM orders
WHERE status = 'Pending';

-- Orders placed in January 2024 only
SELECT
    COUNT(*) AS jan_order_count,
    SUM(total_amount) AS jan_revenue
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';

-- Average price of products above 1000
SELECT AVG(price) AS avg_price_over_1000
FROM products
WHERE price > 1000;

-- Average price of Electronics products (category_id = 1)
SELECT AVG(price) AS avg_electronics_price
FROM products
WHERE category_id = 1;

-- ============================================================
-- End of Module 1.17 practice queries.
-- ============================================================
