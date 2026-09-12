-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.14: Limiting Results -- LIMIT & OFFSET
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. LIMIT without ORDER BY (non-deterministic -- for demo only)
-- ============================================================
SELECT first_name, last_name, city
FROM customers
LIMIT 5;

-- ============================================================
-- 2. LIMIT with ORDER BY -- deterministic and meaningful
-- ============================================================
SELECT first_name, last_name, city
FROM customers
ORDER BY customer_id ASC
LIMIT 5;

-- ============================================================
-- 3. Top-N pattern -- 3 most recently registered customers
-- ============================================================
SELECT first_name, last_name, registration_date
FROM customers
ORDER BY registration_date DESC
LIMIT 3;

-- ============================================================
-- 4. Bottom-N pattern -- 5 earliest registered customers
-- ============================================================
SELECT first_name, last_name, registration_date
FROM customers
ORDER BY registration_date ASC
LIMIT 5;

-- ============================================================
-- 5. LIMIT with WHERE -- most recently registered Mumbai customer
-- ============================================================
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE city = 'Mumbai'
ORDER BY registration_date DESC
LIMIT 1;

-- ============================================================
-- 6. Pagination using OFFSET
-- Page size = 5 rows, sorted by customer_id
-- ============================================================

-- Page 1: rows 1-5 (skip 0)
SELECT first_name, last_name, customer_id
FROM customers
ORDER BY customer_id ASC
LIMIT 5 OFFSET 0;

-- Page 2: rows 6-10 (skip 5)
SELECT first_name, last_name, customer_id
FROM customers
ORDER BY customer_id ASC
LIMIT 5 OFFSET 5;

-- Page 3: rows 11-15 (skip 10)
-- With only 12 customers this returns the last 2 rows -- no error
SELECT first_name, last_name, customer_id
FROM customers
ORDER BY customer_id ASC
LIMIT 5 OFFSET 10;

-- ============================================================
-- 7. LIMIT beyond available rows -- no error, just returns all
-- ============================================================
SELECT first_name, last_name
FROM customers
ORDER BY customer_id ASC
LIMIT 100;

-- ============================================================
-- 8. Full professional query (all Beginner clauses combined)
-- SELECT with aliases + WHERE + ORDER BY + LIMIT
-- ============================================================
SELECT
    first_name        AS "First Name",
    last_name         AS "Last Name",
    city              AS "City",
    registration_date AS "Joined On"
FROM customers
WHERE city IN ('Mumbai', 'Delhi', 'Bengaluru')
ORDER BY registration_date DESC
LIMIT 5;

-- ============================================================
-- End of Module 1.14 script.
-- Full Beginner SELECT structure: SELECT > FROM > WHERE > ORDER BY > LIMIT
-- ============================================================
