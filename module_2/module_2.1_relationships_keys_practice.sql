-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.1: Understanding Relationships & Keys
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: All Level 1 tables and data must exist.
-- Run Module_1.17_Expand_ShopEasy_Dataset.sql first if needed.
-- ============================================================

USE shopeasy;

-- ============================================================
-- STEP 1: Review current table structure (before FK constraints)
-- ============================================================
SHOW TABLES;
SHOW CREATE TABLE products;
SHOW CREATE TABLE orders;

-- ============================================================
-- STEP 2: Add FOREIGN KEY constraint -- products -> categories
-- ============================================================
ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES categories (category_id);

-- Verify FK was added
SHOW CREATE TABLE products;

-- ============================================================
-- STEP 3: Add FOREIGN KEY constraint -- orders -> customers
-- ============================================================
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id);

-- Verify FK was added
SHOW CREATE TABLE orders;

-- ============================================================
-- STEP 4: Create order_items junction table
-- Resolves the M:N relationship between orders and products
-- ============================================================
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderitems_order
    FOREIGN KEY (order_id)
    REFERENCES orders (order_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_orderitems_product
    FOREIGN KEY (product_id)
    REFERENCES products (product_id)
);

DESCRIBE order_items;
SHOW CREATE TABLE order_items;

-- ============================================================
-- STEP 5: Seed order_items with realistic data
-- ============================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1,  1,  1,  74999.00),   -- Order 1: Samsung Galaxy S24
    (2,  9,  1,   2499.00),   -- Order 2: Sports Sneakers
    (2,  18, 1,    499.00),   -- Order 2: Yoga Mat
    (3,  7,  1,   1299.00),   -- Order 3: Women's Kurti Set
    (4,  4,  1,  29999.00),   -- Order 4: Sony Headphones
    (5,  10, 1,   3499.00),   -- Order 5: Cookware Set
    (6,  15, 1,    449.00),   -- Order 6: Atomic Habits
    (7,  3,  1,  24999.00),   -- Order 7: OnePlus Nord CE 3
    (8,  17, 1,   1999.00),   -- Order 8: Cricket Bat
    (9,  11, 1,    799.00),   -- Order 9: Non-Stick Pan
    (10, 2,  1,  89999.00),   -- Order 10: Apple iPhone 15
    (11, 9,  1,   2499.00),   -- Order 11: Sports Sneakers
    (12, 18, 1,    599.00),   -- Order 12: Yoga Mat
    (13, 8,  1,   1799.00),   -- Order 13: Denim Jeans
    (14, 12, 1,   4299.00),   -- Order 14: Mixer Grinder
    (15, 16, 1,    299.00),   -- Order 15: The Alchemist
    (16, 19, 1,   2999.00),   -- Order 16: Dumbbell Set
    (17, 20, 1,    149.00),   -- Order 17: Face Wash
    (18, 13, 1,   1199.00),   -- Order 18: Bedsheet Set
    (19, 6,  1,    899.00),   -- Order 19: Men's Formal Shirt
    (20, 1,  1,  74999.00);   -- Order 20: Samsung Galaxy S24

-- Verify order_items data
SELECT COUNT(*) AS total_order_items FROM order_items;
SELECT * FROM order_items ORDER BY order_id LIMIT 5;

-- ============================================================
-- STEP 6: Test referential integrity
-- ============================================================

-- Test 6a: Error 1452 -- insert child row with invalid FK value
-- Uncomment to observe the error:
-- INSERT INTO orders (customer_id, order_date, total_amount, status)
-- VALUES (9999, '2024-02-01', 500.00, 'Pending');
-- Expected: Error 1452 - Cannot add or update a child row

-- Test 6b: Error 1451 -- delete parent row that has children
-- Uncomment to observe the error:
-- DELETE FROM customers WHERE customer_id = 1;
-- Expected: Error 1451 - Cannot delete or update a parent row

-- ============================================================
-- End of Module 2.1 script.
-- The ShopEasy database now has:
--   products -> categories (FK)
--   orders   -> customers  (FK)
--   order_items -> orders  (FK + CASCADE)
--   order_items -> products (FK)
-- ============================================================
