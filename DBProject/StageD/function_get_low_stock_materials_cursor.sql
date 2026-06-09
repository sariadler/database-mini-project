-- =====================================================
-- Function: get_low_stock_materials_cursor
-- Purpose:
-- Returns a refcursor with all raw materials whose stock
-- quantity is lower than a given minimum stock value.
-- =====================================================

CREATE OR REPLACE FUNCTION get_low_stock_materials_cursor(p_min_stock INT)
RETURNS refcursor
LANGUAGE plpgsql
AS $$
DECLARE
    v_refcursor refcursor;
BEGIN
    IF p_min_stock <= 0 THEN
        RAISE EXCEPTION 'Minimum stock must be greater than 0';
    END IF;

    OPEN v_refcursor FOR
        SELECT
            r_id,
            r_name,
            stock_quantity,
            r_price,
            unit_measure
        FROM rawmaterial
        WHERE stock_quantity < p_min_stock
        ORDER BY stock_quantity ASC;

    RETURN v_refcursor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_low_stock_materials_cursor: %', SQLERRM;
END;
$$;