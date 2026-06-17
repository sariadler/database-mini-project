import psycopg2


def get_connection():
    """
    פונקציה דינמית ליצירת חיבור למסד הנתונים.
    תומכת במספר סביבות עבודה של חברי הצוות.
    """

    configs = [
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

        # =======================
        #שרי 
        # =========================
        {
            "host": "localhost",
            "port": "5432",
            "database": "stage4_test_db",
            "user": "postgres",
            "password": "1234"
        },

        # =========================
        #  חני
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