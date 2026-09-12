-- ============================================================
-- MySQL for Data Analysts -- Master Course
-- Module 1.5: Creating Your First Database & Table
-- ShopEasy E-Commerce Database -- Initial Schema Setup
-- ============================================================
-- Run this script top to bottom in MySQL Workbench.
-- Compatible with MySQL 8.0+
-- ============================================================
-- DROP DATABASE shopeasy;

-- STEP 1: Create the ShopEasy database
-- IF NOT EXISTS prevents an error if this script is run more than once
CREATE DATABASE IF NOT EXISTS shopeasy;

-- STEP 2: Set ShopEasy as the active database for all following commands
USE shopeasy;

-- ============================================================
-- STEP 3: Create the customers table
-- Stores one row per ShopEasy customer
-- ============================================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id          INT AUTO_INCREMENT PRIMARY KEY,
    first_name           VARCHAR(50)  NOT NULL,
    last_name            VARCHAR(50)  NOT NULL,
    email                VARCHAR(100) NOT NULL UNIQUE,
    phone                VARCHAR(15),
    city                 VARCHAR(50),
    registration_date    DATE DEFAULT (CURRENT_DATE)
);

-- ============================================================
-- STEP 4: Create the categories table
-- A lookup table for product categories (linked to products in Module 1.6)
-- ============================================================
CREATE TABLE IF NOT EXISTS categories (
    category_id     INT AUTO_INCREMENT PRIMARY KEY,
    category_name   VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================================
-- STEP 5: Verify both tables were created correctly
-- ============================================================
DESCRIBE customers;
DESCRIBE categories;

-- ============================================================
-- End of Module 1.5 script.
-- Both tables exist but are currently EMPTY.
-- Data will be inserted in Module 1.6 using INSERT INTO.
-- ============================================================
