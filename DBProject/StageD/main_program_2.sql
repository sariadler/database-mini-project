DO $$
DECLARE
    v_cursor refcursor;
    v_material RECORD;
    v_material_count INT := 0;
BEGIN
    -- Call Function 2
    v_cursor := get_low_stock_materials_cursor(200);

    -- Read the Ref Cursor returned by the function
    LOOP
        FETCH v_cursor INTO v_material;
        EXIT WHEN NOT FOUND;

        v_material_count := v_material_count + 1;
    END LOOP;

    RAISE NOTICE 'Number of raw materials with stock lower than 200: %',
        v_material_count;

    -- Call Procedure 3
    CALL refill_low_stock_materials(200, 50);

    -- Activate Trigger 2 manually by updating one raw material
    UPDATE rawmaterial
    SET stock_quantity = stock_quantity + 25
    WHERE r_id = 1823;

    RAISE NOTICE 'Main program completed successfully.';
END;
$$;

-- Verify updated raw material
SELECT
    r_id,
    r_name,
    stock_quantity
FROM rawmaterial
WHERE r_id = 1823;

-- Verify trigger log
SELECT
    log_id,
    r_id,
    old_quantity,
    new_quantity,
    change_date
FROM rawmaterial_stock_log
ORDER BY log_id DESC
LIMIT 5;