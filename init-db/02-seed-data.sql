-- Product
INSERT INTO Product VALUES (1, 'Chair', 150.00, 5.5, '2024-01-01');

-- RawMaterial
INSERT INTO RawMaterial VALUES (1, 'Wood', 50.00, 'kg', 100);

-- Supplier
INSERT INTO Supplier VALUES (1, 'Wood Inc', '123456789', 'Tel Aviv', 'metadata');

-- SupplyOrder
INSERT INTO SupplyOrder VALUES (1, '2024-01-10', 500.00, 'Pending', 'Truck', 1);

-- Design
INSERT INTO Design VALUES (1, 'Chair Design', 'Nice chair', '2024-01-01', '{}');