-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 2.4: SELF JOIN & CROSS JOIN
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================

USE shopeasy;

-- ============================================================
-- STEP 1: Create and populate the employees table
-- ============================================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    job_title   VARCHAR(50),
    manager_id  INT,
    region      VARCHAR(50)
);

INSERT INTO employees (full_name, job_title, manager_id, region)
VALUES
    ('Priya Menon',   'CEO',             NULL, 'Head Office'),
    ('Rahul Gupta',   'Sales Manager',      1, 'North'),
    ('Sneha Iyer',    'Tech Manager',        1, 'South'),
    ('Aman Verma',    'Sales Executive',     2, 'North'),
    ('Kiran Das',     'Sales Executive',     2, 'East'),
    ('Neha Kapoor',   'Developer',           3, 'South'),
    ('Rohit Sharma',  'Developer',           3, 'West'),
    ('Ananya Singh',  'Support Agent',       2, 'North');

SELECT * FROM employees;

-- ============================================================
-- SELF JOIN SECTION
-- ============================================================

-- 1. Employee-Manager hierarchy -- INNER JOIN (CEO excluded)
SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.job_title,
    m.full_name AS manager_name
FROM employees AS e
INNER JOIN employees AS m ON e.manager_id = m.employee_id
ORDER BY e.employee_id ASC;

-- 2. Employee-Manager hierarchy -- LEFT JOIN (CEO included)
SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.job_title,
    m.full_name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m ON e.manager_id = m.employee_id
ORDER BY ISNULL(e.manager_id), e.employee_id ASC;

-- 3. Direct reports count per manager
SELECT
    m.full_name AS manager_name,
    COUNT(e.employee_id) AS direct_reports
FROM employees AS e
INNER JOIN employees AS m ON e.manager_id = m.employee_id
GROUP BY m.employee_id, m.full_name
ORDER BY direct_reports DESC;

-- 4. Same-city customer pairs (SELF JOIN on customers)
SELECT
    c1.first_name AS customer_1,
    c2.first_name AS customer_2,
    c1.city
FROM customers AS c1
INNER JOIN customers AS c2
    ON  c1.city = c2.city
    AND c1.customer_id < c2.customer_id
ORDER BY c1.city, c1.first_name;

-- ============================================================
-- CROSS JOIN SECTION
-- ============================================================

-- 5. All customer-category combinations (12 x 6 = 72 rows)
SELECT
    c.first_name AS customer,
    cat.category_name AS category
FROM customers AS c
CROSS JOIN categories AS cat
ORDER BY c.first_name, cat.category_name;

-- Confirm row count
SELECT COUNT(*) AS total_combinations
FROM customers
CROSS JOIN categories;

-- 6. All product-category combinations (20 x 6 = 120 rows)
SELECT
    p.product_name,
    cat.category_name
FROM products AS p
CROSS JOIN categories AS cat
ORDER BY p.product_name, cat.category_name
LIMIT 10;  -- limit for display only

-- 7. CROSS JOIN vs accidental comma join (IDENTICAL results)
-- Explicit CROSS JOIN (preferred)
SELECT c.first_name, cat.category_name
FROM customers AS c
CROSS JOIN categories AS cat
LIMIT 5;

-- Old comma syntax (accidental CROSS JOIN -- AVOID)
-- SELECT c.first_name, cat.category_name
-- FROM customers c, categories cat
-- LIMIT 5;

-- ============================================================
-- End of Module 2.4 practice queries.
-- ============================================================
