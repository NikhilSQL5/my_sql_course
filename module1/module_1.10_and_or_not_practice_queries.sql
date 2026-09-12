-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.10: Logical Filtering -- AND, OR, NOT
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. AND -- all conditions must be true
-- ============================================================
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE city = 'Mumbai' AND registration_date >= '2024-01-01';

-- ============================================================
-- 2. OR -- at least one condition must be true
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE city = 'Mumbai' OR city = 'Delhi';

-- ============================================================
-- 3. NOT -- negating a condition
-- ============================================================
SELECT first_name, last_name, city
FROM customers
WHERE NOT city = 'Mumbai';

-- Equivalent using != (Module 1.9) -- should return identical rows
SELECT first_name, last_name, city
FROM customers
WHERE city != 'Mumbai';

-- ============================================================
-- 4. The precedence trap -- WITHOUT parentheses
-- AND is evaluated before OR, which may not match intent
-- ============================================================
SELECT *
FROM customers
WHERE city = 'Mumbai' OR city = 'Delhi' AND registration_date >= '2024-01-10';

-- ============================================================
-- 5. The corrected version -- WITH parentheses
-- Explicitly groups (Mumbai OR Delhi), then applies the date filter
-- ============================================================
SELECT *
FROM customers
WHERE (city = 'Mumbai' OR city = 'Delhi') AND registration_date >= '2024-01-10';

-- Compare the row counts of query 4 vs query 5 above.

-- ============================================================
-- 6. Combining AND, OR, and NOT together
-- ============================================================
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE (city = 'Mumbai' OR city = 'Bengaluru') AND NOT registration_date < '2024-01-01';

-- ============================================================
-- 7. Practical Session Task -- Mumbai/Bengaluru customers
-- who have a phone number on file
-- ============================================================
SELECT *
FROM customers
WHERE (city = 'Mumbai' OR city = 'Bengaluru') AND phone IS NOT NULL;

-- ============================================================
-- End of Module 1.10 script.
-- ============================================================
