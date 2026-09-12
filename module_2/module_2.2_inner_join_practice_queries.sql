-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.2: INNER JOIN
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Module 2.1 script must have been run
-- (FK constraints and order_items table must exist).
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Basic two-table INNER JOIN
-- orders + customers: show customer name with each order
-- ============================================================

-- Without aliases (verbose but valid)
SELECT
    orders.order_id,
    customers.first_name,
    customers.last_name,
    orders.order_date,
    orders.total_amount,
    orders.status
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

-- Same query with table aliases (recommended practice)
SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount,
    o.status
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

-- ============================================================
-- 2. products + categories: show category name with each product
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    p.stock_quantity
FROM products AS p
INNER JOIN categories AS cat ON p.category_id = cat.category_id
ORDER BY cat.category_name ASC, p.price ASC;

-- ============================================================
-- 3. INNER JOIN with WHERE
-- Delivered orders from Mumbai or Delhi customers only
-- ============================================================
SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    c.city,
    o.total_amount,
    o.status
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered' AND c.city IN ('Mumbai', 'Delhi')
ORDER BY o.total_amount DESC;

-- ============================================================
-- 4. Three-table JOIN: orders + order_items + products
-- Show order line items with product names
-- ============================================================
SELECT
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM orders AS o
INNER JOIN order_items AS oi ON o.order_id  = oi.order_id
INNER JOIN products AS p  ON oi.product_id = p.product_id
ORDER BY o.order_id ASC;

-- ============================================================
-- 5. Four-table JOIN: customers + orders + order_items + products
-- Full order detail: customer name + product purchased
-- ============================================================
SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id = oi.order_id
INNER JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Delivered'
ORDER BY o.order_id ASC;

-- ============================================================
-- 6. JOIN + GROUP BY + aggregates
-- Total orders and total spend per customer
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id)   AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- ============================================================
-- 7. JOIN + GROUP BY: average order value per city
-- ============================================================
SELECT
    c.city,
    COUNT(o.order_id) AS orders,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders AS o
INNER JOIN customers AS c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY avg_order_value DESC;

-- ============================================================
-- 8. Category revenue report
-- category_name + products in category + total revenue
-- ============================================================
SELECT
    cat.category_name,
    COUNT(DISTINCT p.product_id) AS products_in_category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories AS cat
INNER JOIN products AS p ON cat.category_id = p.category_id
INNER JOIN order_items AS oi ON p.product_id = oi.product_id
-- GROUP BY cat.category_id, cat.category_name
GROUP BY cat.category_name
ORDER BY total_revenue DESC;

-- ============================================================
-- End of Module 2.2 practice queries.
-- ============================================================
