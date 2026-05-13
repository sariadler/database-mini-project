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





-- =========================================
-- Constraint 4: Product - משקל מוצר חייב להיות חיובי
-- =========================================
ALTER TABLE Product
ADD CONSTRAINT check_product_weight_positive
CHECK (p_weight > 0);

-- בדיקת שגיאה: ניסיון להכניס משקל אפס
INSERT INTO Product (p_id, p_name, p_price, p_weight, p_data, c_id)
VALUES (9999, 'Test Shoe', 200, 0, '2024-01-01', 501);


-- =========================================
-- Constraint 5: Department - תקציב מחלקה חייב להיות מעל 1000
-- =========================================
ALTER TABLE department
ADD CONSTRAINT check_min_department_budget
CHECK (budget >= 1000);

-- בדיקת שגיאה: ניסיון להכניס תקציב נמוך מדי
INSERT INTO department (de_id, de_name, budget)
VALUES (999, 'Small Dept', 500);


-- =========================================
-- Constraint 6: Supplier - אימות פורמט טלפון (12 תווים)
-- מוודא שהטלפון מוזן בפורמט הכולל מקפים כפי שקיים בנתונים
-- =========================================
ALTER TABLE Supplier
ADD CONSTRAINT check_supplier_phone_format
CHECK (LENGTH(Phone) = 12);

-- בדיקת שגיאה: ניסיון לעדכן לפורמט קצר מדי
UPDATE Supplier
SET Phone = '123-456'
WHERE S_id = 1;

