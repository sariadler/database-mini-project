-- =========================================================
-- Function: get_employee_experience_rank
-- Description:
-- Calculates the years of experience of an employee based on hiring date
-- and returns a rank (Junior, Mid-Level, Senior, or Expert).
-- Uses: Exception handling, date calculations, IF-ELSIF logic.
-- =========================================================

CREATE OR REPLACE FUNCTION get_employee_experience_rank(p_e_id INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    -- הגדרת משתנים לשמירת הנתונים הזמניים
    v_hire_date DATE;    -- תאריך הגיוס
    v_years_diff INT;    -- הפרש השנים
    v_rank TEXT;         -- הדרגה הסופית
BEGIN
    -- שליפת תאריך הגיוס של העובד מהטבלה לפי מזהה
    SELECT E_date INTO v_hire_date
    FROM Employee
    WHERE E_id = p_e_id;

    -- בדיקה האם העובד נמצא במערכת - אם לא, הקפצת שגיאה
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee with ID % does not exist', p_e_id;
    END IF;

    -- חישוב הפרש השנים בין היום לתאריך הגיוס
    v_years_diff := EXTRACT(YEAR FROM AGE(CURRENT_DATE, v_hire_date));

    -- קביעת הדירוג לפי כמות השנים (לוגיקת תנאים)
    IF v_years_diff < 2 THEN
        v_rank := 'Junior';
    ELSIF v_years_diff < 5 THEN
        v_rank := 'Mid-Level';
    ELSIF v_years_diff < 10 THEN
        v_rank := 'Senior';
    ELSE
        v_rank := 'Expert';
    END IF;

    -- החזרת התוצאה
    RETURN v_rank;

EXCEPTION
    -- טיפול בכל שגיאה בלתי צפויה שתקרה במהלך הריצה
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error in get_employee_experience_rank: %', SQLERRM;
END;
$$;