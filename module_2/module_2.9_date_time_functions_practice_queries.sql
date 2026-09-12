-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.9: Date & Time Functions
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. CURDATE and NOW -- Current date/time
-- ============================================================
SELECT CURDATE() AS today;
SELECT NOW() AS current_datetime;
SELECT CURRENT_DATE AS today_alt;
SELECT CURRENT_TIMESTAMP AS now_alt;

-- ============================================================
-- 2. DATEDIFF -- Days between two dates
-- ============================================================

-- Days since each customer registered (relative to Jan 31, 2024)
SELECT
    customer_id,
    first_name,
    registration_date,
    DATEDIFF('2024-01-31', registration_date) AS days_registered
FROM customers
ORDER BY days_registered DESC;

-- Days since each order was placed
SELECT
    order_id,
    order_date,
    status,
    DATEDIFF('2024-01-31', order_date) AS days_old
FROM orders
ORDER BY days_old DESC;

-- Orders placed more than 20 days ago
SELECT order_id, order_date, status
FROM orders
WHERE DATEDIFF('2024-01-31', order_date) > 20;

-- ============================================================
-- 3. DATE_ADD and DATE_SUB -- Date arithmetic
-- ============================================================

-- Estimated delivery: 5 days after order_date
SELECT
    order_id,
    order_date,
    DATE_ADD(order_date, INTERVAL 5 DAY) AS estimated_delivery
FROM orders
ORDER BY order_date;

-- Orders placed in the last 10 days of January (after Jan 21)
SELECT order_id, order_date, total_amount
FROM orders
WHERE order_date > DATE_SUB('2024-01-31', INTERVAL 10 DAY)
ORDER BY order_date DESC;

-- 30-day warranty expiry for each order
SELECT
    order_id,
    order_date,
    DATE_ADD(order_date, INTERVAL 30 DAY) AS warranty_expiry
FROM orders;

-- ============================================================
-- 4. DATE_FORMAT -- Formatting dates for display
-- ============================================================
SELECT
    order_id,
    order_date,
    DATE_FORMAT(order_date, '%d %M %Y') AS formatted_long,
    DATE_FORMAT(order_date, '%W, %d %b %Y') AS formatted_full,
    DATE_FORMAT(order_date, '%d/%m/%Y') AS formatted_short,
    DATE_FORMAT(order_date, '%M %Y') AS month_year
FROM orders
ORDER BY order_date;

-- ============================================================
-- 5. YEAR, MONTH, DAY -- Extracting date parts
-- ============================================================

-- Extract year, month, day from order_date
SELECT
    order_id,
    order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    DAY(order_date) AS order_day,
    MONTHNAME(order_date) AS month_name,
    DAYNAME(order_date) AS day_name
FROM orders;

-- Daily revenue breakdown for January 2024
SELECT
    DAY(order_date) AS day_of_month,
    COUNT(*) AS order_count,
    SUM(total_amount) AS daily_revenue
FROM orders
WHERE YEAR(order_date) = 2024 AND MONTH(order_date) = 1
GROUP BY DAY(order_date)
ORDER BY day_of_month ASC;

-- Monthly revenue (useful for multi-month datasets)
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS orders,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY order_year, order_month;

-- ============================================================
-- 6. DAYNAME and WEEKDAY -- Day of week analysis
-- ============================================================

-- Revenue and orders per weekday (Mon-Sun order)
SELECT
    DAYNAME(order_date) AS day_name,
    WEEKDAY(order_date) AS weekday_num,
    COUNT(*) AS orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY DAYNAME(order_date), WEEKDAY(order_date)
ORDER BY weekday_num ASC;

-- Only Monday orders
SELECT order_id, order_date, total_amount
FROM orders
WHERE WEEKDAY(order_date) = 0;  -- 0 = Monday

-- ============================================================
-- 7. TIMESTAMPDIFF -- Difference in specified unit
-- ============================================================

-- Months each customer has been registered
SELECT
    customer_id,
    first_name,
    registration_date,
    TIMESTAMPDIFF(MONTH, registration_date, '2024-01-31') AS months_registered,
    TIMESTAMPDIFF(YEAR,  registration_date, '2024-01-31') AS years_registered
FROM customers
ORDER BY months_registered DESC;

-- ============================================================
-- 8. LAST_DAY and QUARTER
-- ============================================================

-- Days remaining in the month after each order
SELECT
    order_id,
    order_date,
    LAST_DAY(order_date) AS last_day_of_month,
    DATEDIFF(LAST_DAY(order_date), order_date) AS days_remaining_in_month
FROM orders
ORDER BY days_remaining_in_month ASC;

-- Quarterly aggregation
SELECT
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    COUNT(*) AS orders,
    ROUND(SUM(total_amount), 2) AS quarterly_revenue
FROM orders
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY year, quarter;

-- ============================================================
-- 9. Combined: Customer registration age + tier classification
-- ============================================================
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    DATE_FORMAT(registration_date, '%d %b %Y') AS reg_date_formatted,
    DATEDIFF('2024-01-31', registration_date) AS days_registered,
    TIMESTAMPDIFF(MONTH, registration_date, '2024-01-31') AS months_registered,
    CASE
        WHEN DATEDIFF('2024-01-31', registration_date) > 15 THEN 'Veteran'
        WHEN DATEDIFF('2024-01-31', registration_date) >= 8  THEN 'Regular'
        ELSE 'New'
    END AS customer_tier
FROM customers
ORDER BY days_registered DESC;

-- ============================================================
-- 10. Estimated delivery + overdue flag
-- ============================================================
SELECT
    order_id,
    DATE_FORMAT(order_date, '%d %b %Y') AS order_date_fmt,
    DATE_FORMAT(DATE_ADD(order_date, INTERVAL 5 DAY), '%d %b %Y') AS est_delivery_fmt,
    status,
    CASE
        WHEN DATE_ADD(order_date, INTERVAL 5 DAY) < '2024-01-31'
         AND status != 'Delivered' THEN 'Overdue'
        ELSE 'On Track'
    END AS delivery_status
FROM orders
ORDER BY order_date;

-- ============================================================
-- End of Module 2.9 practice queries.
-- ============================================================
