-- =========================================================
-- Stage D - Alter Table
-- Additional changes needed for PL/pgSQL programs
-- =========================================================

-- Add status column to supply orders if it does not exist
ALTER TABLE supplyorder
ADD COLUMN IF NOT EXISTS order_status VARCHAR(50) DEFAULT 'Pending';

ALTER TABLE supplyorder
ALTER COLUMN order_status SET DEFAULT 'Pending';

-- Add updated_at column to supply orders if it does not exist
ALTER TABLE supplyorder
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
--TIMESTAMP - סוג נתונים שמכיל גם תאריך וגם שעה

--(order_date - תאריך יצרת ההזמנה, updated_at - תאריך עדכון ההזמנה, order_status - סטטוס ההזמנה)

-- Create a log table for status changes in supply orders
CREATE TABLE IF NOT EXISTS supply_order_status_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);