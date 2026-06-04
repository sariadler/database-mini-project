-- =========================================================
-- Main Program
-- Description:
-- Calculates the material cost for a model,
-- creates a new supply order using the calculated cost,
-- and updates the order status to activate the trigger.
-- =========================================================

DO $$
DECLARE
    v_material_cost NUMERIC;
    v_new_order_id INT;
BEGIN
    -- Call Function 1
    SELECT calculate_model_material_cost(1000)
    INTO v_material_cost;

    RAISE NOTICE 'Material cost for model 1000: %', v_material_cost;

    -- Call Procedure 2
    CALL create_supply_order_for_supplier(3, v_material_cost);

    -- Find the new order
    SELECT MAX(order_id)
    INTO v_new_order_id
    FROM supplyorder
    WHERE s_id = 3;

    -- Activate Trigger 1
    UPDATE supplyorder
    SET order_status = 'Completed'
    WHERE order_id = v_new_order_id;

    RAISE NOTICE 'Order % was created and completed', v_new_order_id;
END;
$$;

-- Verify the new order
SELECT
    order_id,
    total,
    order_status,
    s_id,
    updated_at
FROM supplyorder
WHERE s_id = 3
ORDER BY order_id DESC
LIMIT 1;

-- Verify the trigger log
SELECT
    log_id,
    order_id,
    old_status,
    new_status,
    change_date
FROM supply_order_status_log
ORDER BY log_id DESC
LIMIT 1;