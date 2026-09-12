-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.12: Data Cleaning Techniques
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- IMPORTANT: Always SELECT-first to preview before any UPDATE.
-- Follow the 5-step workflow: Audit > Identify > Standardise
-- (SELECT) > Fix (UPDATE) > Verify.
-- ============================================================

USE shopeasy;

-- ============================================================
-- STEP 1: AUDIT -- Profile the customers table
-- ============================================================
SELECT
    COUNT(*) AS total_rows,
    COUNT(first_name) AS has_first_name,
    COUNT(last_name) AS has_last_name,
    COUNT(email) AS has_email,
    COUNT(*) - COUNT(email) AS missing_email,
    COUNT(phone) AS has_phone,
    COUNT(*) - COUNT(phone) AS missing_phone,
    COUNT(city) AS has_city,
    COUNT(*) - COUNT(city) AS missing_city
FROM customers;

-- Value distribution: customers per city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- Products audit: price range
SELECT
    COUNT(*) AS total_products,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    COUNT(*) - COUNT(price) AS missing_price
FROM products;

-- ============================================================
-- STEP 2: IDENTIFY -- Find specific issues
-- ============================================================

-- 2a. NULL values
SELECT customer_id, first_name, 'phone IS NULL' AS issue
FROM customers WHERE phone IS NULL
UNION ALL
SELECT customer_id, first_name, 'city IS NULL' AS issue
FROM customers WHERE city IS NULL;

-- 2b. Blank strings (different from NULL)
SELECT customer_id, first_name, phone, city
FROM customers
WHERE phone = '' OR city = '' OR city = ' ';

-- 2c. Duplicate emails
SELECT email, COUNT(*) AS occurrences
FROM customers
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- 2d. Invalid emails (no @ symbol)
SELECT customer_id, first_name, email
FROM customers
WHERE INSTR(email, '@') = 0;

-- 2e. Short/invalid phone numbers (< 10 digits after removing hyphens)
SELECT customer_id, first_name, phone,
       CHAR_LENGTH(REPLACE(phone, '-', '')) AS digit_count
FROM customers
WHERE phone IS NOT NULL
  AND CHAR_LENGTH(REPLACE(phone, '-', '')) < 10;

-- 2f. Whitespace issues in city
SELECT customer_id, city,
       CHAR_LENGTH(city) AS original_length,
       CHAR_LENGTH(TRIM(city)) AS trimmed_length
FROM customers
WHERE city IS NOT NULL
  AND city != TRIM(city);

-- 2g. Casing inconsistencies in email
SELECT customer_id, email
FROM customers
WHERE email IS NOT NULL
  AND email != LOWER(TRIM(email));

-- 2h. Placeholder phone values
SELECT customer_id, first_name, phone
FROM customers
WHERE phone = '0000000000';

-- 2i. Price outliers in products
SELECT product_name, price
FROM products
WHERE price < 100 OR price > 200000
ORDER BY price;

-- 2j. Duplicate orders: same customer, same date
SELECT customer_id, order_date, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id, order_date
HAVING COUNT(*) > 1;

-- ============================================================
-- STEP 3 & 4: STANDARDISE (SELECT preview) then FIX (UPDATE)
-- ============================================================

-- Fix 1: Standardise email -- LOWER + TRIM
-- Step 3: Preview
SELECT customer_id,
       email AS email_original,
       LOWER(TRIM(email)) AS email_clean
FROM customers
WHERE email IS NOT NULL
  AND email != LOWER(TRIM(email));

-- Step 4: Fix
UPDATE customers
SET email = LOWER(TRIM(email))
WHERE email IS NOT NULL
  AND email != LOWER(TRIM(email));

-- Fix 2: Remove leading/trailing spaces from city
-- Step 3: Preview
SELECT customer_id, city, TRIM(city) AS city_clean
FROM customers
WHERE city IS NOT NULL
  AND city != TRIM(city);

-- Step 4: Fix
UPDATE customers
SET city = TRIM(city)
WHERE city IS NOT NULL
  AND city != TRIM(city);

-- Fix 3: Convert blank city to NULL
-- Step 3: Preview
SELECT customer_id, first_name, city
FROM customers
WHERE city = '' OR city = ' ';

-- Step 4: Fix
UPDATE customers
SET city = NULL
WHERE city = '' OR city = ' ';

-- Fix 4: Convert placeholder phone '0000000000' to NULL
-- Step 3: Preview
SELECT customer_id, phone, NULLIF(phone, '0000000000') AS phone_clean
FROM customers
WHERE phone = '0000000000';

-- Step 4: Fix
UPDATE customers
SET phone = NULL
WHERE phone = '0000000000';

-- Fix 5: Remove hyphens from phone numbers for consistency
-- Step 3: Preview
SELECT customer_id, phone, REPLACE(phone, '-', '') AS phone_clean
FROM customers
WHERE phone IS NOT NULL
  AND INSTR(phone, '-') > 0;

-- Step 4: Fix
UPDATE customers
SET phone = REPLACE(phone, '-', '')
WHERE phone IS NOT NULL
  AND INSTR(phone, '-') > 0;

-- Fix 6: Round product prices to 2 decimal places
-- Step 3: Preview
SELECT product_id, price, ROUND(price, 2) AS price_clean
FROM products
WHERE price != ROUND(price, 2);

-- Step 4: Fix
UPDATE products
SET price = ROUND(price, 2)
WHERE price != ROUND(price, 2);

-- ============================================================
-- STEP 5: VERIFY -- Re-run audit/identify queries
-- ============================================================

-- Verify email standardisation (should return 0 rows)
SELECT customer_id, email
FROM customers
WHERE email IS NOT NULL
  AND email != LOWER(TRIM(email));

-- Verify no more whitespace issues in city
SELECT customer_id, city
FROM customers
WHERE city IS NOT NULL
  AND city != TRIM(city);

-- Verify no more duplicate emails
SELECT email, COUNT(*) AS cnt
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

-- Final full audit post-cleaning
SELECT
    COUNT(*) AS total_rows,
    COUNT(phone) AS has_phone,
    COUNT(*) - COUNT(phone) AS missing_phone,
    COUNT(city) AS has_city,
    COUNT(*) - COUNT(city) AS missing_city
FROM customers;

-- ============================================================
-- BONUS: Comprehensive data health report per customer
-- ============================================================
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    CASE
        WHEN email IS NULL THEN 'Missing'
        WHEN INSTR(email, '@') = 0 THEN 'Invalid'
        ELSE 'Valid'
    END AS email_status,
    CASE
        WHEN phone IS NULL THEN 'Missing'
        WHEN CHAR_LENGTH(REPLACE(phone, '-', '')) < 10 THEN 'Invalid'
        ELSE 'Valid' 
    END AS phone_status,
    CASE
        WHEN city IS NULL OR city = ''  THEN 'Missing'
        ELSE 'Present'
    END AS city_status
FROM customers
ORDER BY customer_id;

-- ============================================================
-- DEMO: Insert dirty data to test cleaning workflow
-- (Run, clean, then delete the test rows)
-- ============================================================
-- INSERT INTO customers (first_name, last_name, email, phone, city)
-- VALUES
--     ('Test', 'Dirty1', '  DIRTY@GMAIL.COM  ', '0000000000', ' Mumbai '),
--     ('Test', 'Dirty2', 'nodomain',             NULL,         ''),
--     ('Test', 'Dup',    'duplicate@test.com',   '9000000001', 'Pune'),
--     ('Test', 'Dup2',   'duplicate@test.com',   '9000000002', 'Delhi');

-- After inserting test data, re-run the identify queries above
-- to confirm they detect the issues, then clean and verify.

-- ============================================================
-- End of Module 2.12 practice queries.
-- ============================================================
