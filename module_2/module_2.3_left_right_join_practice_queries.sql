-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.3: LEFT JOIN & RIGHT JOIN
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Module 2.1 and 2.2 scripts must have been run.
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Basic LEFT JOIN
-- All customers including those with no orders (NULL for order cols)
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount,
    o.status
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
ORDER BY c.customer_id ASC;

-- ============================================================
-- 2. Demonstrate NULL rows -- insert a test customer with no orders
-- ============================================================
INSERT INTO customers (first_name, last_name, email, city)
VALUES ('NoOrder', 'TestCustomer', 'noorder@test.com', 'TestCity');

-- Re-run LEFT JOIN to see the NULL row appear
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.total_amount
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
ORDER BY c.customer_id ASC;

-- Clean up the test customer
DELETE FROM customers WHERE email = 'noorder@test.com';

-- ============================================================
-- 3. Anti-Join Pattern -- customers who have NEVER ordered
-- LEFT JOIN + WHERE right_table.key IS NULL
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- ============================================================
-- 4. Anti-Join -- products that have NEVER been ordered
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    p.price
FROM products AS p
LEFT JOIN order_items AS oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.price DESC;

-- ============================================================
-- 5. LEFT JOIN + GROUP BY + COUNT
-- All customers with their order count (0 for those with no orders)
-- Note: COUNT(o.order_id) NOT COUNT(*) to correctly show 0
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- ============================================================
-- 6. All categories with product count (0 for empty categories)
-- ============================================================
SELECT
    cat.category_id,
    cat.category_name,
    COUNT(p.product_id) AS product_count
FROM categories AS cat
LEFT JOIN products AS p ON cat.category_id = p.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY product_count DESC;

-- ============================================================
-- 7. All products with order count (0 for unordered products)
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    p.price,
    COUNT(oi.order_item_id) AS times_ordered
FROM products AS p
LEFT JOIN order_items AS oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY times_ordered DESC;

-- ============================================================
-- 8. RIGHT JOIN demonstration
-- (Note: rarely used -- prefer LEFT JOIN with swapped tables)
-- ============================================================
-- RIGHT JOIN version
SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM customers AS c
RIGHT JOIN orders AS o ON c.customer_id = o.customer_id;

-- Equivalent LEFT JOIN (preferred)
SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM orders AS o
LEFT JOIN customers AS c ON o.customer_id = c.customer_id;

-- Both queries above return identical results

-- ============================================================
-- 9. WHERE vs ON filter difference (Advanced)
-- (a) WHERE filter -- removes NULL rows (acts like INNER JOIN)
SELECT c.first_name, o.order_id, o.status
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered';

-- (b) ON filter -- keeps NULL rows (true LEFT JOIN behavior)
SELECT c.first_name, o.order_id, o.status
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id AND o.status = 'Delivered';

-- Compare the row counts: (a) excludes non-Delivered customers;
-- (b) includes ALL customers, NULL for those with no Delivered order

-- ============================================================
-- End of Module 2.3 practice queries.
-- ============================================================
