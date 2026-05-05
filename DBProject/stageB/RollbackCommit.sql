-- =========================================================
-- ROLLBACK
-- Demonstrate rollback after updating raw material price
-- =========================================================

-- מצב לפני השינוי
SELECT *
FROM rawmaterial
WHERE r_id = 5002;

-- תחילת פעולה על בסיס הנתונים
BEGIN;

-- עדכון המחיר בעוד 11 שקל אצל חומר גלם 5002
UPDATE rawmaterial
SET r_price = r_price + 11
WHERE r_id = 5002;

-- מצב אחרי העדכון הזמני
SELECT *
FROM rawmaterial
WHERE r_id = 5002;

-- ביטול השינוי וחזרה לערך לפני העדכון
ROLLBACK;

-- בדיקה שהערך חזר לקדמותו
SELECT *
FROM rawmaterial
WHERE r_id = 5002;


-- =========================================================
-- COMMIT
-- Demonstrate commit after updating department budget
-- =========================================================

-- מצב לפני השינוי
SELECT *
FROM department
WHERE de_id = 1;

-- התחלת טרנזקציה
BEGIN;

-- עדכון התקציב של מחלקה מספר 1
UPDATE department
SET budget = budget + 5000
WHERE de_id = 1;

-- מצב אחרי העדכון
SELECT *
FROM department
WHERE de_id = 1;

-- שמירת השינוי לצמיתות
COMMIT;

-- מצב אחרי COMMIT
SELECT *
FROM department
WHERE de_id = 1;