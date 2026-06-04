-- =========================================================
-- Procedure 2: create_supply_order_for_supplier
-- Description:
-- Creates a new supply order for an existing supplier.
-- Uses INSERT DML, IF condition, implicit cursor and exception handling.
-- =========================================================

CREATE OR REPLACE PROCEDURE create_supply_order_for_supplier(
    p_supplier_id INT,
    p_initial_total NUMERIC DEFAULT 0
)
LANGUAGE plpgsql
AS $$
DECLARE
    supplier_exists INT;
    new_order_id INT;
    supplier_material RECORD;
BEGIN
    -- Check if supplier exists
    SELECT COUNT(*)
    INTO supplier_exists
    FROM supplier
    WHERE s_id = p_supplier_id;

    IF supplier_exists = 0 THEN
        RAISE EXCEPTION 'Supplier with id % does not exist', p_supplier_id;
    END IF;

    -- Print supplier materials using implicit cursor
    FOR supplier_material IN
        SELECT r_id, unit_price
        FROM supplied_by
        WHERE supplier_id = p_supplier_id
    LOOP
        RAISE NOTICE 'Supplier % supplies raw material % with unit price %',
            p_supplier_id,
            supplier_material.r_id,
            supplier_material.unit_price;
    END LOOP;

    -- Create new order id manually
    SELECT COALESCE(MAX(order_id), 0) + 1
    INTO new_order_id
    FROM supplyorder;

    -- Insert new supply order
    INSERT INTO supplyorder (
        order_id,
        order_date,
        total,
        order_status,
        s_id,
        updated_at
    )
    VALUES (
        new_order_id,
        CURRENT_DATE,
        p_initial_total,
        'Pending',
        p_supplier_id,
        CURRENT_TIMESTAMP
    );

    RAISE NOTICE 'New supply order % was created for supplier %',
        new_order_id,
        p_supplier_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in create_supply_order_for_supplier: %', SQLERRM;
END;
$$;

-- =========================================================
-- Procedure 2 - Test
-- =========================================================

-- Run the procedure for supplier 3
--CALL create_supply_order_for_supplier(3, 5000);

-- Check that the new order was inserted
SELECT
    order_id,
    order_date,
    total,
    order_status,
    s_id,
    updated_at
FROM supplyorder
WHERE s_id = 3
ORDER BY order_id DESC
LIMIT 5;