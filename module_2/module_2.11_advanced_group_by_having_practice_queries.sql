-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.11: Advanced GROUP BY & HAVING
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Basic HAVING -- filter groups by aggregate condition
-- ============================================================

-- Only show order statuses with MORE THAN 2 orders
SELECT
    status,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
HAVING COUNT(*) > 2
ORDER BY order_count DESC;

-- Cities with more than 1 customer
SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY customer_count DESC;

-- ============================================================
-- 2. HAVING with SUM and AVG
-- ============================================================

-- Categories where average product price exceeds 5000
SELECT
    category_id,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id
HAVING AVG(price) > 5000
ORDER BY avg_price DESC;

-- Customers whose total spend exceeds 50000
SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > 50000
ORDER BY total_spent DESC;

-- ============================================================
-- 3. WHERE + HAVING together -- dual-level filtering
-- ============================================================

-- Among Delivered orders only (WHERE),
-- show customers who spent more than 50000 (HAVING)
SELECT
    o.customer_id,
    c.first_name,
    COUNT(o.order_id) AS delivered_orders,
    SUM(o.total_amount) AS total_delivered_spend
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY o.customer_id, c.first_name
HAVING SUM(o.total_amount) > 50000
ORDER BY total_delivered_spend DESC;

-- ============================================================
-- 4. HAVING with multiple conditions (AND / OR)
-- ============================================================

-- Categories with 3+ products AND average price above 500
SELECT
    category_id,
    COUNT(*) AS product_count,
    ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY category_id
HAVING COUNT(*) >= 3 AND AVG(price) > 500
ORDER BY avg_price DESC;

-- Customers with 2+ orders OR total spend above 70000
SELECT
    c.customer_id,
    c.first_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.total_amount) AS total_spent
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name
HAVING COUNT(o.order_id) > 1 OR SUM(o.total_amount) > 70000
ORDER BY total_spent DESC;

-- ============================================================
-- 5. WITH ROLLUP -- grand total row
-- ============================================================

-- Order count and revenue per status WITH grand total
SELECT
    status,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY status WITH ROLLUP
ORDER BY status;

-- ============================================================
-- 6. GROUPING() -- label ROLLUP rows cleanly
-- ============================================================
SELECT
    CASE WHEN GROUPING(status) = 1
         THEN 'ALL STATUSES (GRAND TOTAL)'
         ELSE status
    END AS status_label,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY status WITH ROLLUP
ORDER BY GROUPING(status), status;

-- ============================================================
-- 7. Multi-column GROUP BY with ROLLUP
-- Category + product revenue with subtotals
-- ============================================================
SELECT
    CASE
        WHEN GROUPING(p.category_id) = 1  THEN 'GRAND TOTAL'
        WHEN GROUPING(p.product_name) = 1 THEN CONCAT('CAT ', p.category_id, ' SUBTOTAL')
        ELSE p.product_name
    END AS label,
    p.category_id,
    COUNT(oi.order_item_id) AS times_ordered,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products AS p
INNER JOIN order_items AS oi ON p.product_id = oi.product_id
GROUP BY p.category_id, p.product_name WITH ROLLUP
ORDER BY GROUPING(p.category_id), p.category_id,
         GROUPING(p.product_name), p.product_name;

-- ============================================================
-- 8. Three-table JOIN + GROUP BY + HAVING
-- Customers who ordered more than 1 distinct product
-- ============================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    COUNT(DISTINCT oi.product_id) AS distinct_products,
    ROUND(SUM(o.total_amount), 2) AS total_spend
FROM customers AS c
INNER JOIN orders AS o  ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id    = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT oi.product_id) > 1
ORDER BY total_spend DESC;

-- ============================================================
-- 9. Complete clause order demonstration
-- SELECT > FROM > JOIN > WHERE > GROUP BY > HAVING > ORDER BY > LIMIT
-- ============================================================
SELECT
    c.city,
    COUNT(o.order_id) AS order_count,
    ROUND(SUM(o.total_amount), 2) AS city_revenue
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered' -- row-level filter
GROUP BY c.city -- grouping
HAVING SUM(o.total_amount) > 10000 -- group-level filter
ORDER BY city_revenue DESC -- sort
LIMIT 5; -- cap

-- ============================================================
-- End of Module 2.11 practice queries.
-- Full clause order:
-- SELECT > FROM > JOIN > WHERE > GROUP BY > HAVING > ORDER BY > LIMIT
-- ============================================================
