-- =========================================================
-- Stage C - Integration
-- This file contains the SQL commands used to integrate
-- the original database with the received department database.
-- Existing tables are not recreated. Instead, we add only the
-- missing tables, columns, and relationships needed for integration.
-- =========================================================


-- =========================================================
-- 1. Add Collection table
-- =========================================================
CREATE TABLE IF NOT EXISTS Collection (
    collection_id INT PRIMARY KEY,
    collection_name VARCHAR(100),
    season VARCHAR(50),
    year INT,
    release_date DATE
);


-- =========================================================
-- 2. Add Model table
-- =========================================================
CREATE TABLE IF NOT EXISTS Model (
    model_id INT PRIMARY KEY,
    model_name VARCHAR(100),
    clothing_type VARCHAR(50),
    description_json JSON,
    work_time DOUBLE PRECISION,
    collection_id INT,
    FOREIGN KEY (collection_id) REFERENCES Collection(collection_id)
);


-- =========================================================
-- 3. Connect Product to Model
-- =========================================================
ALTER TABLE Product
ADD COLUMN IF NOT EXISTS model_id INT;


-- Add foreign key from Product to Model
ALTER TABLE Product
ADD CONSTRAINT fk_product_model
FOREIGN KEY (model_id)
REFERENCES Model(model_id);


-- =========================================================
-- 4. Add Required table
-- This table represents a many-to-many relationship
-- =========================================================
CREATE TABLE IF NOT EXISTS Required (
    model_id INT,
    r_id INT,
    amount DOUBLE PRECISION,
    PRIMARY KEY (model_id, r_id),
    FOREIGN KEY (model_id) REFERENCES Model(model_id),
    FOREIGN KEY (r_id) REFERENCES RawMaterial(r_id)
);


-- =========================================================
-- 5. Add Works_On table
-- This table represents a many-to-many relationship
-- =========================================================
CREATE TABLE IF NOT EXISTS Works_On (
    employee_id INT,
    model_id INT,
    hours DOUBLE PRECISION,
    PRIMARY KEY (employee_id, model_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(e_id),
    FOREIGN KEY (model_id) REFERENCES Model(model_id)
);


-- =========================================================
-- 6. Add Supplied_By table
-- =========================================================
CREATE TABLE IF NOT EXISTS Supplied_By (
    supplier_id INT,
    r_id INT,
    unit_price DOUBLE PRECISION,
    PRIMARY KEY (supplier_id, r_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(s_id),
    FOREIGN KEY (r_id) REFERENCES RawMaterial(r_id)
);


-- =========================================================
-- 7. Verify that data exists in the integrated database
-- =========================================================
SELECT COUNT(*) AS total_collections FROM Collection;
SELECT COUNT(*) AS total_models FROM Model;
SELECT COUNT(*) AS total_products FROM Product;
SELECT COUNT(*) AS total_raw_materials FROM RawMaterial;
SELECT COUNT(*) AS total_suppliers FROM Supplier;
SELECT COUNT(*) AS total_employees FROM Employee;
SELECT COUNT(*) AS total_required FROM Required;
SELECT COUNT(*) AS total_works_on_model FROM Works_On_Model;
SELECT COUNT(*) AS total_supplied_by FROM Supplied_By;