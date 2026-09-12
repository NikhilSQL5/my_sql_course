-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.9: Filtering Data -- WHERE
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Equal to (=) -- text filtering
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city = 'Mumbai';

-- ============================================================
-- 2. Not equal to (!= / <>)
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city != 'Mumbai';

SELECT first_name, last_name, city
FROM customers
WHERE city <> 'Mumbai';

-- ============================================================
-- 3. Numeric comparisons (>, <, >=, <=)
-- ============================================================
SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id > 6;

SELECT first_name, last_name, customer_id
FROM customers
WHERE customer_id <= 8;

-- ============================================================
-- 4. Date filtering -- always 'YYYY-MM-DD'
-- ============================================================
SELECT first_name, last_name, registration_date
FROM customers
WHERE registration_date >= '2024-01-01';

SELECT first_name, last_name, registration_date
FROM customers
WHERE registration_date < '2024-01-17';

-- ============================================================
-- 5. The NULL trap -- demonstration
-- ============================================================
-- INCORRECT: this returns ZERO rows even if NULL phones exist
SELECT * FROM customers 
WHERE phone = NULL;

-- CORRECT: use IS NULL instead
SELECT * FROM customers 
WHERE phone IS NULL;

-- CORRECT: find customers who DO have a phone number
SELECT * FROM customers
WHERE phone IS NOT NULL;

-- ============================================================
-- 6. Practical Session Task -- combining SELECT, alias, WHERE
-- ============================================================
SELECT
    first_name AS "First Name",
    last_name  AS "Last Name",
    city       AS "City"
FROM customers
WHERE city = 'Bengaluru';

-- ============================================================
-- End of Module 1.9 script.
-- ============================================================
