/* תיעוד בסיס הנתונים - שאילתות בדיקה
   תיאור: השאילתה הבאה משמשת לבדיקת תקינות הקשרים (Foreign Keys) בבסיס הנתונים.
   שימוש: יש להריץ ב-pgAdmin כדי לוודא שהחיבורים בין הטבלאות הוגדרו בהצלחה.
   בדיקה נוכחית: טבלת 'works_on'.
*/

SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table,
    ccu.column_name AS foreign_column 
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_name = 'works_on';