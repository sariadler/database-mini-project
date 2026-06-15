import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port="5432",
        database="stage4_test_db",
        user="postgres",
        password="1234"
    )

    cursor = conn.cursor()
    cursor.execute("SELECT current_database();")
    db_name = cursor.fetchone()

    print("Connected successfully!")
    print("Database:", db_name[0])

    cursor.close()
    conn.close()

except Exception as e:
    print("Connection failed:")
    print(e)