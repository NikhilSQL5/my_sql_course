-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.8: Numeric Functions
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. ROUND -- Rounding to decimal places
-- ============================================================

-- Round average order value to 2 dp
SELECT ROUND(AVG(total_amount), 2) AS avg_order_value FROM orders;

-- Round product prices to nearest 100 rupees (negative d)
SELECT product_name, price, ROUND(price, -2) AS rounded_to_100 FROM products;

-- Round prices to nearest 10,000
SELECT product_name, price, ROUND(price, -4) AS price_band FROM products
ORDER BY price_band DESC;

-- ============================================================
-- 2. CEIL and FLOOR -- Always up or always down
-- ============================================================

-- Compare ROUND vs CEIL vs FLOOR on the same values
SELECT
    price,
    ROUND(price) AS rounded,
    CEIL(price)  AS ceil_up,
    FLOOR(price) AS floor_down
FROM products
ORDER BY price DESC
LIMIT 5;

-- Number of 1000-rupee price tiers a product spans (CEIL)
SELECT
    product_name,
    price,
    CEIL(price / 1000) AS price_tier_ceil,
    FLOOR(price / 1000) AS price_tier_floor
FROM products
ORDER BY price DESC;

-- ============================================================
-- 3. TRUNCATE -- Cut off decimals without rounding
-- ============================================================

-- Compare ROUND vs TRUNCATE
SELECT
    price,
    ROUND(price, 0) AS rounded,
    TRUNCATE(price, 0) AS truncated
FROM products
ORDER BY price DESC;

-- ============================================================
-- 4. ABS -- Absolute value / deviation from average
-- ============================================================

-- Each product's price deviation from the catalogue average
SELECT
    product_name,
    price,
    ROUND((SELECT AVG(price) FROM products), 2) AS avg_price,
    ROUND(ABS(price - (SELECT AVG(price) FROM products)), 2) AS deviation
FROM products
ORDER BY deviation DESC;

-- Each order's deviation from average order value
SELECT
    order_id,
    total_amount,
    ROUND(ABS(total_amount - (SELECT AVG(total_amount) FROM orders)), 2) AS deviation_from_avg
FROM orders
ORDER BY deviation_from_avg DESC;

-- ============================================================
-- 5. MOD -- Modulus / remainder
-- ============================================================

-- Even-numbered order IDs
SELECT order_id, total_amount
FROM orders
WHERE MOD(order_id, 2) = 0;

-- Odd-numbered order IDs
SELECT order_id, total_amount
FROM orders
WHERE MOD(order_id, 2) = 1;

-- Assign orders to 2 pipelines using CASE WHEN + MOD
SELECT
    order_id,
    total_amount,
    CASE WHEN MOD(order_id, 2) = 0 THEN 'Pipeline A' ELSE 'Pipeline B' END AS pipeline
FROM orders
ORDER BY pipeline, order_id;

-- Revenue and count per pipeline (GROUP BY + MOD)
SELECT
    CASE WHEN MOD(order_id, 2) = 0 THEN 'Pipeline A' ELSE 'Pipeline B' END AS pipeline,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
GROUP BY pipeline;

-- ============================================================
-- 6. POWER and SQRT
-- ============================================================

-- 3-year price projection at 8% annual growth
SELECT
    product_name,
    price AS current_price,
    ROUND(price * POWER(1.08, 3), 2) AS projected_price_3yr
FROM products
ORDER BY projected_price_3yr DESC;

-- Geometric mean price (SQRT of product of min * max)
SELECT ROUND(SQRT(MIN(price) * MAX(price)), 2) AS geometric_mean_price
FROM products;

-- ============================================================
-- 7. GREATEST and LEAST
-- ============================================================

-- Minimum of stock_quantity*100 and price (whichever is lower)
SELECT
    product_name,
    price,
    stock_quantity,
    LEAST(price, stock_quantity * 100) AS least_val,
    GREATEST(price, stock_quantity * 100) AS greatest_val
FROM products
LIMIT 8;

-- ============================================================
-- 8. RAND -- Random sampling
-- ============================================================

-- Select 5 random products for a flash sale
SELECT product_name, price
FROM products
ORDER BY RAND()
LIMIT 5;

-- ============================================================
-- 9. Financial report -- ROUND applied to all aggregates
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND(MIN(total_amount), 2) AS min_order,
    ROUND(MAX(total_amount), 2) AS max_order,
    ROUND(MAX(total_amount) - MIN(total_amount), 2) AS order_range
FROM orders;

-- ============================================================
-- 10. GST pricing table (Indian e-commerce standard)
-- ============================================================
SELECT
    product_name,
    price AS price_excl_gst,
    ROUND(price * 0.18, 2) AS gst_18pct,
    ROUND(price * 1.18, 2) AS price_incl_gst
FROM products
ORDER BY price DESC;

-- ============================================================
-- 11. Loyalty discount with ROUND + CASE WHEN
-- ============================================================
SELECT
    order_id,
    total_amount,
    ROUND(
        CASE
            WHEN total_amount >= 50000 THEN total_amount * 0.05
            WHEN total_amount >= 10000 THEN total_amount * 0.02
            ELSE 0
        END, 2
    ) AS discount_amount,
    ROUND(
        total_amount - CASE
            WHEN total_amount >= 50000 THEN total_amount * 0.05
            WHEN total_amount >= 10000 THEN total_amount * 0.02
            ELSE 0
        END, 2
    ) AS final_amount
FROM orders
ORDER BY total_amount DESC;

-- ============================================================
-- End of Module 2.8 practice queries.
-- ============================================================
