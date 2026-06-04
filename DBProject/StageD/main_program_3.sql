-- =========================================================
-- Main Program 2
-- Calls one function and one procedure
-- =========================================================

-- Call function 2: get ref cursor with supplier materials
BEGIN;

SELECT get_supplier_materials_cursor(1);

FETCH ALL FROM supplier_materials_cursor;

COMMIT;

-- Call procedure 2: create new order for supplier 1
CALL create_supply_order_for_supplier(1, 0);

-- Show latest orders
SELECT order_id, order_date, total, order_status, s_id, updated_at
FROM supplyorder
ORDER BY order_id DESC
LIMIT 5;