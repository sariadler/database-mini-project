-- =========================================================
-- Procedure 1: update_supply_order_status
-- Description:
-- Updates the status of a supply order according to its total and date.
-- Uses SELECT INTO, IF conditions, UPDATE DML and exception handling.
-- =========================================================

CREATE OR REPLACE PROCEDURE update_supply_order_status(p_order_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    order_record RECORD;
BEGIN
    -- Get the order details into a record
    SELECT order_id, order_date, total, order_status
    INTO order_record
    FROM supplyorder
    WHERE order_id = p_order_id;

    -- If no order was found
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Supply order with id % does not exist', p_order_id;
    END IF;

    -- If total is null or zero, status remains Pending
    IF order_record.total IS NULL OR order_record.total <= 0 THEN
        UPDATE supplyorder
        SET order_status = 'Pending',
            updated_at = CURRENT_TIMESTAMP
        WHERE order_id = p_order_id;

    -- If order is older than 30 days, mark as Completed
    ELSIF order_record.order_date < CURRENT_DATE - INTERVAL '30 days' THEN
        UPDATE supplyorder
        SET order_status = 'Completed',
            updated_at = CURRENT_TIMESTAMP
        WHERE order_id = p_order_id;

    -- Otherwise, mark as Approved
    ELSE
        UPDATE supplyorder
        SET order_status = 'Approved',
            updated_at = CURRENT_TIMESTAMP
        WHERE order_id = p_order_id;
    END IF;

    RAISE NOTICE 'Order % status was updated successfully', p_order_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in update_supply_order_status: %', SQLERRM;
END;
$$;