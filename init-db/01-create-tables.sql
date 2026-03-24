-- Product
CREATE TABLE Product (
    P_id INT PRIMARY KEY,
    P_name VARCHAR(100),
    P_price DECIMAL(10,2),
    P_weight DECIMAL(10,2),
    P_date DATE
);

-- Design
CREATE TABLE Design (
    D_id INT PRIMARY KEY,
    D_name VARCHAR(100),
    D_description TEXT,
    D_date DATE,
    JSON_Specs JSON
);

-- RawMaterial
CREATE TABLE RawMaterial (
    R_id INT PRIMARY KEY,
    R_name VARCHAR(100),
    R_price DECIMAL(10,2),
    Unit_Measure VARCHAR(50),
    Stock_Quantity INT
);

-- Supplier
CREATE TABLE Supplier (
    S_id INT PRIMARY KEY,
    Company_Name VARCHAR(100),
    Phone VARCHAR(50),
    Address VARCHAR(200),
    Supplier_MetaData TEXT
);

-- SupplyOrder
CREATE TABLE SupplyOrder (
    Order_id INT PRIMARY KEY,
    Order_date DATE,
    Total DECIMAL(10,2),
    Order_status VARCHAR(50),
    Shipping_Method VARCHAR(50),
    S_id INT,
    FOREIGN KEY (S_id) REFERENCES Supplier(S_id)
);

-- Product Line
CREATE TABLE Product_Line (
    PL_id INT PRIMARY KEY,
    Factory_Location VARCHAR(100),
    Capacity INT,
    Last_Maintenance DATE,
    Status VARCHAR(50)
);

-- Department
CREATE TABLE Department (
    DE_id INT PRIMARY KEY,
    DE_name VARCHAR(100),
    Location VARCHAR(100),
    Budget DECIMAL(10,2),
    Manager_Name VARCHAR(100)
);

-- Employee
CREATE TABLE Employee (
    E_id INT PRIMARY KEY,
    E_name VARCHAR(100),
    E_familyName VARCHAR(100),
    E_date DATE,
    Role VARCHAR(50)
);

-- Work Ship
CREATE TABLE Work_Ship (
    WS_id INT PRIMARY KEY,
    WS_type VARCHAR(50),
    WS_time INT,
    WS_date DATE,
    WS_notes TEXT
);

-- =====================
-- RELATION TABLES
-- =====================

-- Includes (SupplyOrder ↔ RawMaterial)
CREATE TABLE Includes (
    Order_id INT,
    R_id INT,
    PRIMARY KEY (Order_id, R_id),
    FOREIGN KEY (Order_id) REFERENCES SupplyOrder(Order_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

-- Requires (Design ↔ RawMaterial)
CREATE TABLE Requires (
    D_id INT,
    R_id INT,
    PRIMARY KEY (D_id, R_id),
    FOREIGN KEY (D_id) REFERENCES Design(D_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

-- Produces (Product ↔ Design)
CREATE TABLE Produces (
    P_id INT,
    D_id INT,
    PRIMARY KEY (P_id, D_id),
    FOREIGN KEY (P_id) REFERENCES Product(P_id),
    FOREIGN KEY (D_id) REFERENCES Design(D_id)
);

-- Manufactures (Product ↔ Product_Line)
CREATE TABLE Manufactures (
    P_id INT,
    PL_id INT,
    PRIMARY KEY (P_id, PL_id),
    FOREIGN KEY (P_id) REFERENCES Product(P_id),
    FOREIGN KEY (PL_id) REFERENCES Product_Line(PL_id)
);

-- Works_in (Employee ↔ Department)
CREATE TABLE Works_in (
    E_id INT,
    DE_id INT,
    PRIMARY KEY (E_id, DE_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (DE_id) REFERENCES Department(DE_id)
);

-- Employee ↔ Work_Ship
CREATE TABLE Employee_WorkShip (
    E_id INT,
    WS_id INT,
    PRIMARY KEY (E_id, WS_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (WS_id) REFERENCES Work_Ship(WS_id)
);