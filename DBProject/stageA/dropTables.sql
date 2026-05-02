-- dropTables.sql (ללא CASCADE)

-- טבלאות קשר (תלויות)
DROP TABLE IF EXISTS Employee_WorkShip;
DROP TABLE IF EXISTS Requires;
DROP TABLE IF EXISTS Includes;

-- טבלאות עם FK
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Product_Line;
DROP TABLE IF EXISTS Design;
DROP TABLE IF EXISTS SupplyOrder;

-- טבלאות בסיס
DROP TABLE IF EXISTS RawMaterial;
DROP TABLE IF EXISTS Work_Ship;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Supplier;