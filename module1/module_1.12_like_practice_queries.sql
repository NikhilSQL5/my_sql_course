-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.12: Pattern Matching -- LIKE
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. % wildcard -- starts with
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city LIKE 'Mum%';

-- ============================================================
-- 2. % wildcard -- contains
-- ============================================================
SELECT first_name, last_name, email
FROM customers
WHERE email LIKE '%gmail%';

-- ============================================================
-- 3. % wildcard -- ends with
-- ============================================================
SELECT first_name, last_name
FROM customers
WHERE first_name LIKE '%a';

-- ============================================================
-- 4. _ wildcard -- exact length / fixed position matching
-- Exactly 4 characters, starting with 'A'
-- ============================================================
SELECT first_name
FROM customers
WHERE first_name LIKE 'A___';

-- ============================================================
-- 5. NOT LIKE -- excluding a pattern
-- ============================================================
SELECT first_name, last_name, email
FROM customers
WHERE email NOT LIKE '%gmail%';

-- ============================================================
-- 6. Practical Session Tasks
-- ============================================================

-- Customers whose city starts with 'B'
SELECT first_name, last_name, city
FROM customers
WHERE city LIKE 'B%';

-- Customers whose first_name is exactly 5 characters long
SELECT first_name
FROM customers
WHERE first_name LIKE '_____';

-- ============================================================
-- End of Module 1.12 script.
-- ============================================================
