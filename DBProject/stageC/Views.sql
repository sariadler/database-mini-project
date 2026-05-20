-- =========================================================
-- Stage C - Views
-- This file contains 3 views:
-- 1. A view from the original department perspective
-- 2. A view from the received department perspective
-- 3. An integrated view that combines both systems
--
-- For each view:
-- - We create the view
-- - We display data using SELECT *
-- - We run 2 meaningful queries on the view
-- =========================================================


-- =========================================================
-- VIEW 1
-- Original department perspective:
-- Products and their production departments
-- =========================================================

CREATE OR REPLACE VIEW view_product_department AS
SELECT
    p.p_id,
    p.p_name,
    p.p_price,
    d.de_name AS department_name,
    pl.pl_id
FROM Product p
JOIN Product_Line pl
    ON p.pl_id = pl.pl_id
JOIN Department d
    ON pl.de_id = d.de_id;


-- Display 10 records from VIEW 1
SELECT *
FROM view_product_department
LIMIT 10;


-- Query 1 on VIEW 1:
-- Products with price greater than 200
SELECT *
FROM view_product_department
WHERE p_price > 200;


-- Query 2 on VIEW 1:
-- Count products per department
SELECT
    department_name,
    COUNT(p_id) AS total_products
FROM view_product_department
GROUP BY department_name
ORDER BY total_products DESC;



-- =========================================================
-- VIEW 2
-- Received department perspective:
-- Models and their collections
-- =========================================================

CREATE OR REPLACE VIEW view_model_collection AS
SELECT
    m.model_id,
    m.model_name,
    m.clothing_type,
    c.collection_name,
    c.season,
    c.year
FROM Model m
JOIN Collection c
    ON m.collection_id = c.collection_id;


-- Display 10 records from VIEW 2
SELECT *
FROM view_model_collection
LIMIT 10;


-- Query 1 on VIEW 2:
-- Models from winter collections
SELECT *
FROM view_model_collection
WHERE season = 'Winter';


-- Query 2 on VIEW 2:
-- Count models per collection
SELECT
    collection_name,
    COUNT(model_id) AS total_models
FROM view_model_collection
GROUP BY collection_name
ORDER BY total_models DESC;



-- =========================================================
-- VIEW 3
-- Integrated perspective:
-- Products, models and collections
-- =========================================================

CREATE OR REPLACE VIEW view_integrated_products AS
SELECT
    p.p_id,
    p.p_name,
    p.p_price,
    m.model_name,
    m.clothing_type,
    c.collection_name,
    c.season
FROM Product p
JOIN Model m
    ON p.model_id = m.model_id
JOIN Collection c
    ON m.collection_id = c.collection_id;


-- Display 10 records from VIEW 3
SELECT *
FROM view_integrated_products
LIMIT 10;


-- Query 1 on VIEW 3:
-- Products from summer collections
SELECT *
FROM view_integrated_products
WHERE season = 'Summer';


-- Query 2 on VIEW 3:
-- Average product price per collection
SELECT
    collection_name,
    AVG(p_price) AS average_price
FROM view_integrated_products
GROUP BY collection_name
ORDER BY average_price DESC;