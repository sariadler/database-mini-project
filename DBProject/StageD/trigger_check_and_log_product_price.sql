-- =========================================================
-- Trigger 3: trigger_check_and_log_product_price
-- Description:
-- Validates that the product price is positive.
-- Enforces a business rule and prevents invalid product prices.
-- Uses robust error handling.
-- =========================================================

-- Step 1: Create or replace the trigger function
CREATE OR REPLACE FUNCTION process_product_price_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Business rule: product price must be positive
    IF NEW.P_price <= 0 THEN
        RAISE EXCEPTION
            'Business Rule Violation: Product price must be positive. Attempted value: %',
            NEW.P_price;
    END IF;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Critical error in process_product_price_update: %', SQLERRM;
END;
$$;

-- Step 2: Drop old triggers if they exist
DROP TRIGGER IF EXISTS trigger_check_and_log_product_price ON Product;
DROP TRIGGER IF EXISTS trg_check_and_log_product_price ON Product;

-- Step 3: Create the corrected trigger
CREATE TRIGGER trigger_check_and_log_product_price
BEFORE INSERT OR UPDATE OF P_price ON Product
FOR EACH ROW
EXECUTE FUNCTION process_product_price_update();

-- =========================================================
-- Trigger 3 - Test Suite
-- =========================================================

-- 1. Test invalid update
-- This should trigger an exception and prevent the update
UPDATE Product
SET P_price = -10
WHERE P_id = 1;

-- 2. Test valid update
-- This should work successfully
UPDATE Product
SET P_price = 199.99
WHERE P_id = 1;

-- 3. Verify that the price was updated
SELECT
    P_id,
    P_price
FROM Product
WHERE P_id = 1;