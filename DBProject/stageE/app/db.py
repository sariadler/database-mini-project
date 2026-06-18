import os
import psycopg2


def get_connection():
    """
    פונקציה דינמית ליצירת חיבור למסד הנתונים.
    קודם מנסה להתחבר לפי משתני סביבה כלליים.
    אם לא הוגדרו משתני סביבה, או שהחיבור נכשל,
    היא מנסה את הגדרות החיבור של חברות הצוות.
    """

    configs = [
        # =========================
        # אפשרות כללית - משתני סביבה
        # =========================
        {
            "host": os.getenv("DB_HOST", "localhost"),
            "port": os.getenv("DB_PORT", "5432"),
            "database": os.getenv("DB_NAME", "stage4_test_db"),
            "user": os.getenv("DB_USER", "postgres"),
            "password": os.getenv("DB_PASSWORD", "1234")
        },

        # =========================
        # מיכל
        # =========================
        {
            "host": "localhost",
            "port": "5432",
            "database": "stageE",
            "user": "postgres",
            "password": "326677861"
        },

        # =========================
        # שרי
        # =========================
        {
            "host": "localhost",
            "port": "5432",
            "database": "stage4_test_db",
            "user": "postgres",
            "password": "1234"
        },

        # =========================
        # חני
        # =========================
        {
            "host": "localhost",
            "port": "5432",
            "database": "Project_DB",
            "user": "Chani",
            "password": "Chani"
        }
    ]

    last_error = None

    for config in configs:
        try:
            return psycopg2.connect(**config)
        except psycopg2.OperationalError as e:
            last_error = e

    raise last_error