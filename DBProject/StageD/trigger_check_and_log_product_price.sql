-- =========================================================
-- Trigger 3: trigger_check_and_log_product_price
-- Description:
-- 1. Validates that the price is positive.
-- 2. Logs changes to a product_price_history table for auditing.
-- 3. Uses robust error handling.
-- =========================================================

-- Step 1: Create a history table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS product_price_history (
    history_id SERIAL PRIMARY KEY,
    p_id INT,
    old_price NUMERIC,
    new_price NUMERIC,
    changed_by TEXT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 2: Create the trigger function
CREATE OR REPLACE FUNCTION process_product_price_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validation: Ensure price is positive
    IF NEW.P_price <= 0 THEN
        RAISE EXCEPTION 'Business Rule Violation: Product price must be positive. Attempted value: %', NEW.P_price;
    END IF;

    -- Logging: Only if the price actually changed
    IF OLD.P_price IS DISTINCT FROM NEW.P_price THEN
        INSERT INTO product_price_history (p_id, old_price, new_price, changed_by)
        VALUES (OLD.P_id, OLD.P_price, NEW.P_price, current_user);
    END IF;

    RETURN NEW;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Critical error in process_product_price_update: %', SQLERRM;
END;
$$;

-- Step 3: Create the trigger
DROP TRIGGER IF EXISTS trigger_check_and_log_product_price ON Product;

CREATE TRIGGER trigger_check_and_log_product_price
BEFORE UPDATE OF P_price ON Product
FOR EACH ROW
EXECUTE FUNCTION process_product_price_update();

-- =========================================================
-- Trigger 3 - Test Suite
-- =========================================================

-- 1. Test invalid update (Should trigger an Exception)
 UPDATE Product SET P_price = -10 WHERE P_id = 1;

-- 2. Test valid update
UPDATE Product SET P_price = 199.99 WHERE P_id = 1;

-- 3. Verify price updated
SELECT P_id, P_price FROM Product WHERE P_id = 1;

-- 4. Verify audit log created
SELECT * FROM product_price_history ORDER BY change_date DESC;