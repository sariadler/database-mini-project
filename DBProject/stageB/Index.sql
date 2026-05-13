-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id
FROM SupplyOrder
WHERE order_date = '2024-01-01'
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
WHERE order_date = '2024-01-01'
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
-- Improve search by employee date
-- =========================================================

-- BEFORE INDEX
EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    e_date,
    role
FROM Employee
WHERE e_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY e_date;

-- CREATE INDEX
CREATE INDEX idx_employee_date
ON Employee(e_date);

-- AFTER INDEX
EXPLAIN ANALYZE
SELECT
    e_id,
    e_name,
    e_familyname,
    e_date,
    role
FROM Employee
WHERE e_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY e_date;