-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.6: Conditional Logic -- CASE WHEN
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. Searched CASE WHEN in SELECT -- Order value tier
-- ============================================================
SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount >= 50000 THEN 'Premium'
        WHEN total_amount >= 10000 THEN 'High Value'
        WHEN total_amount >= 2000  THEN 'Mid Range'
        ELSE 'Economy'
    END AS order_tier
FROM orders
ORDER BY total_amount DESC;

-- ============================================================
-- 2. Simple CASE WHEN -- Status description
-- ============================================================
SELECT
    order_id,
    status,
    CASE status
        WHEN 'Delivered' THEN 'Order Complete'
        WHEN 'Shipped'   THEN 'In Transit'
        WHEN 'Pending'   THEN 'Awaiting Processing'
        WHEN 'Cancelled' THEN 'Order Cancelled'
        ELSE                   'Unknown Status'
    END AS status_description
FROM orders;

-- ============================================================
-- 3. Product price tier classification
-- ============================================================
SELECT
    product_name,
    price,
    CASE
        WHEN price >= 50000 THEN 'Luxury'
        WHEN price >= 10000 THEN 'Premium'
        WHEN price >= 1000  THEN 'Mid Range'
        ELSE 'Budget'
    END AS price_tier
FROM products
ORDER BY price DESC;

-- ============================================================
-- 4. CASE WHEN + GROUP BY -- Segmentation report
-- Count and revenue per order value tier
-- ============================================================
SELECT
    CASE
        WHEN total_amount >= 50000 THEN 'Premium'
        WHEN total_amount >= 10000 THEN 'High Value'
        WHEN total_amount >= 2000  THEN 'Mid Range'
        ELSE                           'Economy'
    END AS order_tier,
    COUNT(*) AS order_count,
    SUM(total_amount) AS tier_revenue
FROM orders
GROUP BY order_tier
ORDER BY tier_revenue DESC;

-- ============================================================
-- 5. Conditional aggregation -- CASE inside COUNT and SUM
-- All status metrics in ONE single query row
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'Delivered' THEN 1 END) AS delivered_count,
    COUNT(CASE WHEN status = 'Pending'   THEN 1 END) AS pending_count,
    COUNT(CASE WHEN status = 'Cancelled' THEN 1 END) AS cancelled_count,
    COUNT(CASE WHEN status = 'Shipped'   THEN 1 END) AS shipped_count,
    SUM(CASE WHEN status = 'Delivered'   THEN total_amount ELSE 0 END) AS delivered_revenue,
    SUM(CASE WHEN status = 'Cancelled'   THEN total_amount ELSE 0 END) AS cancelled_revenue
FROM orders;

-- ============================================================
-- 6. CASE WHEN in ORDER BY -- Custom sort priority
-- Pending orders first, then Shipped, Delivered, Cancelled
-- ============================================================
SELECT order_id, status, total_amount
FROM orders
ORDER BY
    CASE status
        WHEN 'Pending' THEN 1
        WHEN 'Shipped' THEN 2
        WHEN 'Delivered' THEN 3
        WHEN 'Cancelled' THEN 4
        ELSE                  5
    END ASC,
    total_amount DESC;

-- ============================================================
-- 7. Customer engagement classification
-- LEFT JOIN + CASE WHEN + GROUP BY
-- ============================================================
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    CASE
        WHEN COUNT(o.order_id) > 0 THEN 'Active'
        ELSE 'Inactive'
    END AS engagement_status
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- ============================================================
-- 8. Discount pricing using CASE WHEN in SELECT expressions
-- ============================================================
SELECT
    product_name,
    price AS original_price,
    CASE
        WHEN price > 50000  THEN 20
        WHEN price >= 10000 THEN 10
        WHEN price >= 1000  THEN 5
        ELSE 0
    END AS discount_pct,
    ROUND(
        price * (1 - CASE
            WHEN price > 50000  THEN 0.20
            WHEN price >= 10000 THEN 0.10
            WHEN price >= 1000  THEN 0.05
            ELSE                     0
        END), 2
    ) AS discounted_price
FROM products
ORDER BY price DESC;

-- ============================================================
-- 9. Revenue pivot -- all statuses in columns (one row result)
-- ============================================================
SELECT
    SUM(total_amount) AS total_revenue,
    SUM(CASE WHEN status = 'Delivered' THEN total_amount ELSE 0 END) AS delivered_revenue,
    SUM(CASE WHEN status = 'Shipped'   THEN total_amount ELSE 0 END) AS shipped_revenue,
    SUM(CASE WHEN status = 'Pending'   THEN total_amount ELSE 0 END) AS pending_revenue,
    SUM(CASE WHEN status = 'Cancelled' THEN total_amount ELSE 0 END) AS cancelled_revenue
FROM orders;

-- ============================================================
-- End of Module 2.6 practice queries.
-- ============================================================
