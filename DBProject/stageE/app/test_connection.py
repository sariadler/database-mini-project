import psycopg2
import traceback

# =================================================================
# גרסת המקור מהארכיון (נשמרת כגיבוי בתוך הערה):
# =================================================================
# import psycopg2
# try:
#     conn = psycopg2.connect(
#         host="localhost",
#         port="5432",
#         database="stage4_test_db",
#         user="postgres",
#         password="1234"
#     )
#     print("Connected successfully!")
#     conn.close()
# except Exception as e:
#     print("Connection failed:")
#     print(e)
# =================================================================


# =================================================================
# מנגנון בדיקה לאיתור וניתוח שגיאות תקשורת מול מסד הנתונים
# הקוד מנסה להתחבר ומדפיס Traceback מפורט במקרה של כישלון
# =================================================================
print("Starting connection tests...")

try:
    try:
        # בדיקת התחברות ראשונית מול שרת א' (הגדרות המחשב שלה)
        print("Attempting connection with credentials (User: postgres, DB: stage4_test_db)...")
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            database="stage4_test_db",
            user="postgres",
            password="1234"
        )
    except psycopg2.OperationalError:
        # מעבר אוטומטי לבדיקת שרת ב' (הגדרות המחשב שלך)
        print("First attempt failed. Switching to credentials (User: Chani, DB: Project_DB)...")
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            database="Project_DB",
            user="Chani",
            password="Chani"
        )

    # שלב אימות החיבור מול מסד הנתונים הקיים
    cursor = conn.cursor()
    cursor.execute("SELECT current_database();")
    db_name = cursor.fetchone()

    print("\n=========================================")
    print("SUCCESS: Connected successfully!")
    print(f"Database Name: {db_name[0]}")
    print("=========================================")

    cursor.close()
    conn.close()

except Exception as e:
    print("\n=========================================")
    print("CRITICAL ERROR: Connection failed on both attempts!")
    print("Detailed error explanation:")
    print("=========================================")
    # הדפסת השגיאה המלאה שמסבירה למה זה לא מצליח להתחבר אצלך
    traceback.print_exc()
    print("=========================================")