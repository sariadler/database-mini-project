-- =========================================================
-- Trigger 2: trg_check_unit_price
-- Description:
-- Prevents inserting or updating a negative unit price in supplied_by.
-- This trigger works BEFORE INSERT OR UPDATE.
-- =========================================================

CREATE OR REPLACE FUNCTION check_unit_price()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Unit price cannot be negative
    IF NEW.unit_price < 0 THEN
        RAISE EXCEPTION 'Unit price cannot be negative. Given value: %', NEW.unit_price;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_check_unit_price ON supplied_by;

CREATE TRIGGER trg_check_unit_price
BEFORE INSERT OR UPDATE OF unit_price ON supplied_by
FOR EACH ROW
EXECUTE FUNCTION check_unit_price();