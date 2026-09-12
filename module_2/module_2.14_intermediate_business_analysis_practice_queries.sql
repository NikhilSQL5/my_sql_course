-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.14: Intermediate Business Analysis
-- ShopEasy E-Commerce Database -- Seven Business Reports
-- ============================================================

USE shopeasy;

-- ============================================================
-- REPORT 1: Customer Value Segmentation
-- LEFT JOIN + COALESCE + CASE WHEN on aggregate
-- ============================================================
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(c.city, 'Unknown') AS city,
    COUNT(o.order_id) AS total_orders,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2) AS total_spent,
    DATE_FORMAT(MAX(o.order_date), '%d %b %Y') AS last_order_date,
    CASE
        WHEN SUM(o.total_amount) > 80000  THEN 'VIP'
        WHEN SUM(o.total_amount) > 30000  THEN 'High Value'
        WHEN SUM(o.total_amount) > 5000   THEN 'Regular'
        ELSE 'New'
    END AS customer_tier
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC;

-- ============================================================
-- REPORT 2: Product Performance Analysis
-- 3-table JOIN + LEFT JOIN + COALESCE + CASE WHEN
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    cat.category_name,
    p.price,
    p.stock_quantity,
    COALESCE(COUNT(oi.order_item_id), 0) AS times_ordered,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS revenue_generated,
    CASE
        WHEN COUNT(oi.order_item_id) = 0  THEN 'Dead Stock'
        WHEN COUNT(oi.order_item_id) >= 3 THEN 'Top Seller'
        ELSE 'Active'
    END AS stock_status
FROM products AS p
INNER JOIN categories AS cat ON p.category_id  = cat.category_id
LEFT JOIN  order_items AS oi  ON p.product_id   = oi.product_id
GROUP BY p.product_id, p.product_name, cat.category_name, p.price, p.stock_quantity
ORDER BY revenue_generated DESC;

-- ============================================================
-- REPORT 3: Daily Revenue Trend
-- GROUP BY date + DATE_FORMAT
-- ============================================================
SELECT
    order_date,
    DATE_FORMAT(order_date, '%W') AS day_of_week,
    DATE_FORMAT(order_date, '%d %b %Y')  AS formatted_date,
    COUNT(order_id) AS orders,
    ROUND(SUM(total_amount), 2) AS daily_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY order_date
ORDER BY order_date ASC;

-- ============================================================
-- REPORT 4A: Order Status Pipeline with ROLLUP
-- WITH ROLLUP + GROUPING()
-- ============================================================
SELECT
    CASE WHEN GROUPING(status) = 1
         THEN 'GRAND TOTAL'
         ELSE status
    END AS order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value
FROM orders
GROUP BY status WITH ROLLUP
ORDER BY GROUPING(status), total_revenue DESC;

-- ============================================================
-- REPORT 4B: Pivot Row -- All Statuses in One Row
-- Conditional aggregation (CASE inside COUNT and SUM)
-- ============================================================
SELECT
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN status = 'Delivered'  THEN 1 END) AS delivered,
    COUNT(CASE WHEN status = 'Shipped'    THEN 1 END) AS shipped,
    COUNT(CASE WHEN status = 'Pending'    THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'Cancelled'  THEN 1 END) AS cancelled,
    ROUND(SUM(CASE WHEN status = 'Delivered'
        THEN total_amount ELSE 0 END), 2) AS delivered_revenue,
    ROUND(SUM(CASE WHEN status IN ('Pending','Shipped')
        THEN total_amount ELSE 0 END), 2) AS revenue_at_risk,
    ROUND(SUM(CASE WHEN status = 'Cancelled'
        THEN total_amount ELSE 0 END), 2) AS lost_revenue
FROM orders;

-- ============================================================
-- REPORT 5: Category Revenue with GST (18%)
-- 3-table JOIN + COUNT(DISTINCT) + GST calculation
-- ============================================================
SELECT
    cat.category_name,
    COUNT(DISTINCT p.product_id) AS unique_products_sold,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue_excl_gst,
    ROUND(SUM(oi.quantity * oi.unit_price) * 0.18, 2) AS gst_18pct,
    ROUND(SUM(oi.quantity * oi.unit_price) * 1.18, 2) AS revenue_incl_gst
FROM categories AS cat
INNER JOIN products AS p  ON cat.category_id = p.category_id
INNER JOIN order_items AS oi ON p.product_id    = oi.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY revenue_excl_gst DESC;

-- ============================================================
-- REPORT 6: Customer Geographic & Engagement Analysis
-- LEFT JOIN + DATEDIFF + NULLIF division + CASE WHEN
-- ============================================================
SELECT
    COALESCE(c.city, 'Unknown') AS city,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COUNT(o.order_id) AS total_orders,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2)  AS total_city_revenue,
    ROUND(COALESCE(SUM(o.total_amount), 0) / NULLIF(COUNT(DISTINCT c.customer_id), 0), 2) AS avg_spend_per_customer,
    ROUND(AVG(DATEDIFF('2024-01-31', c.registration_date)), 0) AS avg_days_registered,
    CASE
        WHEN COALESCE(SUM(o.total_amount), 0) / NULLIF(COUNT(DISTINCT c.customer_id), 0) > 10000 THEN 'High Engagement'
        ELSE 'Standard'
    END AS engagement_level
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_city_revenue DESC;

-- ============================================================
-- REPORT 7: Complete Order Detail Report
-- 4-table JOIN + DATE_FORMAT + DATEDIFF + GST + CASE WHEN
-- ============================================================
SELECT
    o.order_id,
    DATE_FORMAT(o.order_date, '%d %b %Y') AS order_date,
    DATEDIFF('2024-01-31', o.order_date) AS days_ago,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COALESCE(c.city, 'Unknown') AS customer_city,
    p.product_name,
    cat.category_name,
    oi.quantity,
    ROUND(oi.unit_price, 2) AS unit_price,
    ROUND(oi.quantity * oi.unit_price, 2) AS line_total,
    ROUND(oi.quantity * oi.unit_price * 1.18, 2) AS line_total_incl_gst,
    o.status,
    CASE
        WHEN o.status = 'Delivered' THEN 'Complete'
        WHEN o.status = 'Shipped'   THEN 'In Transit'
        WHEN o.status = 'Pending'   THEN 'Processing'
        WHEN o.status = 'Cancelled' THEN 'Cancelled'
        ELSE 'Unknown'
    END AS status_label
FROM orders AS o
INNER JOIN customers   AS c   ON o.customer_id  = c.customer_id
INNER JOIN order_items AS oi  ON o.order_id     = oi.order_id
INNER JOIN products    AS p   ON oi.product_id  = p.product_id
INNER JOIN categories  AS cat ON p.category_id  = cat.category_id
ORDER BY o.order_date DESC, o.order_id ASC;

-- ============================================================
-- PRACTICE QUESTIONS
-- ============================================================

-- Q1: Customer Loyalty Report (Gold/Silver/Bronze/Inactive)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COALESCE(c.city, 'Unknown') AS city,
    COUNT(o.order_id) AS total_orders,
    ROUND(COALESCE(SUM(o.total_amount), 0), 2)  AS total_spent,
    CASE
        WHEN COALESCE(SUM(o.total_amount), 0) > 50000 THEN 'Gold'
        WHEN COALESCE(SUM(o.total_amount), 0) > 10000 THEN 'Silver'
        WHEN COALESCE(SUM(o.total_amount), 0) > 0 THEN 'Bronze'
        ELSE 'Inactive'
    END  AS loyalty_tier
FROM customers AS c
LEFT JOIN orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
ORDER BY total_spent DESC;

-- Q2: Product Stock Alert
SELECT
    p.product_name,
    cat.category_name,
    p.price,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS units_sold,
    CASE
        WHEN p.stock_quantity < 25 THEN 'Critical'
        WHEN p.stock_quantity < 50 THEN 'Low'
        ELSE 'OK'
    END AS stock_alert
FROM products AS p
INNER JOIN categories  AS cat ON p.category_id = cat.category_id
LEFT JOIN  order_items AS oi  ON p.product_id  = oi.product_id
GROUP BY p.product_id, p.product_name, cat.category_name,
         p.price, p.stock_quantity
ORDER BY p.stock_quantity ASC;

-- Q5: Top 5 Products by Revenue
SELECT
    p.product_name,
    cat.category_name,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price) * 1.18, 2) AS revenue_incl_gst
FROM products AS p
INNER JOIN categories  AS cat ON p.category_id = cat.category_id
INNER JOIN order_items AS oi  ON p.product_id  = oi.product_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Q6: Complete Dashboard with ROLLUP + % of total + priority label
SELECT
    CASE WHEN GROUPING(status) = 1 THEN 'GRAND TOTAL'
         ELSE status END AS order_status,
    COUNT(*) AS order_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND(SUM(total_amount) / (SELECT SUM(total_amount) FROM orders) * 100, 1)   AS pct_of_total,
    CASE
        WHEN GROUPING(status) = 1 THEN 'Summary'
        WHEN status = 'Pending' THEN 'Urgent'
        WHEN status = 'Shipped' THEN 'Monitor'
        ELSE 'Archive'
    END AS priority_label
FROM orders
GROUP BY status WITH ROLLUP
ORDER BY GROUPING(status),
         CASE status
             WHEN 'Pending' THEN 1
             WHEN 'Shipped' THEN 2
             ELSE 3
         END,
         total_revenue DESC;

-- ============================================================
-- End of Module 2.14 practice queries.
-- ============================================================
