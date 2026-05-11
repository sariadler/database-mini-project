-- Queries.sql
-- Stage B - SELECT, UPDATE and DELETE queries
-- Database: Design and Production Management System


-- =========================================================
-- SELECT 1A
-- Total orders amount by supplier, year and month
-- =========================================================

SELECT
    s.S_id,
    s.Company_Name,
    EXTRACT(YEAR FROM so.Order_date) AS order_year,
    EXTRACT(MONTH FROM so.Order_date) AS order_month,
    COUNT(so.Order_id) AS total_orders,
    SUM(so.Total) AS total_amount
FROM Supplier s
JOIN SupplyOrder so ON s.S_id = so.S_id
GROUP BY
    s.S_id,
    s.Company_Name,
    EXTRACT(YEAR FROM so.Order_date),
    EXTRACT(MONTH FROM so.Order_date)
ORDER BY order_year, order_month, total_amount DESC;


-- =========================================================
-- SELECT 2A
-- Raw materials that are required by designs, including number of designs
-- =========================================================

SELECT
    rm.R_id,
    rm.R_name,
    rm.Unit_Measure,
    rm.Stock_Quantity,
    COUNT(r.D_id) AS number_of_designs
FROM RawMaterial rm
JOIN Requires r ON rm.R_id = r.R_id
JOIN Design d ON r.D_id = d.D_id
GROUP BY
    rm.R_id,
    rm.R_name,
    rm.Unit_Measure,
    rm.Stock_Quantity
ORDER BY number_of_designs DESC;


-- =========================================================
-- SELECT 3A
-- Products with their designs and required raw materials
-- =========================================================

SELECT
    p.P_id,
    p.P_name,
    p.P_price,
    d.D_id,
    d.D_name,
    rm.R_id,
    rm.R_name,
    rm.Stock_Quantity
FROM Product p
JOIN Design d ON p.P_id = d.P_id
JOIN Requires r ON d.D_id = r.D_id
JOIN RawMaterial rm ON r.R_id = rm.R_id
ORDER BY p.P_id, d.D_id, rm.R_name;


-- =========================================================
-- SELECT 4A
-- Employees and number of work shifts by year and month
-- =========================================================

SELECT
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    EXTRACT(YEAR FROM ws.WS_date) AS work_year,
    EXTRACT(MONTH FROM ws.WS_date) AS work_month,
    COUNT(ws.WS_id) AS total_shifts
FROM Employee e
JOIN Employee_WorkShip ews ON e.E_id = ews.E_id
JOIN Work_Ship ws ON ews.WS_id = ws.WS_id
GROUP BY
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    EXTRACT(YEAR FROM ws.WS_date),
    EXTRACT(MONTH FROM ws.WS_date)
ORDER BY work_year, work_month, total_shifts DESC;

-- =========================================================
-- SELECT 5A
-- Suppliers that have orders - using IN
-- =========================================================

SELECT
    s.S_id,
    s.Company_Name,
    s.Phone,
    s.Address
FROM Supplier s
WHERE s.S_id IN (
    SELECT so.S_id
    FROM SupplyOrder so
);


-- =========================================================
-- SELECT 5B
-- Suppliers that have orders - using EXISTS
-- =========================================================

SELECT
    s.S_id,
    s.Company_Name,
    s.Phone,
    s.Address
FROM Supplier s
WHERE EXISTS (
    SELECT 1
    FROM SupplyOrder so
    WHERE so.S_id = s.S_id
);


n d
);
-- =========================================================
-- SELECT 6A
-- Products that have designs - using IN
-- =========================================================

SELECT
    p.P_id,
    p.P_name,
    p.P_price,
    p.P_weight,
    p.P_data
FROM Product p
WHERE p.P_id IN (
    SELECT d.P_id
    FROM Desig

-- =========================================================
-- SELECT 6B
-- Products that have designs - using JOIN
-- =========================================================

SELECT DISTINCT
    p.P_id,
    p.P_name,
    p.P_price,
    p.P_weight,
    p.P_data
FROM Product p
JOIN Design d ON p.P_id = d.P_id;


-- =========================================================
-- SELECT 7A
-- Raw materials used in designs - using EXISTS
-- =========================================================

SELECT
    rm.R_id,
    rm.R_name,
    rm.R_price,
    rm.Unit_Measure,
    rm.Stock_Quantity
FROM RawMaterial rm
WHERE EXISTS (
    SELECT 1
    FROM Requires r
    WHERE r.R_id = rm.R_id
);


-- =========================================================
-- SELECT 7B
-- Raw materials used in designs - using JOIN
-- =========================================================

SELECT DISTINCT
    rm.R_id,
    rm.R_name,
    rm.R_price,
    rm.Unit_Measure,
    rm.Stock_Quantity
FROM RawMaterial rm
JOIN Requires r ON rm.R_id = r.R_id;


-- =========================================================
-- SELECT 8A
-- Employees that worked in shifts - using IN
-- =========================================================

SELECT
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    e.E_date
FROM Employee e
WHERE e.E_id IN (
    SELECT ews.E_id
    FROM Employee_WorkShip ews
);


-- =========================================================
-- SELECT 8B
-- Employees that worked in shifts - using JOIN
-- =========================================================

SELECT DISTINCT
    e.E_id,
    e.E_name,
    e.E_familyName,
    e.Role,
    e.E_date
FROM Employee e
JOIN Employee_WorkShip ews ON e.E_id = ews.E_id;




-- =========================================================
-- SELECT 9A
-- High price products that have a design - using IN
-- =========================================================

SELECT 
    p.P_id AS "Product_ID", 
    p.P_name AS "Product_Name", 
    p.P_price AS "Unit_Price"
FROM Product p
WHERE p.P_price > 1000 
  AND p.P_id IN (
    SELECT d.P_id 
    FROM Design d
);




-- =========================================================
-- SELECT 9B
-- High price products that have a design - using JOIN
-- =========================================================

SELECT DISTINCT
    p.P_id AS "Product_ID", 
    p.P_name AS "Product_Name", 
    p.P_price AS "Unit_Price"
FROM Product p
JOIN Design d ON p.P_id = d.P_id
WHERE p.P_price > 1000;








-- =========================================================
-- UPDATE 1
-- Increase price of products that have a design created after 2024
-- =========================================================

UPDATE Product
SET P_price = P_price * 1.05
WHERE P_id IN (
    SELECT P_id
    FROM Design
    WHERE D_date >= '2024-01-01'
);



-- =========================================================
-- UPDATE 2
-- Mark old product lines as needing maintenance
-- =========================================================

UPDATE Product_Line
SET Status = 'Needs Maintenance'
WHERE Last_Maintenance < CURRENT_DATE - INTERVAL '1 year';


-- =========================================================
-- UPDATE 3
-- Reduce budget for departments connected to inactive product lines
-- =========================================================

UPDATE Department
SET Budget = Budget * 0.90
WHERE PL_id IN (
    SELECT PL_id
    FROM Product_Line
    WHERE Status = 'Inactive'
);


-- =========================================================
-- DELETE 1
-- Delete old cancelled supply orders that are not connected to raw materials
-- =========================================================

DELETE FROM SupplyOrder
WHERE Order_status = 'Cancelled'
  AND Order_date < CURRENT_DATE - INTERVAL '2 years'
  AND Order_id NOT IN (
      SELECT Order_id
      FROM Includes
  );


-- =========================================================
-- DELETE 2
-- Delete work shifts without employees
-- =========================================================

DELETE FROM Work_Ship
WHERE WS_id NOT IN (
    SELECT WS_id
    FROM Employee_WorkShip
);


-- =========================================================
-- DELETE 3
-- Delete raw materials that are not used in designs and not included in orders
-- =========================================================

DELETE FROM RawMaterial
WHERE R_id NOT IN (
    SELECT R_id FROM Requires
)
AND R_id NOT IN (
    SELECT R_id FROM Includes
);