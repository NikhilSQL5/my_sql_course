-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.11: Range & List Filtering -- BETWEEN, IN
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. BETWEEN -- numeric range (inclusive both ends)
-- ============================================================
SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id BETWEEN 4 AND 8;

-- Equivalent using AND (Module 1.10) -- should return identical rows
SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id >= 4 AND customer_id <= 8;

-- ============================================================
-- 2. BETWEEN -- date range
-- ============================================================
SELECT first_name, last_name, registration_date
FROM customers
WHERE registration_date BETWEEN '2024-01-15' AND '2024-01-17';

-- ============================================================
-- 3. NOT BETWEEN
-- ============================================================
SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id NOT BETWEEN 4 AND 8;

-- ============================================================
-- 4. IN -- list of text values
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Bengaluru');

-- Equivalent using OR (Module 1.10) -- should return identical rows
SELECT first_name, last_name, city
FROM customers
WHERE city = 'Mumbai' OR city = 'Delhi' OR city = 'Bengaluru';

-- ============================================================
-- 5. IN -- list of numeric values
-- ============================================================
SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id IN (1, 4, 7, 10);

-- ============================================================
-- 6. NOT IN
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city NOT IN ('Mumbai', 'Delhi');

-- ============================================================
-- 7. Combining BETWEEN, IN, and AND
-- ============================================================
SELECT first_name, last_name, city, customer_id
FROM customers
WHERE city IN ('Mumbai', 'Bengaluru')
  AND customer_id BETWEEN 1 AND 10;

-- ============================================================
-- 8. Practical Session Task -- combined business query
-- ============================================================
SELECT first_name, last_name, city, customer_id
FROM customers
WHERE city IN ('Mumbai', 'Delhi')
  AND customer_id BETWEEN 1 AND 8;

-- ============================================================
-- End of Module 1.11 script.
-- ============================================================
