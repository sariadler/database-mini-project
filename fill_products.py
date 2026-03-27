import random

def generate_products(num_records=500):
    product_types = ["נעלי ספורט", "מגפי עור", "סנדלי ערב", "סניקרס", "נעלי עקב", "מוקסינים", "נעלי ילדים"]
    brands = ["Premium Step", "Urban Walk", "Elite Shoes", "Comfort Sole"]
    sql_commands = []
    
    for i in range(1, num_records + 1):
        p_id = i
        p_name = f"'{random.choice(product_types)} {random.choice(brands)} {random.randint(10, 99)}'"
        
        # הוספת ערכי NULL רנדומליים לשדה תיאור/קטגוריה אם קיים בטבלה שלך
        # אם אין לך עמודות נוספות, הקוד הזה רק ייצור את ה-ID והשם
        sql = f"INSERT INTO public.product (p_id, p_name) VALUES ({p_id}, {p_name});"
        sql_commands.append(sql)
    
    return sql_commands

commands = generate_products(500)
with open('insert_products.sql', 'w', encoding='utf-8') as f:
    for cmd in commands:
        f.write(cmd + "\n")

print("הקובץ insert_products.sql נוצר עם 500 מוצרים!")