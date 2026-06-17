-- =========================================================
-- Trigger 1: trg_validate_supply_order_status
-- Description:
-- Validates that the supply order status is one of the allowed values.
-- Automatically updates the updated_at timestamp.
-- Enforces a business rule and maintains valid order data.
-- =========================================================

-- Step 1: Create or replace the trigger function
CREATE OR REPLACE FUNCTION validate_supply_order_status_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Business rule: order status must be valid
    IF NEW.order_status NOT IN ('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Completed') THEN
        RAISE EXCEPTION
            'Invalid order status: %. Allowed values are: Pending, Shipped, Delivered, Cancelled, Completed',
            NEW.order_status;
    END IF;

    -- Automatically update the modification timestamp
    NEW.updated_at := CURRENT_TIMESTAMP;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in validate_supply_order_status_update trigger: %', SQLERRM;
END;
$$;

-- Step 2: Drop old triggers if they exist
DROP TRIGGER IF EXISTS trg_log_supply_order_update ON supplyorder;
DROP TRIGGER IF EXISTS trg_validate_supply_order_status ON supplyorder;

-- Step 3: Create the corrected trigger
CREATE TRIGGER trg_validate_supply_order_status
BEFORE INSERT OR UPDATE OF order_status ON supplyorder
FOR EACH ROW
EXECUTE FUNCTION validate_supply_order_status_update();

-- =========================================================
-- Trigger 1 - Test Suite
-- =========================================================

-- 1. Test invalid status
-- This should trigger an exception and prevent the update
UPDATE supplyorder
SET order_status = 'WrongStatus'
WHERE order_id = 501;

-- 2. Test valid status
-- This should work successfully
UPDATE supplyorder
SET order_status = 'Completed'
WHERE order_id = 501;

-- 3. Verify that the status and updated_at were updated
SELECT
    order_id,
    order_status,
    updated_at
FROM supplyorder
WHERE order_id = 501;