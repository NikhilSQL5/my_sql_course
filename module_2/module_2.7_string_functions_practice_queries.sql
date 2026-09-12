-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.7: String Functions
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. CONCAT -- Building composite strings
-- ============================================================

-- Full name from first_name + last_name
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(last_name, ', ', first_name) AS name_last_first
FROM customers
ORDER BY last_name ASC;

-- Display email in mail-client format: 'Name <email>'
SELECT
    CONCAT(first_name, ' <', email, '>') AS display_email
FROM customers;

-- ============================================================
-- 2. CONCAT_WS -- NULL-safe concatenation with separator
-- ============================================================
SELECT
    customer_id,
    CONCAT_WS(', ', first_name, last_name, city) AS formatted_contact
FROM customers;

-- ============================================================
-- 3. UPPER and LOWER -- Standardising case
-- ============================================================
SELECT
    customer_id,
    UPPER(city)  AS city_upper,
    LOWER(email) AS email_lower,
    first_name
FROM customers;

-- Case-insensitive search using UPPER
SELECT * FROM customers WHERE UPPER(city) = 'MUMBAI';

-- ============================================================
-- 4. LENGTH and CHAR_LENGTH -- Measuring string size
-- ============================================================
SELECT
    product_name,
    CHAR_LENGTH(product_name) AS char_count,
    LENGTH(product_name) AS byte_count
FROM products
ORDER BY char_count DESC;

-- Find products with name longer than 20 characters
SELECT product_name, CHAR_LENGTH(product_name) AS name_length
FROM products
WHERE CHAR_LENGTH(product_name) > 20
ORDER BY name_length DESC;

-- ============================================================
-- 5. LEFT, RIGHT, SUBSTRING -- Extracting parts of a string
-- ============================================================

-- First 5 characters of product name
SELECT product_name, LEFT(product_name, 5) AS prefix FROM products;

-- Last 3 characters (useful for extensions, codes)
SELECT product_name, RIGHT(product_name, 3) AS suffix FROM products;

-- SUBSTRING with position and length
SELECT
    email,
    SUBSTRING(email, 1, 4) AS first_4_chars
FROM customers;

-- ============================================================
-- 6. INSTR -- Find position of a substring
-- ============================================================

-- Position of '@' in each email
SELECT email, INSTR(email, '@') AS at_position FROM customers;

-- Email username: everything BEFORE '@'
SELECT
    email,
    LEFT(email, INSTR(email, '@') - 1) AS email_username
FROM customers;

-- Email domain: everything AFTER '@'
SELECT
    email,
    SUBSTRING(email, INSTR(email, '@') + 1) AS email_domain
FROM customers;

-- Find invalid emails (no '@' sign) -- INSTR returns 0 if not found
SELECT customer_id, email
FROM customers
WHERE INSTR(email, '@') = 0;

-- ============================================================
-- 7. TRIM, LTRIM, RTRIM -- Removing whitespace
-- ============================================================

-- Show effect of TRIM (useful when checking for hidden spaces)
SELECT
    city,
    TRIM(city) AS city_trimmed,
    CHAR_LENGTH(city) AS original_length,
    CHAR_LENGTH(TRIM(city)) AS trimmed_length
FROM customers;

-- Find rows with hidden leading/trailing spaces
SELECT customer_id, city
FROM customers
WHERE CHAR_LENGTH(city) != CHAR_LENGTH(TRIM(city));

-- ============================================================
-- 8. REPLACE -- Find and replace within strings
-- ============================================================

-- Remove hyphens from phone numbers
SELECT phone, REPLACE(phone, '-', '') AS phone_clean FROM customers;

-- Replace email domain in output (preview only -- not updating the table)
SELECT
    email,
    REPLACE(LOWER(TRIM(email)), '@email.com', '@shopeasy.in') AS updated_email
FROM customers;

-- ============================================================
-- 9. LPAD and RPAD -- Padding strings
-- ============================================================

-- Pad order_id to 6-digit format
SELECT order_id, LPAD(order_id, 6, '0') AS formatted_order_id FROM orders;

-- Pad product_id with trailing dashes
SELECT product_id, RPAD(product_id, 6, '-') AS padded_id FROM products;

-- ============================================================
-- 10. Combining string functions -- Real data cleaning
-- ============================================================

-- Standardise email: trim + lowercase
SELECT
    email,
    LOWER(TRIM(email)) AS email_clean
FROM customers;

-- Formatted customer label: 'SHARMA, Riya (Mumbai)'
SELECT
    CONCAT(
        UPPER(last_name), ', ',
        first_name, ' (',
        city, ')'
    ) AS customer_label
FROM customers;

-- Email validation + username extraction combined with CASE WHEN
SELECT
    customer_id,
    email,
    CASE
        WHEN INSTR(email, '@') > 0 THEN 'Valid'
        ELSE 'Invalid'
    END AS email_status,
    LEFT(email, INSTR(email, '@') - 1) AS username
FROM customers;

-- ============================================================
-- 11. REVERSE -- Reverse a string (advanced / fun demo)
-- ============================================================
SELECT first_name, REVERSE(first_name) AS reversed FROM customers LIMIT 5;

-- ============================================================
-- End of Module 2.7 practice queries.
-- ============================================================
