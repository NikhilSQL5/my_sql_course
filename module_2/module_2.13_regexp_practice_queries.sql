-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.13: Regular Expressions (REGEXP)
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Basic REGEXP -- contains pattern (like LIKE '%pattern%')
-- ============================================================

-- Customers whose first_name starts with 'R'
SELECT customer_id, first_name FROM customers
WHERE first_name REGEXP '^R';

-- Products that contain a number in their name
SELECT product_name FROM products
WHERE product_name REGEXP '[0-9]';

-- Customers whose email ends with '.com'
SELECT customer_id, email FROM customers
WHERE email REGEXP '\\.com$';

-- ============================================================
-- 2. NOT REGEXP -- exclusion patterns
-- ============================================================

-- Products whose name contains NO digits
SELECT product_name FROM products
WHERE product_name NOT REGEXP '[0-9]';

-- Customers whose city starts with a lowercase letter (data issue)
SELECT customer_id, city FROM customers
WHERE city IS NOT NULL AND city REGEXP '^[a-z]';

-- ============================================================
-- 3. Anchors ^ and $ -- strict start/end matching
-- ============================================================

-- Names that start exactly with 'A' (not just contain it)
SELECT first_name FROM customers WHERE first_name REGEXP '^A';

-- Status values that end exactly with 'ed' (Delivered, Shipped)
SELECT DISTINCT status FROM orders WHERE status REGEXP 'ed$';

-- ============================================================
-- 4. Character classes [abc] and [a-z]
-- ============================================================

-- Products starting with S, A, or B
SELECT product_name FROM products
WHERE product_name REGEXP '^[SABsab]';

-- Customers from cities starting with M, D, or B
SELECT first_name, city FROM customers
WHERE city REGEXP '^[MDB]';

-- ============================================================
-- 5. Quantifiers {n}, {n,m}, +, *
-- ============================================================

-- Email usernames with at least 5 characters before @
SELECT email FROM customers
WHERE email REGEXP '^[A-Za-z0-9._%+-]{5,}@';

-- Products whose name has exactly 3 consecutive digits
SELECT product_name FROM products
WHERE product_name REGEXP '[0-9]{3}';

-- ============================================================
-- 6. Indian mobile phone validation
-- Valid: exactly 10 digits, starting with 6, 7, 8, or 9
-- ============================================================

-- Find VALID Indian mobile numbers
SELECT customer_id, first_name, phone
FROM customers
WHERE phone REGEXP '^[6-9][0-9]{9}$';

-- Find INVALID phone numbers (not null but wrong format)
SELECT customer_id, first_name, phone
FROM customers
WHERE phone IS NOT NULL
  AND phone NOT REGEXP '^[6-9][0-9]{9}$';

-- ============================================================
-- 7. Email validation with strict REGEXP
-- ============================================================

-- Basic: must contain @
SELECT customer_id, email FROM customers
WHERE email NOT REGEXP '@';

-- Strict: valid email format
SELECT customer_id, email
FROM customers
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+\\@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$';

-- Emails from specific providers only
SELECT customer_id, email
FROM customers
WHERE email REGEXP '@(gmail|yahoo|hotmail|outlook)\\.com$';

-- ============================================================
-- 8. Alternation ( | ) -- OR patterns
-- ============================================================

-- Products from Apple, Samsung, or Sony brands
SELECT product_name, price FROM products
WHERE product_name REGEXP 'Apple|Samsung|Sony';

-- Orders with Delivered or Shipped status
SELECT order_id, status, total_amount FROM orders
WHERE status REGEXP '^(Delivered|Shipped)$';

-- ============================================================
-- 9. REGEXP_REPLACE -- pattern-based replacement
-- ============================================================

-- Remove ALL non-numeric characters from phone numbers
SELECT
    phone,
    REGEXP_REPLACE(phone, '[^0-9]', '') AS phone_digits_only
FROM customers
WHERE phone IS NOT NULL;

-- Remove special characters from product names
SELECT
    product_name,
    REGEXP_REPLACE(product_name, '[^A-Za-z0-9 ]', '') AS name_clean
FROM products;

-- Replace multiple spaces with a single space
SELECT
    product_name,
    REGEXP_REPLACE(product_name, ' +', ' ') AS name_no_extra_spaces
FROM products;

-- ============================================================
-- 10. REGEXP_SUBSTR -- extract pattern matches
-- ============================================================

-- Extract the first number found in product names
SELECT
    product_name,
    REGEXP_SUBSTR(product_name, '[0-9]+') AS first_number
FROM products
WHERE product_name REGEXP '[0-9]';

-- Extract domain from email using REGEXP_SUBSTR
SELECT
    email,
    REGEXP_SUBSTR(email, '[^@]+$') AS email_domain
FROM customers;

-- ============================================================
-- 11. Email provider classification using CASE WHEN + REGEXP
-- ============================================================
SELECT
    customer_id,
    email,
    CASE
        WHEN email REGEXP '@gmail\\.com$'   THEN 'Gmail'
        WHEN email REGEXP '@yahoo\\.com$'   THEN 'Yahoo'
        WHEN email REGEXP '@email\\.com$'   THEN 'Email.com'
        WHEN email REGEXP '@hotmail\\.com$' THEN 'Hotmail'
        ELSE 'Other'
    END AS email_provider
FROM customers
ORDER BY email_provider;

-- Count by provider
SELECT
    CASE
        WHEN email REGEXP '@gmail\\.com$'   THEN 'Gmail'
        WHEN email REGEXP '@yahoo\\.com$'   THEN 'Yahoo'
        WHEN email REGEXP '@email\\.com$'   THEN 'Email.com'
        WHEN email REGEXP '@hotmail\\.com$' THEN 'Hotmail'
        ELSE 'Other'
    END AS email_provider,
    COUNT(*) AS customer_count
FROM customers
GROUP BY email_provider
ORDER BY customer_count DESC;

-- ============================================================
-- 12. Product name quality check -- special character detection
-- ============================================================

-- Products with special characters beyond letters, digits, spaces
SELECT product_name FROM products
WHERE product_name REGEXP '[^A-Za-z0-9 .,''-]';

-- Products whose name is all uppercase
SELECT product_name FROM products
WHERE product_name NOT REGEXP '[a-z]'
  AND product_name REGEXP '[A-Z]';

-- ============================================================
-- End of Module 2.13 practice queries.
-- ============================================================
