-- =====================================================
-- Procedure: refill_low_stock_materials
-- Purpose:
-- Refills all raw materials whose stock quantity is lower
-- than a given minimum stock value.
-- =====================================================

CREATE OR REPLACE PROCEDURE refill_low_stock_materials(
    p_min_stock INT,
    p_add_amount INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_material RECORD;
    v_updated_count INT := 0;
    v_last_update_count INT := 0;
    v_new_quantity INT;

    cur_low_stock CURSOR FOR
        SELECT
            r_id,
            r_name,
            stock_quantity
        FROM rawmaterial
        WHERE stock_quantity < p_min_stock
        ORDER BY stock_quantity ASC;
BEGIN
    IF p_min_stock <= 0 THEN
        RAISE EXCEPTION 'Minimum stock must be greater than 0';
    END IF;

    IF p_add_amount <= 0 THEN
        RAISE EXCEPTION 'Amount to add must be greater than 0';
    END IF;

    FOR v_material IN cur_low_stock LOOP
        v_new_quantity := v_material.stock_quantity + p_add_amount;

        IF v_material.stock_quantity = 0 THEN
            RAISE NOTICE 'Material % (%) had zero stock. New quantity: %',
                v_material.r_id, v_material.r_name, v_new_quantity;
        ELSE
            RAISE NOTICE 'Material % (%) had low stock: %. New quantity: %',
                v_material.r_id, v_material.r_name,
                v_material.stock_quantity, v_new_quantity;
        END IF;

        UPDATE rawmaterial
        SET stock_quantity = v_new_quantity
        WHERE r_id = v_material.r_id;

        GET DIAGNOSTICS v_last_update_count = ROW_COUNT;
        v_updated_count := v_updated_count + v_last_update_count;
    END LOOP;

    IF v_updated_count = 0 THEN
        RAISE NOTICE 'No low stock materials were found.';
    ELSE
        RAISE NOTICE 'Procedure completed successfully. Total updated materials: %',
            v_updated_count;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in refill_low_stock_materials: %', SQLERRM;
END;
$$;