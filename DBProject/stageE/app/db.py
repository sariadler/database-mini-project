import psycopg2

# =================================================================
# גרסת המקור מהארכיון (נשמרת כגיבוי בתוך הערה):
# =================================================================
# def get_connection():
#     return psycopg2.connect(
#         host="localhost",
#         port="5432",
#         database="stage4_test_db",
#         user="postgres",
#         password="1234"
#     )
# =================================================================


def get_connection():
    """
    פונקציה דינמית ליצירת חיבור למסד הנתונים (Project_DB).
    הפונקציה תומכת באופן אוטומטי בריבוי סביבות עבודה (מחשבים שונים בצוות)
    ומבצעת ניסוי וטעייה (Fallback) בין הגדרות הסיסמה השונות של חברי הצוות.
    """
    try:
        # ניסיון התחברות ראשון: תואם להגדרות השרת של מחשב א' (סיסמה: 1234)
        return psycopg2.connect(
            host="localhost",
            port="5432",
            database="stage4_test_db",
            user="postgres",
            password="1234"
        )
    except psycopg2.OperationalError:
        # ניסיון התחברות שני: מופעל אוטומטית אם הראשון נכשל, תואם למחשב ב'
        return psycopg2.connect(
            host="localhost",
            port="5432",
            database="Project_DB",
            user="Chani",
            password="Chani"
        )