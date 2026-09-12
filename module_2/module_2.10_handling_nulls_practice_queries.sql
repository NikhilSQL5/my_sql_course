-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.10: Handling NULLs
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Understanding NULL -- IS NULL vs = NULL
-- ============================================================

-- CORRECT: Find customers with no phone on record
SELECT customer_id, first_name, last_name
FROM customers
WHERE phone IS NULL;

-- WRONG (returns zero rows even if NULLs exist):
-- SELECT * FROM customers WHERE phone = NULL;

-- CORRECT: Find customers WITH a phone
SELECT customer_id, first_name, phone
FROM customers
WHERE phone IS NOT NULL;

-- NULL in arithmetic (all return NULL)
SELECT
    NULL + 5 AS null_plus_5,
    NULL * 100 AS null_times_100,
    NULL = NULL AS null_eq_null,   -- returns NULL, not TRUE
    NULL IS NULL AS null_is_null;   -- returns 1 (TRUE) -- correct

-- ============================================================
-- 2. IFNULL -- Replace NULL with a default value
-- ============================================================

-- Replace NULL phone with 'Not Provided'
SELECT
    customer_id,
    first_name,
    IFNULL(phone, 'Not Provided') AS phone_display,
    IFNULL(city,  'Unknown')      AS city_display
FROM customers;

-- IFNULL in numeric context: replace NULL with 0
SELECT
    customer_id,
    first_name,
    IFNULL(phone, 'Not Provided') AS phone
FROM customers;

-- ============================================================
-- 3. COALESCE -- First non-NULL from a list
-- ============================================================

-- Best contact: phone first, then email, then 'No Contact'
SELECT
    customer_id,
    first_name,
    COALESCE(phone, email, 'No Contact Info') AS best_contact
FROM customers;

-- Single fallback (equivalent to IFNULL but SQL-standard)
SELECT
    customer_id,
    COALESCE(city, 'Location Unknown') AS display_city
FROM customers;

-- ============================================================
-- 4. NULLIF -- Return NULL when two values are equal
-- ============================================================

-- NULLIF demonstration
SELECT
    NULLIF(5, 5) AS equal_args,      -- returns NULL
    NULLIF(5, 3) AS unequal_args,    -- returns 5
    NULLIF(0, 0) AS both_zero;       -- returns NULL

-- Safe division using NULLIF to avoid division-by-zero
-- (If quantity were 0, NULLIF returns NULL, making the division NULL not an error)
SELECT
    oi.order_item_id,
    oi.order_id,
    oi.quantity,
    oi.unit_price,
    ROUND(oi.unit_price / NULLIF(oi.quantity, 0), 2) AS price_per_unit
FROM order_items AS oi;

-- NULLIF to convert sentinel placeholder to NULL
-- ('0000000000' is a placeholder for missing phone)
SELECT
    customer_id,
    first_name,
    phone,
    NULLIF(phone, '0000000000') AS real_phone
FROM customers;

-- ============================================================
-- 5. NULL in aggregate functions
-- ============================================================

-- COUNT(*) vs COUNT(phone) -- may differ if NULLs exist
SELECT
    COUNT(*) AS total_customers,
    COUNT(phone) AS customers_with_phone,
    COUNT(*) - COUNT(phone) AS customers_without_phone
FROM customers;

-- SUM and AVG ignore NULLs automatically
SELECT
    SUM(total_amount)  AS total_revenue,   -- NULLs ignored
    AVG(total_amount)  AS avg_order_value  -- divides by non-NULL count only
FROM orders;

-- ============================================================
-- 6. LEFT JOIN + COALESCE -- 0 instead of NULL for inactive records
-- ============================================================

-- All customers with order count (0 for those with no orders)
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
-- 7. Data completeness audit
-- ============================================================

-- How many customers have each field populated vs NULL
SELECT
    COUNT(*) AS total_customers,
    COUNT(phone) AS has_phone,
    COUNT(*) - COUNT(phone) AS missing_phone,
    COUNT(city) AS has_city,
    COUNT(*) - COUNT(city) AS missing_city,
    COUNT(email) AS has_email,
    COUNT(*) - COUNT(email) AS missing_email
FROM customers;

-- ============================================================
-- 8. Customer completeness classification (CASE WHEN + IS NULL)
-- ============================================================
SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    IFNULL(phone, 'Not Provided') AS phone,
    IFNULL(city, 'Unknown') AS city,
    CASE
        WHEN phone IS NOT NULL AND city IS NOT NULL THEN 'Complete'
        WHEN phone IS NULL AND city IS NULL THEN 'Incomplete'
        ELSE 'Partial'
    END AS data_completeness
FROM customers
ORDER BY data_completeness, full_name;

-- ============================================================
-- 9. NULL-safe equality operator <=>
-- ============================================================
SELECT
    NULL <=> NULL AS null_safe_null_null,  -- 1 (TRUE)
    NULL <=> 5 AS null_safe_null_5,     -- 0 (FALSE)
    5    <=> 5 AS null_safe_5_5,        -- 1 (TRUE)
    NULL =  NULL AS standard_null_null;   -- NULL (not TRUE)

-- ============================================================
-- End of Module 2.10 practice queries.
-- ============================================================
