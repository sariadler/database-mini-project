-- createTables.sql

CREATE TABLE Supplier (
    S_id INT PRIMARY KEY,
    Company_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(50),
    Address VARCHAR(200),
    Supplier_MetaData JSON
);

CREATE TABLE Employee (
    E_id INT PRIMARY KEY,
    E_name VARCHAR(100) NOT NULL,
    E_familyName VARCHAR(100) NOT NULL,
    E_date DATE NOT NULL,
    Role VARCHAR(50) NOT NULL
);

CREATE TABLE Product (
    P_id INT PRIMARY KEY,
    P_name VARCHAR(100) NOT NULL,
    P_price NUMERIC(10,2) CHECK (P_price >= 0),
    P_weight NUMERIC(10,2) CHECK (P_weight > 0),
    P_data DATE
);

CREATE TABLE Work_Ship (
    WS_id INT PRIMARY KEY,
    WS_type VARCHAR(50) NOT NULL,
    WS_time INT CHECK (WS_time > 0),
    WS_date DATE NOT NULL,
    WS_notes VARCHAR(500)
);

CREATE TABLE RawMaterial (
    R_id INT PRIMARY KEY,
    R_name VARCHAR(100) NOT NULL,
    R_price NUMERIC(10,2) CHECK (R_price >= 0),
    Unit_Measure VARCHAR(50) NOT NULL,
    Stock_Quantity INT CHECK (Stock_Quantity >= 0)
);

CREATE TABLE SupplyOrder (
    Order_id INT PRIMARY KEY,
    Order_date DATE NOT NULL,
    Total NUMERIC(10,2) CHECK (Total >= 0),
    Order_status VARCHAR(50) NOT NULL,
    Shipping_Method VARCHAR(50),
    S_id INT NOT NULL,
    FOREIGN KEY (S_id) REFERENCES Supplier(S_id)
);

CREATE TABLE Design (
    D_id INT PRIMARY KEY,
    D_name VARCHAR(100) NOT NULL,
    D_description VARCHAR(500),
    D_date DATE NOT NULL,
    JSON_Specs JSON,
    P_id INT NOT NULL,
    FOREIGN KEY (P_id) REFERENCES Product(P_id)
);

CREATE TABLE Product_Line (
    PL_id INT PRIMARY KEY,
    Factory_Location VARCHAR(100) NOT NULL,
    Capacity INT CHECK (Capacity > 0),
    Last_Maintenance DATE,
    Status VARCHAR(50) NOT NULL,
    P_id INT NOT NULL,
    FOREIGN KEY (P_id) REFERENCES Product(P_id)
);

CREATE TABLE Department (
    DE_id INT PRIMARY KEY,
    DE_name VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    Budget NUMERIC(10,2) CHECK (Budget >= 0),
    Manager_Name VARCHAR(100),
    E_id INT,
    PL_id INT,
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (PL_id) REFERENCES Product_Line(PL_id)
);

CREATE TABLE Includes (
    Order_id INT,
    R_id INT,
    PRIMARY KEY (Order_id, R_id),
    FOREIGN KEY (Order_id) REFERENCES SupplyOrder(Order_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

CREATE TABLE Requires (
    D_id INT,
    R_id INT,
    PRIMARY KEY (D_id, R_id),
    FOREIGN KEY (D_id) REFERENCES Design(D_id),
    FOREIGN KEY (R_id) REFERENCES RawMaterial(R_id)
);

CREATE TABLE Employee_WorkShip (
    E_id INT,
    WS_id INT,
    PRIMARY KEY (E_id, WS_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    FOREIGN KEY (WS_id) REFERENCES Work_Ship(WS_id)
);