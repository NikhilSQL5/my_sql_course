-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.17: Expanded ShopEasy Dataset
-- Creates and populates: products & orders tables
-- ============================================================
-- Run this script BEFORE the Module 1.1 practice queries.
-- These tables will be used in Modules 1.17, 1.19, 1.20,
-- and throughout all of Level 2 and Level 3.
-- ============================================================

USE shopeasy;

-- ============================================================
-- TABLE 1: products
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(150) NOT NULL,
    category_id     INT,
    price           DECIMAL(10,2) NOT NULL,
    stock_quantity  INT DEFAULT 0
);

INSERT INTO products (product_name, category_id, price, stock_quantity)
VALUES
    ('Samsung Galaxy S24',       1,  74999.00,  45),
    ('Apple iPhone 15',          1,  89999.00,  30),
    ('OnePlus Nord CE 3',        1,  24999.00,  60),
    ('Sony WH-1000XM5 Headphones', 1, 29999.00, 25),
    ('Boat Airdopes 141',        1,   1499.00, 120),
    ('Men\'s Formal Shirt',      2,    899.00,  80),
    ('Women\'s Kurti Set',       2,   1299.00,  95),
    ('Denim Jeans',              2,   1799.00,  70),
    ('Sports Sneakers',          2,   2499.00,  50),
    ('Stainless Steel Cookware Set', 3, 3499.00, 35),
    ('Non-Stick Frying Pan',     3,    799.00,  90),
    ('Mixer Grinder 750W',       3,   4299.00,  40),
    ('Cotton Bedsheet Set',      3,   1199.00,  55),
    ('Rich Dad Poor Dad',        4,    399.00, 150),
    ('Atomic Habits',            4,    449.00, 130),
    ('The Alchemist',            4,    299.00, 110),
    ('Cricket Bat Kashmir Willow', 5, 1999.00,  30),
    ('Yoga Mat 6mm',             5,    599.00,  75),
    ('Dumbbell Set 10kg',        5,   2999.00,  20),
    ('Face Wash Neem 100ml',     6,    149.00, 200);

-- ============================================================
-- TABLE 2: orders
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id        INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      DATE NOT NULL,
    total_amount    DECIMAL(10,2) NOT NULL,
    status          VARCHAR(20) DEFAULT 'Pending'
);

INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES
    (1,  '2024-01-05',  74999.00, 'Delivered'),
    (2,  '2024-01-07',   2998.00, 'Delivered'),
    (3,  '2024-01-09',   1299.00, 'Delivered'),
    (4,  '2024-01-10',  29999.00, 'Shipped'),
    (5,  '2024-01-12',   3499.00, 'Delivered'),
    (6,  '2024-01-13',    449.00, 'Delivered'),
    (7,  '2024-01-14',  24999.00, 'Cancelled'),
    (8,  '2024-01-15',   1999.00, 'Delivered'),
    (9,  '2024-01-16',    799.00, 'Delivered'),
    (10, '2024-01-17',  89999.00, 'Shipped'),
    (11, '2024-01-18',   2499.00, 'Pending'),
    (12, '2024-01-19',    599.00, 'Delivered'),
    (1,  '2024-01-20',   1799.00, 'Delivered'),
    (2,  '2024-01-21',   4299.00, 'Pending'),
    (3,  '2024-01-22',    299.00, 'Delivered'),
    (4,  '2024-01-23',   2999.00, 'Shipped'),
    (5,  '2024-01-24',    149.00, 'Delivered'),
    (6,  '2024-01-25',   1199.00, 'Delivered'),
    (7,  '2024-01-26',    899.00, 'Cancelled'),
    (8,  '2024-01-27',  74999.00, 'Delivered');

-- Verify both tables
SELECT COUNT(*) AS total_products FROM products;
SELECT COUNT(*) AS total_orders   FROM orders;
SELECT * FROM products ORDER BY product_id;
SELECT * FROM orders   ORDER BY order_id;

-- ============================================================
-- End of dataset expansion script.
-- ============================================================
