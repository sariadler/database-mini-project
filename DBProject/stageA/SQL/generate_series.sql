INSERT INTO RawMaterial (R_id, R_name, R_price, Unit_Measure, Stock_Quantity)
SELECT 
    i,
    'Material_' || i,
    round((random() * 100 + 10)::numeric, 2),
    'kg',
    (random() * 1000)::int
FROM generate_series(1, 500) AS s(i);