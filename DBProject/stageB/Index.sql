-- =========================================================
-- INDEX 1
-- Improve search by supply order date
-- =========================================================

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id
FROM SupplyOrder
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date;

-- CREATE INDEX
CREATE INDEX idx_supplyorder_order_date
ON SupplyOrder(order_date);

-- AFTER INDEX
EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id
FROM SupplyOrder
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY order_date;


-- =========================================================
-- INDEX 2
-- Improve search by product price
-- =========================================================

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT
    p_id,
    p_name,
    p_price,
    p_weight,
    p_data
FROM Product
WHERE p_price > 1000
ORDER BY p_price DESC;

-- CREATE INDEX
CREATE INDEX idx_product_price
ON Product(p_price);

-- AFTER INDEX
EXPLAIN ANALYZE
SELECT
    p_id,
    p_name,
    p_price,
    p_weight,
    p_data
FROM Product
WHERE p_price > 1000
ORDER BY p_price DESC;


-- =========================================================
-- INDEX 3
-- Improve search by employee department
-- =========================================================

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    role,
    e_id
FROM Employee
WHERE e_id = 1;

-- CREATE INDEX
CREATE INDEX idx_employee_department
ON Employee(e_id);

-- AFTER INDEX
EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    role,
    e_id
FROM Employee
WHERE e_id = 1;