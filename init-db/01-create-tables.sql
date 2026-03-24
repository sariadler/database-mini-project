-- 1. טבלאות עצמאיות (ללא מפתחות זרים)
CREATE TABLE Supplier (
    S_id INT PRIMARY KEY,
    Company_Name VARCHAR(100),
    Phone VARCHAR(50),
    Address VARCHAR(200),
    Supplier_MetaData JSON -- דרישת מטלה: לפחות 2 שדות JSON
);

CREATE TABLE Employee (
    E_id INT PRIMARY KEY,
    E_name VARCHAR(100),
    E_familyName VARCHAR(100),
    E_date DATE,
    Role VARCHAR(50)
);

CREATE TABLE Product (
    P_id INT PRIMARY KEY,
    P_name VARCHAR(100),
    P_price DECIMAL(10,2),
    P_weight DECIMAL(10,2),
    P_date DATE
);

CREATE TABLE Work_Ship (
    WS_id INT PRIMARY KEY,
    WS_type VARCHAR(50),
    WS_time INT,
    WS_date DATE,
    WS_notes TEXT
);

CREATE TABLE RawMaterial (
    R_id INT PRIMARY KEY,
    R_name VARCHAR(100),
    R_price DECIMAL(10,2),
    Unit_Measure VARCHAR(50),
    Stock_Quantity INT
);

-- 2. טבלאות עם קשרי 1:M (הטמעת מפתחות זרים)

-- SupplyOrder (Provides: Supplier 1 -> M Order)
CREATE TABLE SupplyOrder (
    Order_id INT PRIMARY KEY,
    Order_date DATE,
    Total DECIMAL(10,2),
    Order_status VARCHAR(50),
    Shipping_Method VARCHAR(50),
    S_id INT,
    FOREIGN KEY (S_id) REFERENCES Supplier(S_id)
);

-- Design (Produces: Product 1 -> M Design)
CREATE TABLE Design (
    D_id INT PRIMARY KEY,
    D_name VARCHAR(100),
    D_description TEXT,
    D_data DATE, -- לפי ה-JSON (Labels)
    JSON_Specs JSON, -- דרישת מטלה: שדה JSON שני
    P_id INT,
    FOREIGN KEY (P_id) REFERENCES Product(P_id)
);

-- Product_Line (Manufactures: Product 1 -> M Line)
CREATE TABLE Product_Line (
    PL_id INT PRIMARY KEY,
    Factory_Location VARCHAR(100),
    Capacity INT,
    Last_Maintenance DATE,
    Status VARCHAR(50),
    P_id INT,
    FOREIGN KEY (P_id) REFERENCES Product(P_id)
);

-- Department (Works_In: Employee 1 -> M Dept | Manages: Line 1 -> M Dept)
CREATE TABLE Department (
    DE_id INT PRIMARY KEY,
    DE_name VARCHAR(100),
    Location VARCHAR(100),
    Budget DECIMAL(10,2),
    Manager_Name VARCHAR(100),
    E_id INT,
    PL_id INT,
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (PL_id) REFERENCES Product_Line(PL_id)
);

-- 3. טבלאות קשר (Many-to-Many בלבד)

-- Includes (SupplyOrder M <-> M RawMaterial)
CREATE TABLE Includes (
    Order_id INT,
    R_id INT,
    PRIMARY KEY (Order_id, R_id),
    FOREIGN KEY (Order_id) REFERENCES SupplyOrder(Order_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

-- Requires (Design M <-> M RawMaterial)
CREATE TABLE Requires (
    D_id INT,
    R_id INT,
    PRIMARY KEY (D_id, R_id),
    FOREIGN KEY (D_id) REFERENCES Design(D_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

-- Relationship (Employee M <-> M Work_Ship)
CREATE TABLE Employee_WorkShip (
    E_id INT,
    WS_id INT,
    PRIMARY KEY (E_id, WS_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (WS_id) REFERENCES Work_Ship(WS_id)
);