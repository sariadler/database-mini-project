-- =========================================================
-- Function 2: get_supplier_materials_cursor
-- Description:
-- Returns a Ref Cursor with all raw materials supplied by a specific supplier.
-- =========================================================

CREATE OR REPLACE FUNCTION get_supplier_materials_cursor(
    p_supplier_id INT,
    p_cursor REFCURSOR DEFAULT 'supplier_materials_cursor'
)
RETURNS REFCURSOR
LANGUAGE plpgsql
AS $$
DECLARE
    supplier_exists INT;
BEGIN
    -- Check if supplier exists
    SELECT COUNT(*)
    INTO supplier_exists
    FROM supplier
    WHERE s_id = p_supplier_id;

    IF supplier_exists = 0 THEN
        RAISE EXCEPTION 'Supplier with id % does not exist', p_supplier_id;
    END IF;

    -- Open ref cursor for supplier materials report
    OPEN p_cursor FOR
        SELECT
            s.s_id AS supplier_id,
            s.company_name,
            r.r_id,
            r.r_name,
            r.color,
            sb.unit_price
        FROM supplier s
        JOIN supplied_by sb ON s.s_id = sb.supplier_id
        JOIN rawmaterial r ON sb.r_id = r.r_id
        WHERE s.s_id = p_supplier_id
        ORDER BY sb.unit_price;

    RETURN p_cursor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_supplier_materials_cursor: %', SQLERRM;
END;
$$;