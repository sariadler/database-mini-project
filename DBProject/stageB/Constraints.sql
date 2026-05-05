-- =========================================
-- Constraint 1: RawMaterial - מחיר חייב להיות חיובי
-- =========================================
ALTER TABLE rawmaterial
ADD CONSTRAINT check_rawmaterial_price_positive
CHECK (r_price > 0);

-- בדיקת שגיאה: ניסיון להכניס מחיר שלילי
-- מצופה: שגיאה
INSERT INTO rawmaterial (r_id, r_name, r_price, unit_measure, stock_quantity)
VALUES (9000, 'BadMaterial', -10, 'kg', 5);



-- =========================================
-- Constraint 2: SupplyOrder - סטטוס חייב להיות חוקי
-- =========================================
ALTER TABLE supplyorder
ADD CONSTRAINT check_supplyorder_status
CHECK (order_status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'));

-- בדיקת שגיאה: ניסיון להכניס סטטוס לא חוקי
-- מצופה: שגיאה
INSERT INTO supplyorder (order_id, order_date, total, order_status, shipping_method, s_id)
VALUES (9002, '2024-01-01', 1000, 'Unknown', 'Truck', 1);



-- =========================================
-- Constraint 3: Employee - תאריך לא יכול להיות בעתיד
-- =========================================
ALTER TABLE employee
ADD CONSTRAINT check_employee_date
CHECK (e_date <= CURRENT_DATE);

-- בדיקת שגיאה: ניסיון להכניס תאריך עתידי
-- מצופה: שגיאה
INSERT INTO employee (e_id, e_name, e_familyname, e_date, role)
VALUES (9001, 'Future', 'User', '2030-01-01', 'Worker');