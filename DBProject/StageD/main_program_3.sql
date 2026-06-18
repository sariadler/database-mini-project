-- =========================================================
-- Main Program: Production & HR Management Workflow
-- Description:
-- תוכנית ראשית המשלבת את שלושת הרכיבים שנבנו:
-- 1. בדיקת ותק עובד (פונקציה).
-- 2. עדכון סטטוס הזמנה (פרוצדורה).
-- 3. עדכון מחיר מוצר שמפעיל את הטריגר לבקרת מחיר תקין.
-- =========================================================

DO $$
DECLARE
    v_rank TEXT;
    v_e_id INT := 101;      -- מזהה עובד לבדיקה
    v_order_id INT := 501;  -- מזהה הזמנה לעדכון
    v_p_id INT := 1;        -- מזהה מוצר לעדכון מחיר
BEGIN
    -- שלב 1: בדיקת ותק העובד באמצעות הפונקציה
    v_rank := get_employee_experience_rank(v_e_id);

    RAISE NOTICE '--- תחילת תהליך ניהול ---';
    RAISE NOTICE 'דרגת העובד % היא: %', v_e_id, v_rank;

    -- שלב 2: עדכון סטטוס הזמנה באמצעות הפרוצדורה
    RAISE NOTICE 'מעדכן סטטוס הזמנה % ל-Completed...', v_order_id;

    CALL update_supply_order_status(v_order_id, 'Completed');

    -- שלב 3: עדכון מחיר מוצר
    -- פעולה זו מפעילה אוטומטית את הטריגר process_product_price_update
    -- הטריגר בודק שהמחיר החדש חיובי
    RAISE NOTICE 'מעדכן מחיר מוצר %...', v_p_id;

    UPDATE Product
    SET P_price = 250.00
    WHERE P_id = v_p_id;

    RAISE NOTICE '--- התהליך הושלם בהצלחה ---';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'שגיאה במהלך הרצת התוכנית הראשית: %', SQLERRM;
END;
$$;

-- בדיקה סופית: הצגת המוצר לאחר עדכון המחיר
SELECT
    P_id,
    P_price
FROM Product
WHERE P_id = 1;