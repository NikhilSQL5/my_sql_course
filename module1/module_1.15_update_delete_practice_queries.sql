-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.15: Updating & Deleting Data
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run.
-- ============================================================
-- WARNING: UPDATE and DELETE permanently modify data.
-- ALWAYS run the SELECT-first verification before executing
-- any UPDATE or DELETE statement.
-- ============================================================

USE shopeasy;

-- ============================================================
-- BEFORE STARTING: View current state of the customers table
-- ============================================================
SELECT * FROM customers
ORDER BY customer_id ASC;

-- ============================================================
-- 1. UPDATE -- single column
-- Step 1: SELECT-first to verify the target row
-- ============================================================
SELECT * FROM customers
WHERE customer_id = 3;

-- Step 2: Only after confirming the correct row, run UPDATE
UPDATE customers
SET city = 'Pune'
WHERE customer_id = 3;

-- Step 3: Verify the change took effect
SELECT 
  customer_id,
  first_name,
  city 
FROM customers 
WHERE customer_id = 3;

-- ============================================================
-- 2. UPDATE -- multiple columns in one statement
-- Step 1: SELECT-first
-- ============================================================
SELECT * FROM customers 
WHERE customer_id = 5;

-- Step 2: UPDATE
UPDATE customers
SET city    = 'Kolkata',
    phone   = '9988776655'
WHERE customer_id = 5;

-- Step 3: Verify
SELECT 
  customer_id, 
  first_name, 
  city, 
  phone 
FROM customers
WHERE customer_id = 5;

-- ============================================================
-- 3. Safe Updates mode demonstration
-- Run this to trigger Error 1175 (Safe Updates blocking
-- an UPDATE without a Primary Key in the WHERE clause)
-- ============================================================
-- UPDATE customers SET city = 'Test' WHERE city = 'Mumbai';
-- Expected: Error Code 1175. You are using safe update mode...

-- To run a non-key WHERE UPDATE, temporarily disable safe mode:
SET SQL_SAFE_UPDATES = 0;

UPDATE customers
SET city = 'Mumbai'
WHERE city = 'Mumbai';   -- updating to the same value -- harmless demo

SET SQL_SAFE_UPDATES = 1;   -- ALWAYS re-enable immediately after

-- ============================================================
-- 4. UPDATE -- set a nullable column to NULL
-- (Useful for blanking optional fields, e.g., for data cleaning)
-- ============================================================
SELECT * FROM customers WHERE customer_id = 6;

UPDATE customers
SET phone = NULL
WHERE customer_id = 6;

SELECT 
  customer_id, 
  first_name, 
  phone 
FROM customers 
WHERE customer_id = 6;

-- ============================================================
-- 5. DELETE -- specific row
-- Step 1: SELECT-first
-- ============================================================
SELECT * FROM customers WHERE customer_id = 12;

-- Step 2: DELETE
DELETE FROM customers
WHERE customer_id = 12;

-- Step 3: Verify the row is gone
SELECT * FROM customers 
ORDER BY customer_id ASC;

-- ============================================================
-- 6. INSERT a test record, then DELETE it safely
-- (Demonstrates the full workflow: insert > select > delete > verify)
-- ============================================================

-- Insert a deliberately fake test customer
INSERT INTO customers (first_name, last_name, email, phone, city)
VALUES ('Test', 'Account', 'test.delete@example.com', '0000000000', 'TestCity');

-- Confirm it was inserted (note its auto-assigned customer_id)
SELECT * FROM customers 
WHERE email = 'test.delete@example.com';

-- Now DELETE it using its customer_id (use the actual ID returned above)
-- Replace XX with the actual customer_id value shown in the SELECT above
-- DELETE FROM customers WHERE customer_id = XX;

-- Verify it is gone
SELECT * FROM customers 
WHERE email = 'test.delete@example.com';

-- ============================================================
-- End of Module 1.15 script.
-- ============================================================
