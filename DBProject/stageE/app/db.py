import psycopg2

def get_connection():
    return psycopg2.connect(
        host="localhost",
        port="5432",
        database="stage4_test_db",
        user="postgres",
        password="1234"
    )