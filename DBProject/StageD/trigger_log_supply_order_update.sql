-- =========================================================
-- Trigger 1: trg_log_supply_order_update
-- Description:
-- Logs every status update in supplyorder table.
-- This trigger works AFTER UPDATE.
-- =========================================================

CREATE OR REPLACE FUNCTION log_supply_order_status_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into log table only if the status was changed
    IF OLD.order_status IS DISTINCT FROM NEW.order_status THEN
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
AFTER UPDATE OF order_status ON supplyorder
FOR EACH ROW
EXECUTE FUNCTION log_supply_order_status_update();