-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.5: Combining Result Sets -- UNION & UNION ALL
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. UNION -- unique locations from customers + employees
-- ============================================================
SELECT city AS location FROM customers
UNION
SELECT region AS location FROM employees
ORDER BY location ASC;

-- ============================================================
-- 2. UNION ALL -- same query but keeping duplicates
-- ============================================================
SELECT city AS location FROM customers
UNION ALL
SELECT region AS location FROM employees
ORDER BY location ASC;

-- Compare row counts: UNION fewer rows (deduped), UNION ALL more
SELECT COUNT(*) AS union_rows FROM (
    SELECT city AS location FROM customers
    UNION
    SELECT region AS location FROM employees
) AS u;

SELECT COUNT(*) AS union_all_rows FROM (
    SELECT city AS location FROM customers
    UNION ALL
    SELECT region AS location FROM employees
) AS ua;

-- ============================================================
-- 3. Source label column pattern
-- Combined customer + employee directory
-- ============================================================
SELECT
    CONCAT(first_name, ' ', last_name) AS name,
    city AS location,
    'Customer' AS person_type
FROM customers

UNION ALL

SELECT
    full_name  AS name,
    region     AS location,
    'Employee' AS person_type
FROM employees

ORDER BY location ASC, name ASC;

-- ============================================================
-- 4. Period comparison using UNION ALL
-- First half vs second half of January 2024
-- ============================================================
SELECT
    'First Half (Jan 1-13)' AS period,
    COUNT(*)                AS total_orders,
    SUM(total_amount)       AS total_revenue,
    AVG(total_amount)       AS avg_order_value
FROM orders
WHERE order_date <= '2024-01-13'

UNION ALL

SELECT
    'Second Half (Jan 14-27)' AS period,
    COUNT(*)                  AS total_orders,
    SUM(total_amount)         AS total_revenue,
    AVG(total_amount)         AS avg_order_value
FROM orders
WHERE order_date > '2024-01-13';

-- ============================================================
-- 5. Order status breakdown using UNION ALL (3 queries)
-- ============================================================
SELECT 'Delivered' AS status, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders WHERE status = 'Delivered'

UNION ALL

SELECT 'Shipped' AS status, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders WHERE status = 'Shipped'

UNION ALL

SELECT 'Pending' AS status, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders WHERE status = 'Pending'

UNION ALL

SELECT 'Cancelled' AS status, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders WHERE status = 'Cancelled'

ORDER BY revenue DESC;

-- ============================================================
-- 6. Unique names across customers and employees
-- ============================================================
SELECT first_name AS first_name FROM customers
UNION
SELECT full_name  AS first_name FROM employees
ORDER BY first_name;

-- ============================================================
-- 7. Products below 500 and above 50000 in one combined list
-- ============================================================
SELECT product_name, price, 'Budget' AS tier FROM products WHERE price < 500
UNION ALL
SELECT product_name, price, 'Premium' AS tier FROM products WHERE price > 50000
ORDER BY price ASC;

-- ============================================================
-- End of Module 2.5 practice queries.
-- ============================================================
