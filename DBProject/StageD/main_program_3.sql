-- =========================================================
-- Main Program: Production & HR Management Workflow
-- Description:
-- תוכנית ראשית המשלבת את שלושת הרכיבים שנבנו:
-- 1. בדיקת ותק עובד (פונקציה).
-- 2. עדכון סטטוס הזמנה (פרוצדורה).
-- 3. עדכון מחיר מוצר המפעיל את הטריגר לבקרת מחירים.
-- =========================================================

DO $$
DECLARE
    v_rank TEXT;
    v_e_id INT := 101;      -- מזהה עובד לבדיקה
    v_order_id INT := 501;  -- מזהה הזמנה לעדכון
    v_p_id INT := 1;        -- מזהה מוצר לעדכון מחיר
BEGIN
    -- שלב 1: בדיקת ותק העובד באמצעות הפונקציה שלך
    v_rank := get_employee_experience_rank(v_e_id);
    RAISE NOTICE '--- תחילת תהליך ניהול ---';
    RAISE NOTICE 'דרגת העובד % היא: %', v_e_id, v_rank;

    -- שלב 2: עדכון סטטוס הזמנה באמצעות הפרוצדורה שלך
    RAISE NOTICE 'מעדכן סטטוס הזמנה % ל-Completed...', v_order_id;
    CALL update_supply_order_status(v_order_id, 'Completed');

    -- שלב 3: עדכון מחיר מוצר (פעולה שמפעילה אוטומטית את הטריגר שלך)
    -- הטריגר יבצע ולידציה ויתעד את השינוי בטבלת ההיסטוריה
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

-- בדיקה סופית: הצגת נתוני הלוג שנוצרו על ידי הטריגר
SELECT * 
FROM product_price_history 
ORDER BY change_date DESC LIMIT 1;