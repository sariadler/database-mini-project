-- =========================================================
-- Trigger 1: trg_log_supply_order_update
-- Description:
-- Logs every status update in supplyorder table
-- and updates the updated_at timestamp.
-- =========================================================

CREATE OR REPLACE FUNCTION log_supply_order_status_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into log table only if the status was changed
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN

        -- Update the order modification time
        NEW.updated_at := CURRENT_TIMESTAMP;

        -- Save the status change in the log table
        INSERT INTO supply_order_status_log (
            order_id,
            old_status,
            new_status,
            change_date
        )
        VALUES (
            OLD.order_id,
            OLD.order_status,
            NEW.order_status,
            CURRENT_TIMESTAMP
        );
    END IF;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in log_supply_order_status_update trigger: %', SQLERRM;
END;
$$;

DROP TRIGGER IF EXISTS trg_log_supply_order_update ON supplyorder;

CREATE TRIGGER trg_log_supply_order_update
BEFORE UPDATE OF order_status ON supplyorder
FOR EACH ROW
EXECUTE FUNCTION log_supply_order_status_update();


-- =========================================================
-- Trigger 1 - Test
-- =========================================================

-- Update the status of supply order 501
--UPDATE supplyorder
--SET order_status = 'Completed'
--WHERE order_id = 501;

-- Check that the order status and updated_at were updated
SELECT
    order_id,
    order_status,
    updated_at
FROM supplyorder
WHERE order_id = 501;

-- Check that the status change was inserted into the log table
SELECT
    log_id,
    order_id,
    old_status,
    new_status,
    change_date
FROM supply_order_status_log
WHERE order_id = 501
ORDER BY log_id DESC;