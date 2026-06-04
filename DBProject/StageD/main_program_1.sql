-- =========================================================
-- Main Program 1
-- Calls one function and one procedure
-- =========================================================

-- Call function 1: calculate material cost for model 1
SELECT calculate_model_material_cost(1) AS total_model_material_cost;

-- Call procedure 1: update status of supply order 1
CALL update_supply_order_status(1);

-- Show result after procedure
SELECT order_id, order_date, total, order_status, updated_at
FROM supplyorder
WHERE order_id = 1;