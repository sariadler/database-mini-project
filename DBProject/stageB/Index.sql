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



-- =========================================================
-- INDEX 4: Improve search by Supplier Company Name
-- שיפור מהירות החיפוש לפי שם חברת הספק
-- =========================================================

-- BEFORE: Check performance without index (Expected: Seq Scan)
-- בדיקת ביצועים לפני הוספת האינדקס (צפוי סריקה טורית איטית)
EXPLAIN ANALYZE
SELECT * 
FROM Supplier 
WHERE Company_Name LIKE 'S%';

-- Create the index on Company_Name column
-- יצירת האינדקס על עמודת שם החברה בטבלת ספקים
CREATE INDEX idx_supplier_name ON Supplier(Company_Name);

-- AFTER: Check performance with index (Expected: Index Scan)
-- בדיקת ביצועים אחרי הוספת האינדקס (צפוי שליפה מהירה באמצעות אינדקס)
EXPLAIN ANALYZE
SELECT * 
FROM Supplier 
WHERE Company_Name LIKE 'S%';


-- =========================================================
-- INDEX 5: Optimize search by Product Weight
-- אופטימיזציה לחיפוש מוצרים לפי משקל
-- =========================================================

-- BEFORE: Full table scan to find heavy products
-- בדיקת ביצועים לפני: בסיס הנתונים עובר על כל המוצרים אחד אחד
EXPLAIN ANALYZE
SELECT * 
FROM Product 
WHERE p_weight > 500;

-- Create index for faster filtering by weight
-- יצירת אינדקס על עמודת המשקל בטבלת מוצרים
CREATE INDEX idx_product_weight ON Product(p_weight);

-- AFTER: Efficient retrieval of weight-specific data
-- בדיקת ביצועים אחרי: דילוג ישיר למוצרים שעונים על התנאי
EXPLAIN ANALYZE
SELECT * 
FROM Product 
WHERE p_weight > 500;


-- =========================================================
-- INDEX 6: Fast monitoring of Raw Material stock levels
-- מעקב מהיר אחר מלאי חומרי גלם (זיהוי חוסרים)
-- =========================================================

-- BEFORE: Database scans all raw materials in warehouse
-- בדיקת ביצועים לפני: סריקה של כל חומרי הגלם במחסן
EXPLAIN ANALYZE
SELECT * 
FROM RawMaterial 
WHERE Stock_Quantity < 100;

-- Create index to instantly identify low-stock materials
-- יצירת אינדקס על עמודת כמות המלאי בטבלת חומרי גלם
CREATE INDEX idx_rawmaterial_stock ON RawMaterial(Stock_Quantity);

-- AFTER: Instant identification of low stock items
-- בדיקת ביצועים אחרי: איתור מיידי של חומרים בכמות נמוכה
EXPLAIN ANALYZE
SELECT * 
FROM RawMaterial 
WHERE Stock_Quantity < 100;