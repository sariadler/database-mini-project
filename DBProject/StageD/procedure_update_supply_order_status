-- =========================================================
-- Procedure 3: update_supply_order_status
-- Description:
-- מעדכנת את הסטטוס של הזמנת אספקה קיימת ומעדכנת את חותמת הזמן.
-- משתמשת ב-UPDATE, בדיקת קיום רשומה (EXISTS) וטיפול בחריגות.
-- =========================================================

CREATE OR REPLACE PROCEDURE update_supply_order_status(
    p_order_id INT,
    p_new_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- בדיקה האם ההזמנה קיימת בבסיס הנתונים
    IF NOT EXISTS (SELECT 1 FROM supplyorder WHERE order_id = p_order_id) THEN
        RAISE EXCEPTION 'הזמנה עם מזהה % לא קיימת במערכת', p_order_id;
    END IF;

    -- עדכון הסטטוס של ההזמנה וזמן העדכון הנוכחי
    UPDATE supplyorder
    SET order_status = p_new_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE order_id = p_order_id;

    -- הדפסת הודעת אישור למשתמש
    RAISE NOTICE 'סטטוס ההזמנה % עודכן ל-%', p_order_id, p_new_status;

EXCEPTION
    WHEN OTHERS THEN
        -- טיפול בשגיאות בלתי צפויות
        RAISE EXCEPTION 'אירעה שגיאה בעדכון סטטוס ההזמנה: %', SQLERRM;
END;
$$;

-- =========================================================
-- Procedure 3 - Test
-- =========================================================

-- הרצת הפרוצדורה לעדכון הזמנה 501 לסטטוס 'Completed'
-- CALL update_supply_order_status(501, 'Completed');

-- בדיקה שהסטטוס וזמן העדכון אכן השתנו בטבלה
SELECT 
    order_id, 
    order_status, 
    updated_at 
FROM supplyorder 
WHERE order_id = 501;