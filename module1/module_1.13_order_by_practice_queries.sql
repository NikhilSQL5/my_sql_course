-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.13: Sorting Data -- ORDER BY
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Single column sort -- ASC (default, A to Z)
-- ============================================================
SELECT first_name, last_name, city
FROM customers
ORDER BY first_name ASC;

-- ============================================================
-- 2. Single column sort -- DESC (Z to A)
-- ============================================================
SELECT first_name, last_name, city
FROM customers
ORDER BY first_name DESC;

-- ============================================================
-- 3. Sort by number -- customer_id newest registrations first
-- ============================================================
SELECT first_name, last_name, customer_id
FROM customers
ORDER BY customer_id DESC;

-- ============================================================
-- 4. Sort by date -- most recently registered first
-- ============================================================
SELECT first_name, last_name, registration_date
FROM customers
ORDER BY registration_date DESC;

-- ============================================================
-- 5. Multi-column sort
-- Primary: city A to Z
-- Secondary (tie-breaker): last_name A to Z within each city
-- ============================================================
SELECT first_name, last_name, city
FROM customers
ORDER BY city ASC, last_name ASC;

-- ============================================================
-- 6. Multi-column sort with mixed directions
-- Primary: city A to Z
-- Secondary: customer_id newest first within each city
-- ============================================================
SELECT first_name, last_name, city, customer_id
FROM customers
ORDER BY city ASC, customer_id DESC;

-- ============================================================
-- 7. Combining WHERE and ORDER BY
-- Strict clause order: WHERE must come before ORDER BY
-- ============================================================
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE city IN ('Mumbai', 'Delhi')
ORDER BY registration_date DESC;

-- ============================================================
-- 8. Sorting a nullable column -- observe NULL position in ASC
-- ============================================================
SELECT first_name, phone
FROM customers
ORDER BY phone ASC;
-- NULLs will appear at the TOP in ascending sort

SELECT first_name, phone
FROM customers
ORDER BY phone DESC;
-- NULLs will appear at the BOTTOM in descending sort

-- ============================================================
-- 9. Full professional query combining all skills so far:
-- SELECT specific columns with aliases
-- WHERE filter
-- ORDER BY sort
-- ============================================================
SELECT
    first_name          AS "First Name",
    last_name           AS "Last Name",
    city                AS "City",
    registration_date   AS "Joined On"
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Bengaluru')
ORDER BY city ASC, registration_date DESC;

-- ============================================================
-- End of Module 1.13 script.
-- ============================================================
