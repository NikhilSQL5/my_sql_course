-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.6: Inserting Data
-- ShopEasy E-Commerce Database -- Populating customers & categories
-- ============================================================
-- Prerequisite: Module 1.5 script must already have been run
-- (the shopeasy database and its customers/categories tables
-- must already exist before running this script).
-- ============================================================

USE shopeasy;

-- ============================================================
-- STEP 1: Insert product categories (multi-row INSERT)
-- ============================================================
INSERT INTO categories (category_name)
VALUES
    ('Electronics'),
    ('Clothing'),
    ('Home & Kitchen'),
    ('Books'),
    ('Sports & Fitness'),
    ('Beauty & Personal Care');

-- Verify categories were inserted
SELECT * FROM categories;

-- ============================================================
-- STEP 2: Insert customers (multi-row INSERT)
-- customer_id is AUTO_INCREMENT -- not provided
-- registration_date has a DEFAULT -- not provided
-- ============================================================
INSERT INTO customers (first_name, last_name, email, phone, city)
VALUES
    ('Riya', 'Sharma', 'riya.sharma@email.com', '9876543210', 'Mumbai'),
    ('Aman', 'Verma', 'aman.verma@email.com', '9812345671', 'Delhi'),
    ('Priya', 'Nair', 'priya.nair@email.com', '9812345672', 'Bengaluru'),
    ('Karan', 'Mehta', 'karan.mehta@email.com', '9812345673', 'Chennai'),
    ('Neha', 'Joshi', 'neha.joshi@email.com', '9900011122', 'Pune'),
    ('Rohan', 'Kapoor', 'rohan.kapoor@email.com', '9900011123', 'Hyderabad'),
    ('Simran', 'Kaur', 'simran.kaur@email.com', '9900011124', 'Chandigarh'),
    ('Arjun', 'Reddy', 'arjun.reddy@email.com', '9900011125', 'Hyderabad'),
    ('Sneha', 'Iyer', 'sneha.iyer@email.com', '9900011126', 'Bengaluru'),
    ('Vikram', 'Singh', 'vikram.singh@email.com', '9900011127', 'Delhi'),
    ('Ananya', 'Das', 'ananya.das@email.com', '9900011128', 'Kolkata'),
    ('Rahul', 'Gupta', 'rahul.gupta@email.com', '9900011129', 'Mumbai');

-- Verify customers were inserted
SELECT * FROM customers;

-- ============================================================
-- STEP 3: Demonstration of common errors (for classroom use)
-- Run these ONE AT A TIME to observe the error messages.
-- Each is commented out by default -- uncomment one line at a
-- time to test, then comment it again before moving to the next.
-- ============================================================

-- (a) UNIQUE constraint violation -- duplicate email
-- INSERT INTO customers (first_name, last_name, email, phone, city)
-- VALUES ('Test', 'Duplicate', 'riya.sharma@email.com', '9999999999', 'Mumbai');
-- Expected: Error Code 1062 - Duplicate entry 'riya.sharma@email.com' for key 'email'

-- (b) NOT NULL constraint violation -- missing required category_name
-- INSERT INTO categories (category_name)
-- VALUES (NULL);
-- Expected: Error Code 1048 / 1364 depending on SQL mode - Column 'category_name' cannot be null

-- ============================================================
-- End of Module 1.6 script.
-- categories and customers tables are now populated with
-- realistic ShopEasy data, ready for SELECT queries in Module 1.7.
-- ============================================================
