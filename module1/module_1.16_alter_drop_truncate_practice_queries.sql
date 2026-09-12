-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.16: Modifying Table Structure
-- ALTER TABLE, DROP TABLE & TRUNCATE
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Module 1.5 shopeasy schema must exist.
-- ============================================================

USE shopeasy;

-- ============================================================
-- BEFORE STARTING: Review current customers table structure
-- ============================================================
DESCRIBE customers;

-- ============================================================
-- 1. ALTER TABLE -- ADD COLUMN
-- Add loyalty_points column with a default of 0
-- ============================================================
ALTER TABLE customers
ADD COLUMN loyalty_points INT DEFAULT 0;

-- Verify: new column should appear with DEFAULT 0
DESCRIBE customers;

-- Check: all existing rows should have loyalty_points = 0
SELECT 
  customer_id, 
  first_name, 
  loyalty_points
FROM customers
LIMIT 5;

-- ============================================================
-- 2. ALTER TABLE -- ADD COLUMN at a specific position
-- ============================================================
-- (Example only -- run this on a fresh table, not on top of
-- the loyalty_points column already added above)
-- ALTER TABLE customers
-- ADD COLUMN loyalty_tier VARCHAR(20) DEFAULT 'Standard' AFTER loyalty_points;

-- ============================================================
-- 3. ALTER TABLE -- MODIFY COLUMN
-- Widen the phone column to VARCHAR(20)
-- Must restate the FULL column definition
-- ============================================================
ALTER TABLE customers
MODIFY COLUMN phone VARCHAR(20);

-- Verify the change
DESCRIBE customers;

-- ============================================================
-- 4. ALTER TABLE -- RENAME COLUMN
-- Rename 'phone' to 'contact_phone'
-- ============================================================
ALTER TABLE customers
RENAME COLUMN phone TO contact_phone;

-- Verify the rename
DESCRIBE customers;

-- ============================================================
-- 5. ALTER TABLE -- DROP COLUMN
-- Remove the loyalty_points column (PERMANENT -- no undo)
-- ============================================================
ALTER TABLE customers
DROP COLUMN loyalty_points;

-- Verify the column is gone
DESCRIBE customers;

-- ============================================================
-- 6. DROP TABLE -- with IF EXISTS safety clause
-- Create a dummy table, then drop it cleanly
-- ============================================================
CREATE TABLE IF NOT EXISTS temp_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(50)
);

-- Confirm the table exists in the schema
DESCRIBE temp_test;

-- Drop it safely
DROP TABLE IF EXISTS temp_test;

-- Attempting to describe after drop will produce an error:
-- DESCRIBE temp_test;  -- uncomment to see "table doesn't exist" error

-- ============================================================
-- 7. TRUNCATE demonstration
-- Create a small test table, populate it, then truncate it
-- ============================================================
CREATE TABLE IF NOT EXISTS truncate_demo (
    demo_id INT AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(50)
);

INSERT INTO truncate_demo (label)
VALUES ('Row 1'), ('Row 2'), ('Row 3');

-- Check data and current AUTO_INCREMENT behaviour
SELECT * FROM truncate_demo;

-- Truncate all rows
TRUNCATE TABLE truncate_demo;

-- Table is now empty, AUTO_INCREMENT reset to 1
SELECT * FROM truncate_demo;

-- Re-insert to confirm AUTO_INCREMENT starts from 1 again
INSERT INTO truncate_demo (label) VALUES ('Fresh Row');
SELECT * FROM truncate_demo;

-- Cleanup
DROP TABLE IF EXISTS truncate_demo;

-- ============================================================
-- 8. Restore contact_phone back to 'phone' for course continuity
-- (Keeps the ShopEasy schema consistent for future modules)
-- ============================================================
ALTER TABLE customers
RENAME COLUMN contact_phone TO phone;

ALTER TABLE customers
MODIFY COLUMN phone VARCHAR(15);

DESCRIBE customers;

-- ============================================================
-- End of Module 1.16 script.
-- ============================================================
