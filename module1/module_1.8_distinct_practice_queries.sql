-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.8: Removing Duplicates -- DISTINCT
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Baseline -- without DISTINCT (notice repeated cities)
-- ============================================================
SELECT city FROM customers;

-- ============================================================
-- 2. DISTINCT on a single column
-- ============================================================
SELECT DISTINCT city FROM customers;

SELECT DISTINCT category_name FROM categories;

-- ============================================================
-- 3. DISTINCT across multiple columns
-- Evaluates the FULL combination of columns together
-- ============================================================
SELECT DISTINCT city, first_name FROM customers;

-- ============================================================
-- 4. DISTINCT with a Primary Key included (rarely useful)
-- customer_id is already unique on every row, so this returns
-- the same row count as a plain SELECT with no DISTINCT.
-- ============================================================
SELECT DISTINCT customer_id, city FROM customers;

-- ============================================================
-- 5. Practical Session Task -- ShopEasy logistics question:
-- "Which cities do we currently have customers in?"
-- ============================================================
SELECT DISTINCT city AS "ShopEasy Customer Cities"
FROM customers;

-- ============================================================
-- End of Module 1.8 script.
-- ============================================================
