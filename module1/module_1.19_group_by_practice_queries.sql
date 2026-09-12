-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.19: Simple Grouping -- GROUP BY
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Module_1.17_Expand_ShopEasy_Dataset.sql must
-- already have been run (products and orders tables must exist).
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Basic GROUP BY -- single column
-- ============================================================

-- Orders per status
SELECT
    status   AS "Order Status",
    COUNT(*) AS "Number of Orders"
FROM orders
GROUP BY status;

-- Customers per city
SELECT
    city     AS "City",
    COUNT(*) AS "Customer Count"
FROM customers
GROUP BY city
ORDER BY COUNT(*) DESC;

-- ============================================================
-- 2. GROUP BY with multiple aggregate functions
-- ============================================================

-- Full order breakdown per status
SELECT
    status            AS "Status",
    COUNT(*)          AS "Orders",
    SUM(total_amount) AS "Total Revenue",
    AVG(total_amount) AS "Avg Order Value",
    MIN(total_amount) AS "Min Order",
    MAX(total_amount) AS "Max Order"
FROM orders
GROUP BY status
ORDER BY SUM(total_amount) DESC;

-- Product summary per category
SELECT
    category_id AS "Category ID",
    COUNT(*)    AS "Products",
    AVG(price)  AS "Avg Price",
    MIN(price)  AS "Cheapest",
    MAX(price)  AS "Most Expensive"
FROM products
GROUP BY category_id
ORDER BY AVG(price) DESC;

-- ============================================================
-- 3. GROUP BY with WHERE (filter BEFORE grouping)
-- ============================================================

-- Revenue per status for orders placed AFTER Jan 10 only
SELECT
    status            AS "Status",
    COUNT(*)          AS "Orders",
    SUM(total_amount) AS "Revenue"
FROM orders
WHERE order_date > '2024-01-10'
GROUP BY status
ORDER BY SUM(total_amount) DESC;

-- Total revenue per customer, Delivered orders only
SELECT
    customer_id       AS "Customer ID",
    COUNT(*)          AS "Delivered Orders",
    SUM(total_amount) AS "Delivered Revenue"
FROM orders
WHERE status = 'Delivered'
GROUP BY customer_id
ORDER BY SUM(total_amount) DESC;

-- ============================================================
-- 4. GROUP BY with ORDER BY on aggregate
-- ============================================================

-- Cities sorted by customer count (highest first)
SELECT
    city     AS "City",
    COUNT(*) AS "Customers"
FROM customers
GROUP BY city
ORDER BY COUNT(*) DESC;

-- Statuses sorted alphabetically
SELECT
    status            AS "Status",
    SUM(total_amount) AS "Total Revenue"
FROM orders
GROUP BY status
ORDER BY status ASC;

-- ============================================================
-- 5. Multi-column GROUP BY
-- ============================================================

-- Orders per customer per status
SELECT
    customer_id       AS "Customer ID",
    status            AS "Status",
    COUNT(*)          AS "Orders",
    SUM(total_amount) AS "Value"
FROM orders
GROUP BY customer_id, status
ORDER BY customer_id ASC, status ASC;

-- ============================================================
-- 6. Top status by revenue (GROUP BY + ORDER BY + LIMIT)
-- Advanced Q11 from practice questions
-- ============================================================
SELECT
    status            AS "Status",
    SUM(total_amount) AS "Total Revenue"
FROM orders
GROUP BY status
ORDER BY SUM(total_amount) DESC
LIMIT 1;

-- ============================================================
-- 7. Full analytical pipeline combining all Level 1 clauses
-- SELECT + FROM + WHERE + GROUP BY + ORDER BY + LIMIT
-- ============================================================
SELECT
    status            AS "Status",
    COUNT(*)          AS "Orders",
    SUM(total_amount) AS "Revenue"
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY status
ORDER BY SUM(total_amount) DESC
LIMIT 3;

-- ============================================================
-- End of Module 1.19 practice queries.
-- Full Level 1 SELECT clause order:
-- SELECT > FROM > WHERE > GROUP BY > ORDER BY > LIMIT
-- ============================================================
