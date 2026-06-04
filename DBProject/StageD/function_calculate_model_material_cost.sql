-- =========================================================
-- Function 1: calculate_model_material_cost
-- Description:
-- Calculates the total raw material cost required for a specific model.
-- Uses an explicit cursor, loop, record, IF conditions and exception handling.
-- =========================================================

CREATE OR REPLACE FUNCTION calculate_model_material_cost(p_model_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    -- Explicit cursor: goes over all raw materials required for the given model
    material_cursor CURSOR FOR
        SELECT 
            rm.r_id,
            rm.amount,
            MIN(sb.unit_price) AS min_unit_price
        FROM required_m rm
        JOIN supplied_by sb ON rm.r_id = sb.r_id
        WHERE rm.model_id = p_model_id
        GROUP BY rm.r_id, rm.amount;

    -- Record variable for each row from the cursor
    material_record RECORD;

    -- Total cost result
    total_cost NUMERIC := 0;

    -- Check if model exists
    model_exists INT;
BEGIN
    -- Check that the model exists
    SELECT COUNT(*)
    INTO model_exists
    FROM model
    WHERE model_id = p_model_id;

    IF model_exists = 0 THEN
        RAISE EXCEPTION 'Model with id % does not exist', p_model_id;
    END IF;

    -- Open explicit cursor
    OPEN material_cursor;

    LOOP
        -- Fetch next row into record
        FETCH material_cursor INTO material_record;

        -- Stop loop when there are no more rows
        EXIT WHEN NOT FOUND;

        -- If there is no price, skip this raw material
        IF material_record.min_unit_price IS NULL THEN
            RAISE NOTICE 'Raw material % has no supplier price', material_record.r_id;
        ELSE
            -- Add amount * minimum unit price to total cost
            total_cost := total_cost + (material_record.amount * material_record.min_unit_price);
        END IF;
    END LOOP;

    -- Close cursor
    CLOSE material_cursor;

    RETURN total_cost;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in calculate_model_material_cost: %', SQLERRM;
END;
$$;