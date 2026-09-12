-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.7: Retrieving Data -- SELECT Basics
-- ShopEasy E-Commerce Database -- Practice Queries
-- ============================================================
-- Prerequisite: Modules 1.5 and 1.6 must already have been run
-- (shopeasy database with populated customers and categories tables).
-- ============================================================

USE shopeasy;

-- ============================================================
-- 1. SELECT * -- retrieve all columns (exploration)
-- ============================================================
SELECT * FROM customers;
SELECT * FROM categories;

-- ============================================================
-- 2. Selecting specific columns
-- ============================================================
SELECT first_name, last_name, city
FROM customers;

-- Column order in the query controls column order in the output
SELECT city, first_name
FROM customers;

-- ============================================================
-- 3. Column aliasing with AS
-- ============================================================
SELECT
    first_name AS "First Name",
    last_name  AS "Last Name",
    city       AS "Customer City"
FROM customers;

-- Alias without spaces -- quotes not required
SELECT first_name AS fname, 
       last_name AS lname
FROM customers;

-- ============================================================
-- 4. Combining specific columns + aliases (report-ready output)
-- ============================================================
SELECT
    customer_id       AS "Customer ID",
    first_name        AS "First Name",
    city              AS "City",
    registration_date AS "Joined On"
FROM customers;

SELECT
    category_id    AS "ID",
    category_name  AS "Category"
FROM categories;

-- ============================================================
-- 5. Practical Session Task -- marketing outreach columns
-- ============================================================
SELECT
    first_name AS "First Name",
    last_name  AS "Last Name",
    email      AS "Email Address"
FROM customers;

-- ============================================================
-- End of Module 1.7 script.
-- No data was modified -- SELECT only retrieves and displays data.
-- ============================================================
